import React, { useState } from 'react';
import { studentService } from '../services/resultsService';
import { FaChevronDown, FaChevronUp, FaBookOpen, FaSync } from 'react-icons/fa';
import Toast from './Toast';

const PASS_GRADES = new Set(['O', 'A', 'B', 'C', 'D']);

function ResultBadge({ result }) {
  const pass = result === 'Pass';
  return (
    <span className={`inline-block px-2.5 py-0.5 rounded-full text-xs font-semibold ${
      pass ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'
    }`}>
      {result}
    </span>
  );
}

function PendingBadge({ count }) {
  if (count === 0) return <span className="text-gray-300 text-sm">—</span>;
  return (
    <span className="inline-block px-2.5 py-0.5 rounded-full text-xs font-semibold bg-orange-100 text-orange-700">
      {count}
    </span>
  );
}

const SemesterSummaryTable = ({ studentInfo, semesterSummary, onRefresh }) => {
  const [expandedGroup, setExpandedGroup] = useState(null);
  const [expandedExam, setExpandedExam]   = useState(null);
  const [subjectDetails, setSubjectDetails] = useState({});
  const [loading, setLoading]   = useState({});
  const [toast, setToast]       = useState(null);

  const groupedData = React.useMemo(() => {
    if (!semesterSummary?.length) return [];
    const groups = {};
    semesterSummary.forEach(item => {
      const key = `${item.year}-${item.semester}`;
      if (!groups[key]) groups[key] = { year: item.year, semester: item.semester, attempts: [] };
      groups[key].attempts.push(item);
    });
    Object.values(groups).forEach(g => {
      g.attempts.sort((a, b) => new Date(a.uploaded_at) - new Date(b.uploaded_at));
      g.latestAttempt = g.attempts[g.attempts.length - 1];
    });
    return Object.values(groups).sort((a, b) =>
      a.year !== b.year ? a.year - b.year : a.semester - b.semester
    );
  }, [semesterSummary]);

  const toggleGroup = (key) => {
    setExpandedGroup(prev => prev === key ? null : key);
    setExpandedExam(null);
  };

  const toggleExam = async (resultId) => {
    if (expandedExam === resultId) { setExpandedExam(null); return; }
    setExpandedExam(resultId);
    if (!subjectDetails[resultId]) {
      setLoading(l => ({ ...l, [resultId]: true }));
      try {
        const data = await studentService.getSemesterSubjects(resultId);
        setSubjectDetails(d => ({ ...d, [resultId]: data.subjects }));
      } catch {
        setToast({ message: 'Failed to load subject details', type: 'error' });
      } finally {
        setLoading(l => ({ ...l, [resultId]: false }));
      }
    }
  };

  return (
    <div className="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">

      {/* Header */}
      <div className="flex items-start justify-between px-6 py-4 bg-gray-50 border-b border-gray-200">
        <div>
          <h2 className="text-base font-semibold text-gray-800">Results History</h2>
          {studentInfo && (
            <p className="text-sm text-gray-500 mt-0.5">
              <span className="font-mono font-medium text-gray-700">{studentInfo.roll_number}</span>
              {' · '}{studentInfo.student_name}
              {' · '}<span className="uppercase">{studentInfo.course} – {studentInfo.branch}</span>
            </p>
          )}
        </div>
        {onRefresh && (
          <button
            onClick={onRefresh}
            className="flex items-center gap-1.5 text-xs text-gray-500 hover:text-gray-700 border border-gray-300 px-3 py-1.5 rounded-lg hover:bg-gray-100 transition-colors"
          >
            <FaSync className="text-xs" /> Refresh
          </button>
        )}
      </div>

      {/* Body */}
      {groupedData.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-16 text-gray-400">
          <FaBookOpen className="text-4xl mb-3 opacity-20" />
          <p>No semester data available</p>
        </div>
      ) : (
        <div className="divide-y divide-gray-100">
          {groupedData.map((group) => {
            const groupKey = `${group.year}-${group.semester}`;
            const isOpen   = expandedGroup === groupKey;
            const latest   = group.latestAttempt;
            const multiAttempt = group.attempts.length > 1;

            return (
              <div key={groupKey}>
                {/* Semester row */}
                <button
                  type="button"
                  onClick={() => toggleGroup(groupKey)}
                  className="w-full flex items-center gap-4 px-6 py-4 hover:bg-gray-50 transition-colors text-left"
                >
                  {/* Year / Sem label */}
                  <div className="flex-shrink-0 w-28">
                    <span className="text-xs font-semibold uppercase tracking-wide text-gray-400">
                      Year {group.year} · Sem {group.semester}
                    </span>
                  </div>

                  {/* Stats */}
                  <div className="flex flex-1 items-center gap-6 flex-wrap">
                    <div className="text-center">
                      <p className="text-xs text-gray-400 mb-0.5">Total Marks</p>
                      <p className="text-sm font-semibold text-blue-600">{latest.total_marks ?? 'N/A'}</p>
                    </div>
                    <div className="text-center">
                      <p className="text-xs text-gray-400 mb-0.5">Credits</p>
                      <p className="text-sm font-semibold text-blue-600">
                        {latest.earned_credits ?? '—'}
                      </p>
                    </div>
                    <div className="text-center">
                      <p className="text-xs text-gray-400 mb-0.5">SGPA</p>
                      <p className="text-sm font-semibold text-blue-600">
                        {latest.consolidated_sgpa != null ? latest.consolidated_sgpa.toFixed(2) : (latest.sgpa ? latest.sgpa.toFixed(2) : 'N/A')}
                      </p>
                    </div>
                    <div className="text-center">
                      <p className="text-xs text-gray-400 mb-0.5">Result</p>
                      <ResultBadge result={latest.consolidated_result ?? latest.overall_result} />
                    </div>
                    <div className="text-center">
                      <p className="text-xs text-gray-400 mb-0.5">Pending</p>
                      <PendingBadge count={latest.consolidated_pending ?? latest.pending_subjects} />
                    </div>
                    {(latest.consolidated_pending ?? latest.pending_subjects) > 0 && (latest.consolidated_pending_names ?? latest.pending_subject_names)?.length > 0 && (
                      <div className="text-left">
                        <p className="text-xs text-gray-400 mb-0.5">Pending Subjects</p>
                        <p className="text-xs text-orange-600 font-medium">{(latest.consolidated_pending_names ?? latest.pending_subject_names).join(', ')}</p>
                      </div>
                    )}
                    {multiAttempt && (
                      <span className="text-xs text-gray-400 italic">{group.attempts.length} attempts</span>
                    )}
                  </div>

                  {/* Chevron */}
                  <div className="flex-shrink-0 text-gray-400">
                    {isOpen ? <FaChevronUp /> : <FaChevronDown />}
                  </div>
                </button>

                {/* Expanded: attempts list */}
                {isOpen && (
                  <div className="bg-gray-50 border-t border-gray-100 px-6 py-4">
                    <p className="text-xs font-semibold uppercase tracking-wide text-gray-400 mb-3">
                      Exam Attempts
                    </p>
                    <div className="space-y-3">
                      {group.attempts.map((attempt, idx) => {
                        const examOpen = expandedExam === attempt.result_id;
                        return (
                          <div key={attempt.result_id} className="bg-white rounded-xl border border-gray-200 overflow-hidden">
                            {/* Attempt header row */}
                            <button
                              type="button"
                              onClick={() => toggleExam(attempt.result_id)}
                              className="w-full flex items-center gap-4 px-5 py-3 hover:bg-gray-50 transition-colors text-left"
                            >
                              <span className="flex-shrink-0 w-5 h-5 rounded-full bg-gray-100 text-gray-500 text-xs font-bold flex items-center justify-center">
                                {idx + 1}
                              </span>
                              <div className="flex-1 min-w-0">
                                <p className="text-sm font-medium text-gray-800 truncate">{attempt.exam_name}</p>
                                <p className="text-xs text-gray-400">
                                  {new Date(attempt.uploaded_at).toLocaleDateString('en-IN', {
                                    day: '2-digit', month: 'short', year: 'numeric'
                                  })}
                                </p>
                              </div>
                              <div className="flex items-center gap-4 flex-shrink-0">
                                <div className="text-center hidden sm:block">
                                  <p className="text-xs text-gray-400">Marks</p>
                                  <p className="text-sm font-semibold text-blue-600">{attempt.total_marks ?? 'N/A'}</p>
                                </div>
                                <div className="text-center hidden sm:block">
                                  <p className="text-xs text-gray-400">Credits</p>
                                  <p className="text-sm font-semibold text-blue-600">
                                    {attempt.earned_credits ?? '—'}
                                  </p>
                                </div>
                                <div className="text-center hidden sm:block">
                                  <p className="text-xs text-gray-400">SGPA</p>
                                  <p className="text-sm font-semibold text-blue-600">
                                    {attempt.sgpa ? attempt.sgpa.toFixed(2) : 'N/A'}
                                  </p>
                                </div>
                                <ResultBadge result={attempt.overall_result} />
                                <PendingBadge count={attempt.pending_subjects} />
                                <span className="text-gray-400">
                                  {examOpen ? <FaChevronUp className="text-xs" /> : <FaChevronDown className="text-xs" />}
                                </span>
                              </div>
                            </button>

                            {/* Pending subject names — shown inline without needing to expand */}
                            {attempt.pending_subjects > 0 && attempt.pending_subject_names?.length > 0 && (
                              <div className="px-5 pb-2.5 flex items-center gap-1.5 flex-wrap">
                                <span className="text-xs text-gray-400">Pending:</span>
                                {attempt.pending_subject_names.map((name, i) => (
                                  <span key={i} className="inline-block bg-orange-50 text-orange-600 border border-orange-200 text-xs px-2 py-0.5 rounded-full">
                                    {name}
                                  </span>
                                ))}
                              </div>
                            )}

                            {/* Subject details */}
                            {examOpen && (
                              <div className="border-t border-gray-100 px-5 py-4">
                                {loading[attempt.result_id] ? (
                                  <div className="flex items-center justify-center py-6 text-gray-400 gap-2">
                                    <svg className="animate-spin h-4 w-4 text-blue-500" viewBox="0 0 24 24" fill="none">
                                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                                      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z" />
                                    </svg>
                                    Loading subjects...
                                  </div>
                                ) : subjectDetails[attempt.result_id] ? (
                                  <div className="overflow-x-auto rounded-lg border border-gray-200">
                                    <table className="w-full text-sm">
                                      <thead className="bg-gray-50 text-gray-500 uppercase text-xs tracking-wider">
                                        <tr>
                                          <th className="px-4 py-2.5 text-left">Code</th>
                                          <th className="px-4 py-2.5 text-left">Subject</th>
                                          <th className="px-4 py-2.5 text-center">Credits</th>
                                          <th className="px-4 py-2.5 text-center">Marks</th>
                                          <th className="px-4 py-2.5 text-center">Grade</th>
                                        </tr>
                                      </thead>
                                      <tbody className="divide-y divide-gray-100">
                                        {subjectDetails[attempt.result_id].map((subject) => {
                                          const passed = PASS_GRADES.has(subject.grade);
                                          return (
                                            <tr key={subject.id} className="hover:bg-gray-50 transition-colors">
                                              <td className="px-4 py-2.5 font-mono text-xs text-gray-600">{subject.subject_code}</td>
                                              <td className="px-4 py-2.5 text-gray-700">{subject.subject_name}</td>
                                              <td className="px-4 py-2.5 text-center text-gray-600">{subject.credits ?? '—'}</td>
                                              <td className="px-4 py-2.5 text-center font-semibold text-blue-600">{subject.total_marks ?? '—'}</td>
                                              <td className="px-4 py-2.5 text-center">
                                                <span className={`inline-block px-2 py-0.5 rounded-full text-xs font-semibold ${
                                                  passed
                                                    ? 'bg-green-100 text-green-700'
                                                    : 'bg-red-100 text-red-700'
                                                }`}>
                                                  {subject.grade || '—'}
                                                </span>
                                              </td>
                                            </tr>
                                          );
                                        })}
                                      </tbody>
                                    </table>
                                  </div>
                                ) : (
                                  <p className="text-sm text-gray-400 text-center py-4">No subject details available.</p>
                                )}
                              </div>
                            )}
                          </div>
                        );
                      })}
                    </div>
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}

      {toast && <Toast message={toast.message} type={toast.type} onClose={() => setToast(null)} />}
    </div>
  );
};

export default SemesterSummaryTable;
