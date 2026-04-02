"""
Subject Difficulty Analyzer - ML Module
Uses scikit-learn to analyze historical exam data and predict subject difficulty.

Features:
1. Difficulty scoring based on fail rates, average marks, grade distribution
2. Random Forest model to predict expected pass rates for subjects
3. Trend analysis across semesters
4. Branch-wise difficulty comparison
"""

import logging
import numpy as np
from collections import defaultdict
from django.db.models import Count, Avg, Q, F

logger = logging.getLogger("django")


class SubjectDifficultyAnalyzer:
    """
    ML-powered subject difficulty analyzer.

    Uses a combination of statistical analysis and Random Forest regression
    to score and rank subjects by difficulty, and predict expected pass rates.
    """

    # Grade point mapping (higher = better)
    GRADE_POINTS = {"O": 10, "A": 9, "B": 8, "C": 7, "D": 6, "F": 0}

    # Difficulty thresholds based on pass rate
    DIFFICULTY_LEVELS = {
        "Very Hard": (0, 30),
        "Hard": (30, 55),
        "Moderate": (55, 75),
        "Easy": (75, 90),
        "Very Easy": (90, 101),
    }

    def __init__(self):
        self.model = None
        self.scaler = None
        self.is_trained = False
        self.feature_importances = {}
        self.feature_names = [
            "avg_total_marks",
            "fail_rate",
            "avg_grade_point",
            "grade_std_dev",
            "avg_attempts",
            "is_lab",
            "internal_external_gap",
        ]

    def _get_grade_point(self, grade):
        """Convert letter grade to numeric grade point."""
        if not grade:
            return 0
        return self.GRADE_POINTS.get(grade.strip().upper(), 0)

    def _get_difficulty_label(self, pass_rate):
        """Get difficulty label from pass rate."""
        for label, (low, high) in self.DIFFICULTY_LEVELS.items():
            if low <= pass_rate < high:
                return label
        return "Moderate"

    def compute_subject_features(self, subjects_qs):
        """
        Compute feature vectors for each subject from a queryset of Subject objects.
        Returns a dict keyed by (subject_code, subject_name) with feature dicts.
        """
        subject_data = defaultdict(
            lambda: {
                "total_marks_list": [],
                "internal_marks_list": [],
                "external_marks_list": [],
                "grades": [],
                "attempts_list": [],
                "is_lab": False,
                "pass_count": 0,
                "fail_count": 0,
                "total_count": 0,
                "branches": set(),
                "result_types": defaultdict(int),
            }
        )

        for subj in subjects_qs.select_related("result"):
            key = (subj.subject_code, subj.subject_name)
            data = subject_data[key]

            grade_upper = subj.grade.strip().upper() if subj.grade else ""

            if subj.total_marks is not None:
                data["total_marks_list"].append(subj.total_marks)
            if subj.internal_marks is not None:
                data["internal_marks_list"].append(subj.internal_marks)
            if subj.external_marks is not None:
                data["external_marks_list"].append(subj.external_marks)
            if grade_upper:
                data["grades"].append(grade_upper)
            data["attempts_list"].append(subj.attempts or 1)
            data["is_lab"] = subj.subject_type == "Lab"
            data["total_count"] += 1

            if grade_upper == "F":
                data["fail_count"] += 1
            elif grade_upper:
                data["pass_count"] += 1

            if subj.result:
                data["branches"].add(subj.result.branch)
                data["result_types"][subj.result.result_type] += 1

        # Now compute features
        features = {}
        for key, data in subject_data.items():
            total = data["total_count"]
            if total < 3:  # skip subjects with too few records
                continue

            marks = data["total_marks_list"]
            internals = data["internal_marks_list"]
            externals = data["external_marks_list"]
            grade_points = [self._get_grade_point(g) for g in data["grades"]]

            avg_marks = float(np.mean(marks)) if marks else 0.0
            fail_rate = (data["fail_count"] / total * 100) if total > 0 else 0.0
            pass_rate = 100.0 - fail_rate
            avg_gp = float(np.mean(grade_points)) if grade_points else 0.0
            gp_std = float(np.std(grade_points)) if len(grade_points) > 1 else 0.0
            avg_attempts = (
                float(np.mean(data["attempts_list"])) if data["attempts_list"] else 1.0
            )

            avg_internal = float(np.mean(internals)) if internals else 0.0
            avg_external = float(np.mean(externals)) if externals else 0.0
            ie_gap = abs(avg_internal - avg_external)

            # Compute a composite difficulty score (0-100, higher = harder)
            # Weighted combination of multiple signals
            difficulty_score = (
                fail_rate * 0.35  # fail rate is the strongest signal
                + (10.0 - avg_gp) * 4.0 * 0.25  # lower avg grade = harder
                + min(gp_std * 10.0, 30.0) * 0.10  # high variance = inconsistent
                + min((avg_attempts - 1.0) * 30.0, 30.0)
                * 0.15  # more attempts = harder
                + max(0.0, 50.0 - avg_marks) * 0.15  # lower avg marks = harder
            )
            difficulty_score = max(0.0, min(100.0, difficulty_score))

            features[key] = {
                "subject_code": key[0],
                "subject_name": key[1],
                "total_students": total,
                "pass_count": data["pass_count"],
                "fail_count": data["fail_count"],
                "pass_rate": round(pass_rate, 2),
                "fail_rate": round(fail_rate, 2),
                "avg_total_marks": round(avg_marks, 2),
                "avg_internal_marks": round(avg_internal, 2),
                "avg_external_marks": round(avg_external, 2),
                "avg_grade_point": round(avg_gp, 2),
                "grade_std_dev": round(gp_std, 2),
                "avg_attempts": round(avg_attempts, 2),
                "is_lab": data["is_lab"],
                "internal_external_gap": round(ie_gap, 2),
                "difficulty_score": round(difficulty_score, 2),
                "difficulty_level": self._get_difficulty_label(pass_rate),
                "branches": list(data["branches"]),
                "regular_count": data["result_types"].get("regular", 0),
                "supplementary_count": data["result_types"].get("supplementary", 0),
                # Feature vector for ML model
                "feature_vector": [
                    avg_marks,
                    fail_rate,
                    avg_gp,
                    gp_std,
                    avg_attempts,
                    1.0 if data["is_lab"] else 0.0,
                    ie_gap,
                ],
            }

        return features

    def train_model(self, features_dict):
        """
        Train a Random Forest model to predict pass rates from subject features.
        This allows predicting difficulty for new/unseen subjects.
        """
        try:
            from sklearn.ensemble import RandomForestRegressor
            from sklearn.preprocessing import StandardScaler

            if len(features_dict) < 5:
                logger.info("Not enough subjects to train ML model (need >= 5)")
                self.is_trained = False
                return False

            X = []
            y = []
            for key, feat in features_dict.items():
                X.append(feat["feature_vector"])
                y.append(feat["pass_rate"])

            X = np.array(X)
            y = np.array(y)

            self.scaler = StandardScaler()
            X_scaled = self.scaler.fit_transform(X)

            self.model = RandomForestRegressor(
                n_estimators=100,
                max_depth=5,
                min_samples_split=3,
                min_samples_leaf=2,
                random_state=42,
                n_jobs=-1,
            )
            self.model.fit(X_scaled, y)
            self.is_trained = True

            # Feature importances
            self.feature_importances = dict(
                zip(self.feature_names, self.model.feature_importances_)
            )

            logger.info(
                f"ML model trained on {len(X)} subjects. "
                f"Feature importances: {self.feature_importances}"
            )
            return True

        except ImportError:
            logger.warning("scikit-learn not installed. ML predictions unavailable.")
            self.is_trained = False
            return False
        except Exception as e:
            logger.error(f"Error training ML model: {e}")
            self.is_trained = False
            return False

    def predict_pass_rate(self, feature_vector):
        """Predict pass rate for a subject given its feature vector."""
        if not self.is_trained or self.model is None:
            return None
        try:
            X = np.array([feature_vector])
            X_scaled = self.scaler.transform(X)
            prediction = float(self.model.predict(X_scaled)[0])
            return round(max(0.0, min(100.0, prediction)), 2)
        except Exception as e:
            logger.error(f"Prediction error: {e}")
            return None

    def get_grade_distribution(self, subjects_qs, subject_code):
        """Get grade distribution for a specific subject."""
        grade_counts = (
            subjects_qs.filter(subject_code=subject_code)
            .exclude(grade="")
            .values("grade")
            .annotate(count=Count("id"))
            .order_by("grade")
        )

        distribution = {}
        for item in grade_counts:
            distribution[item["grade"].upper()] = item["count"]

        return distribution

    def analyze(
        self,
        branch_filter=None,
        year_filter=None,
        semester_filter=None,
        course_filter=None,
        exam_name_filter=None,
    ):
        """
        Main analysis entry point. Queries the database, computes features,
        trains the model, and returns comprehensive analysis results.
        """
        from results.models import Result, Subject

        # Build queryset with filters
        result_qs = Result.objects.all()

        if branch_filter and branch_filter != "all":
            result_qs = result_qs.filter(branch__iexact=branch_filter)
        if year_filter and year_filter != "all":
            result_qs = result_qs.filter(year=int(year_filter))
        if semester_filter and semester_filter != "all":
            result_qs = result_qs.filter(semester=int(semester_filter))
        if course_filter and course_filter != "all":
            result_qs = result_qs.filter(course__iexact=course_filter)
        if exam_name_filter:
            result_qs = result_qs.filter(exam_name=exam_name_filter)

        subjects_qs = Subject.objects.filter(result__in=result_qs)

        total_subject_records = subjects_qs.count()
        if total_subject_records == 0:
            return {
                "status": "no_data",
                "message": "No subject data found for the given filters.",
                "subjects": [],
                "ml_enabled": False,
            }

        # Compute features
        features = self.compute_subject_features(subjects_qs)

        if not features:
            return {
                "status": "insufficient_data",
                "message": "Not enough data to analyze (subjects need >= 3 student records each).",
                "subjects": [],
                "ml_enabled": False,
            }

        # Train ML model
        ml_trained = self.train_model(features)

        # Add ML predictions and grade distributions
        subjects_list = []
        for key, feat in features.items():
            # ML predicted pass rate
            if ml_trained:
                predicted_pass_rate = self.predict_pass_rate(feat["feature_vector"])
                feat["predicted_pass_rate"] = predicted_pass_rate
                if predicted_pass_rate is not None:
                    diff = abs(predicted_pass_rate - feat["pass_rate"])
                    feat["prediction_confidence"] = (
                        "High" if diff < 10 else "Medium" if diff < 20 else "Low"
                    )
                else:
                    feat["prediction_confidence"] = None
            else:
                feat["predicted_pass_rate"] = None
                feat["prediction_confidence"] = None

            # Grade distribution
            feat["grade_distribution"] = self.get_grade_distribution(
                subjects_qs, feat["subject_code"]
            )

            # Remove internal feature vector from response
            del feat["feature_vector"]
            subjects_list.append(feat)

        # Sort by difficulty score (hardest first)
        subjects_list.sort(key=lambda x: x["difficulty_score"], reverse=True)

        # Assign rank
        for i, subj in enumerate(subjects_list):
            subj["rank"] = i + 1

        # Summary statistics
        difficulty_distribution = defaultdict(int)
        for subj in subjects_list:
            difficulty_distribution[subj["difficulty_level"]] += 1

        avg_difficulty = float(np.mean([s["difficulty_score"] for s in subjects_list]))

        # Top 5 hardest and easiest
        top_hardest = subjects_list[:5]
        top_easiest = (
            list(reversed(subjects_list[-5:]))
            if len(subjects_list) >= 5
            else list(reversed(subjects_list))
        )

        # Theory vs Lab comparison
        theory_subjects = [s for s in subjects_list if not s["is_lab"]]
        lab_subjects = [s for s in subjects_list if s["is_lab"]]

        theory_avg_diff = (
            float(np.mean([s["difficulty_score"] for s in theory_subjects]))
            if theory_subjects
            else 0.0
        )
        lab_avg_diff = (
            float(np.mean([s["difficulty_score"] for s in lab_subjects]))
            if lab_subjects
            else 0.0
        )
        theory_avg_pass = (
            float(np.mean([s["pass_rate"] for s in theory_subjects]))
            if theory_subjects
            else 0.0
        )
        lab_avg_pass = (
            float(np.mean([s["pass_rate"] for s in lab_subjects]))
            if lab_subjects
            else 0.0
        )

        response = {
            "status": "success",
            "total_subjects_analyzed": len(subjects_list),
            "total_student_records": total_subject_records,
            "ml_enabled": ml_trained,
            "summary": {
                "avg_difficulty_score": round(avg_difficulty, 2),
                "difficulty_distribution": dict(difficulty_distribution),
                "top_5_hardest": [
                    {
                        "rank": s["rank"],
                        "code": s["subject_code"],
                        "name": s["subject_name"],
                        "difficulty_score": s["difficulty_score"],
                        "pass_rate": s["pass_rate"],
                        "fail_rate": s["fail_rate"],
                    }
                    for s in top_hardest
                ],
                "top_5_easiest": [
                    {
                        "rank": s["rank"],
                        "code": s["subject_code"],
                        "name": s["subject_name"],
                        "difficulty_score": s["difficulty_score"],
                        "pass_rate": s["pass_rate"],
                        "fail_rate": s["fail_rate"],
                    }
                    for s in top_easiest
                ],
                "theory_vs_lab": {
                    "theory": {
                        "count": len(theory_subjects),
                        "avg_difficulty": round(theory_avg_diff, 2),
                        "avg_pass_rate": round(theory_avg_pass, 2),
                    },
                    "lab": {
                        "count": len(lab_subjects),
                        "avg_difficulty": round(lab_avg_diff, 2),
                        "avg_pass_rate": round(lab_avg_pass, 2),
                    },
                },
            },
            "subjects": subjects_list,
        }

        if ml_trained:
            response["feature_importances"] = {
                name: round(imp * 100, 2)
                for name, imp in sorted(
                    self.feature_importances.items(),
                    key=lambda x: x[1],
                    reverse=True,
                )
            }

        return response


# Module-level convenience function
def get_subject_difficulty_analysis(**filters):
    """Run analysis with filters. Creates a fresh analyzer each time."""
    analyzer = SubjectDifficultyAnalyzer()
    return analyzer.analyze(**filters)
