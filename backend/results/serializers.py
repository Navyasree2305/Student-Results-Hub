from rest_framework import serializers
from django.contrib.auth.password_validation import validate_password
from .models import Result, Subject, User, Notification, AuditLog, Circular, Exam, ExamSubject, ExamEnrollment, StudentPhoto, HallTicket
from .models import User, Result, Subject, Notification, AuditLog

class UserRegistrationSerializer(serializers.ModelSerializer):
    roll_number = serializers.CharField(required=True)
    password = serializers.CharField(write_only=True, required=True, validators=[validate_password])
    password_confirm = serializers.CharField(write_only=True, required=True)
    
    class Meta:
        model = User
        fields = ['roll_number', 'password', 'password_confirm', 'first_name', 'last_name', 'email', 'branch']
    
    def validate(self, attrs):
        password = attrs.get('password')
        password_confirm = attrs.get('password_confirm')
        if password and password_confirm and password != password_confirm:
            raise serializers.ValidationError({"password": "Password fields didn't match."})

        roll_number = attrs.get('roll_number')
        if roll_number and (
            User.objects.filter(roll_number=roll_number).exists() or
            User.objects.filter(username=roll_number).exists()
        ):
            raise serializers.ValidationError({"roll_number": "An account with this roll number already exists."})

        return attrs
    
    def create(self, validated_data):
        validated_data.pop('password_confirm')
        roll_number = validated_data['roll_number']
        
        user = User.objects.create_user(
            username=roll_number,
            roll_number=roll_number,
            password=validated_data['password'],
            first_name=validated_data.get('first_name', ''),
            last_name=validated_data.get('last_name', ''),
            email=validated_data.get('email', ''),
            branch=validated_data.get('branch', ''),
            role='student'
        )
        return user


class PasswordChangeSerializer(serializers.Serializer):
    old_password = serializers.CharField(required=True, write_only=True)
    new_password = serializers.CharField(required=True, write_only=True, validators=[validate_password])
    new_password_confirm = serializers.CharField(required=True, write_only=True)
    
    def validate(self, attrs):
        if attrs['new_password'] != attrs['new_password_confirm']:
            raise serializers.ValidationError({"new_password": "Password fields didn't match."})
        return attrs


class SubjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Subject
        fields = ['id', 'subject_code', 'subject_name', 'credits', 'internal_marks', 
                  'external_marks', 'total_marks', 'grade', 'attempts']


class ResultSerializer(serializers.ModelSerializer):
    subjects = SubjectSerializer(many=True, read_only=True)
    result_type_display = serializers.CharField(source='get_result_type_display', read_only=True)
    
    class Meta:
        model = Result
        fields = ['id', 'roll_number', 'student_name', 'year', 'semester', 'exam_name', 
                  'result_type', 'result_type_display', 'overall_result', 'total_marks', 'sgpa',
                  'completion_date', 'subjects', 'uploaded_at', 'updated_at']


class NotificationSerializer(serializers.ModelSerializer):
    results_published_date_formatted = serializers.SerializerMethodField()
    result_id = serializers.IntegerField(source='result.id', read_only=True)
    
    class Meta:
        model = Notification
        fields = ['id', 'message', 'exam_name', 'results_published_date', 
                  'results_published_date_formatted', 'result_id', 'is_read', 'created_at']
    
    def get_results_published_date_formatted(self, obj):
        if obj.results_published_date:
            # Format as DD-MMM-YYYY (e.g., 07-Feb-2026)
            return obj.results_published_date.strftime('%d-%b-%Y')
        return None


class AuditLogSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', read_only=True)
    user_role = serializers.CharField(source='user.role', read_only=True)
    action_display = serializers.CharField(source='get_action_display', read_only=True)

    class Meta:
        model = AuditLog
        fields = [
            'id', 'username', 'user_role', 'action', 'action_display',
            'details', 'ip_address', 'timestamp', 'session_id',
        ]


class NullableIntegerField(serializers.IntegerField):
    """IntegerField that treats empty string as None (for multipart/form-data)."""
    def to_internal_value(self, data):
        if data == "" or data is None:
            return None
        return super().to_internal_value(data)


class CircularSerializer(serializers.ModelSerializer):
    created_by_name = serializers.CharField(source="created_by.username", read_only=True)
    created_at_formatted = serializers.SerializerMethodField()
    file_extension = serializers.SerializerMethodField()
    file_url = serializers.SerializerMethodField()
    # Allow empty string from multipart/form-data to be treated as null
    target_year = NullableIntegerField(allow_null=True, required=False)

    class Meta:
        model = Circular
        fields = [
            "id", "title", "category", "description", "attachment", "attachment_name",
            "is_active", "target_audience", "target_year", "target_branch", "created_by", "created_by_name",
            "created_at", "created_at_formatted", "updated_at", "file_extension", "file_url"
        ]
        read_only_fields = ["created_by", "created_at", "updated_at"]
    
    def get_created_at_formatted(self, obj):
        return obj.created_at.strftime("%d-%b-%Y %I:%M %p")
    
    def get_file_extension(self, obj):
        return obj.get_file_extension()
    
    def get_file_url(self, obj):
        if obj.attachment:
            request = self.context.get("request")
            if request:
                return request.build_absolute_uri(obj.attachment.url)
            return obj.attachment.url
        return None



# ==================== HALL TICKET SERIALIZERS ====================

class ExamSubjectSerializer(serializers.ModelSerializer):
    """Serializer for exam subjects"""
    class Meta:
        model = ExamSubject
        fields = ["id", "subject_code", "subject_name", "subject_type", "exam_date", "exam_time", "duration", "order"]
        extra_kwargs = {
            'exam_date': {'required': False, 'allow_null': True}
        }


class ExamSerializer(serializers.ModelSerializer):
    """Serializer for exams with nested subjects"""
    subjects = ExamSubjectSerializer(many=True, read_only=True)
    created_by_name = serializers.CharField(source="created_by.username", read_only=True)
    enrollment_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Exam
        fields = ["id", "exam_name", "year", "semester", "course", 
                  "branch", "exam_center", "exam_start_time", "exam_end_time", "instructions",
                  "is_active", "created_by", "created_by_name", "created_at", "updated_at",
                  "subjects", "enrollment_count"]
        read_only_fields = ["created_by", "created_at", "updated_at"]
    
    def get_enrollment_count(self, obj):
        return obj.enrollments.count()


class ExamEnrollmentSerializer(serializers.ModelSerializer):
    """Serializer for exam enrollments"""
    exam_name = serializers.CharField(source="exam.exam_name", read_only=True)
    has_photo = serializers.SerializerMethodField()
    has_hall_ticket = serializers.SerializerMethodField()
    
    class Meta:
        model = ExamEnrollment
        fields = ["id", "exam", "exam_name", "roll_number", "student_name", 
                  "student", "enrolled_at", "has_photo", "has_hall_ticket"]
        read_only_fields = ["enrolled_at"]
    
    def get_has_photo(self, obj):
        if obj.student:
            return hasattr(obj.student, "hall_ticket_photo") and obj.student.hall_ticket_photo.consent_given
        return False
    
    def get_has_hall_ticket(self, obj):
        return hasattr(obj, "hall_ticket")


class StudentPhotoSerializer(serializers.ModelSerializer):
    """Serializer for student photos"""
    photo_url = serializers.SerializerMethodField()
    
    class Meta:
        model = StudentPhoto
        fields = ["student", "roll_number", "photo", "photo_url", "consent_given", 
                  "consent_text", "consent_date", "uploaded_at", "updated_at"]
        read_only_fields = ["uploaded_at", "updated_at"]
    
    def get_photo_url(self, obj):
        if obj.photo:
            request = self.context.get("request")
            if request:
                return request.build_absolute_uri(obj.photo.url)
            return obj.photo.url
        return None


class HallTicketSerializer(serializers.ModelSerializer):
    """Serializer for hall tickets"""
    exam_name = serializers.CharField(source="exam.exam_name", read_only=True)
    exam_details = ExamSerializer(source="exam", read_only=True)
    enrollment_details = ExamEnrollmentSerializer(source="enrollment", read_only=True)
    roll_number = serializers.CharField(source="enrollment.roll_number", read_only=True)
    student_name = serializers.CharField(source="enrollment.student_name", read_only=True)
    pdf_url = serializers.SerializerMethodField()
    
    class Meta:
        model = HallTicket
        fields = ["id", "hall_ticket_number", "exam", "exam_name", "exam_details",
                  "enrollment", "enrollment_details", "roll_number", "student_name",
                  "pdf_file", "pdf_url", "qr_code_data", "status", "download_count",
                  "generated_at", "downloaded_at", "generated_by"]
        read_only_fields = ["hall_ticket_number", "qr_code_data", "generated_at", "generated_by"]
    
    def get_pdf_url(self, obj):
        if obj.pdf_file:
            request = self.context.get("request")
            if request:
                return request.build_absolute_uri(obj.pdf_file.url)
            return obj.pdf_file.url
        return None

