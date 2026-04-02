from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User, Result, Subject, Notification, AuditLog, LoginAttempt, Circular


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = ('username', 'roll_number', 'role', 'first_name', 'last_name', 'email', 'is_active', 'date_joined')
    list_filter = ('role', 'is_active', 'is_staff', 'date_joined')
    search_fields = ('username', 'roll_number', 'first_name', 'last_name', 'email')
    ordering = ('-date_joined',)
    
    fieldsets = BaseUserAdmin.fieldsets + (
        ('Custom Fields', {'fields': ('role', 'roll_number')}),
    )
    
    add_fieldsets = BaseUserAdmin.add_fieldsets + (
        ('Custom Fields', {'fields': ('role', 'roll_number')}),
    )


class SubjectInline(admin.TabularInline):
    model = Subject
    extra = 0
    fields = ('subject_code', 'subject_name', 'credits', 'total_marks', 'grade')
    readonly_fields = ('subject_code', 'subject_name', 'credits', 'total_marks', 'grade')


@admin.register(Result)
class ResultAdmin(admin.ModelAdmin):
    list_display = ('roll_number', 'student_name', 'semester', 'result_type', 'total_marks', 'sgpa', 'overall_result', 'uploaded_by', 'uploaded_at')
    list_filter = ('semester', 'result_type', 'overall_result', 'uploaded_at')
    search_fields = ('roll_number', 'student_name', 'student__username')
    ordering = ('-uploaded_at',)
    readonly_fields = ('uploaded_at', 'updated_at')
    inlines = [SubjectInline]
    
    fieldsets = (
        ('Student Information', {
            'fields': ('student', 'roll_number', 'student_name')
        }),
        ('Result Information', {
            'fields': ('semester', 'result_type', 'total_marks', 'sgpa', 'overall_result')
        }),
        ('Metadata', {
            'fields': ('uploaded_by', 'uploaded_at', 'updated_at')
        }),
    )
    
    def get_readonly_fields(self, request, obj=None):
        if obj:  # Editing existing object
            return self.readonly_fields + ('student', 'roll_number', 'uploaded_by')
        return self.readonly_fields


@admin.register(Subject)
class SubjectAdmin(admin.ModelAdmin):
    list_display = ('subject_code', 'subject_name', 'result', 'credits', 'total_marks', 'grade')
    list_filter = ('grade',)
    search_fields = ('subject_code', 'subject_name', 'result__roll_number', 'result__student_name')
    ordering = ('result', 'subject_code')


@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    list_display = ('student', 'message_preview', 'is_read', 'created_at')
    list_filter = ('is_read', 'created_at')
    search_fields = ('student__username', 'student__roll_number', 'message')
    ordering = ('-created_at',)
    readonly_fields = ('created_at',)
    
    def message_preview(self, obj):
        return obj.message[:50] + '...' if len(obj.message) > 50 else obj.message
    message_preview.short_description = 'Message'


@admin.register(AuditLog)
class AuditLogAdmin(admin.ModelAdmin):
    list_display = ('user', 'action', 'ip_address', 'timestamp', 'details_preview')
    list_filter = ('action', 'timestamp')
    search_fields = ('user__username', 'action', 'details', 'ip_address')
    ordering = ('-timestamp',)
    readonly_fields = ('user', 'action', 'details', 'ip_address', 'timestamp')
    
    def details_preview(self, obj):
        return obj.details[:50] + '...' if len(obj.details) > 50 else obj.details
    details_preview.short_description = 'Details'
    
    def has_add_permission(self, request):
        return False
    
    def has_change_permission(self, request, obj=None):
        return False
    
    def has_delete_permission(self, request, obj=None):
        return request.user.is_superuser


@admin.register(LoginAttempt)
class LoginAttemptAdmin(admin.ModelAdmin):
    list_display = ('username', 'ip_address', 'timestamp', 'success')
    list_filter = ('success', 'timestamp')
    search_fields = ('username', 'ip_address')
    ordering = ('-timestamp',)
    readonly_fields = ('username', 'ip_address', 'timestamp', 'success')
    
    def has_add_permission(self, request):
        return False
    
    def has_change_permission(self, request, obj=None):
        return False
    
    def has_delete_permission(self, request, obj=None):
        return request.user.is_superuser


@admin.register(Circular)
class CircularAdmin(admin.ModelAdmin):
    list_display = ["title", "category", "created_by", "is_active", "created_at"]
    list_filter = ["category", "is_active", "target_year", "target_branch"]
    search_fields = ["title", "description"]
    readonly_fields = ["created_by", "created_at", "updated_at"]
