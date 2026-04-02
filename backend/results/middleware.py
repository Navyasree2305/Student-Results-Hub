from django.utils import timezone
from django.conf import settings
from datetime import timedelta
from .models import LoginAttempt, User
import logging

security_logger = logging.getLogger('security')

class LoginAttemptMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)
        return response

    @staticmethod
    def check_login_attempts(username, ip_address):
        """Check if user has exceeded max login attempts using User model"""
        try:
            user = User.objects.get(username=username)
            
            # Check if account is locked
            if user.locked_until and user.locked_until > timezone.now():
                time_remaining = (user.locked_until - timezone.now()).seconds // 60
                security_logger.warning(
                    f"Account is locked: {username} from {ip_address}. {time_remaining} minutes remaining"
                )
                return False
            
            # If lock expired, reset the counter
            if user.locked_until and user.locked_until <= timezone.now():
                user.failed_login_attempts = 0
                user.locked_until = None
                user.save()
            
            return True
        except User.DoesNotExist:
            # Still check IP-based attempts for non-existent users
            timeout_time = timezone.now() - timedelta(seconds=settings.LOGIN_ATTEMPT_TIMEOUT)
            recent_attempts = LoginAttempt.objects.filter(
                username=username,
                timestamp__gte=timeout_time,
                success=False
            ).count()
            
            if recent_attempts >= settings.MAX_LOGIN_ATTEMPTS:
                security_logger.warning(
                    f"Too many failed attempts for non-existent user: {username} from {ip_address}"
                )
                return False
            return True

    @staticmethod
    def record_login_attempt(username, ip_address, success):
        """Record login attempt in LoginAttempt table and update User model"""
        # Record in LoginAttempt table
        LoginAttempt.objects.create(
            username=username,
            ip_address=ip_address,
            success=success
        )
        
        if not success:
            security_logger.warning(
                f"Failed login attempt: {username} from {ip_address}"
            )
            
            # Update User model failed attempts counter
            try:
                user = User.objects.get(username=username)
                user.failed_login_attempts += 1
                
                # Lock account if max attempts reached
                if user.failed_login_attempts >= settings.MAX_LOGIN_ATTEMPTS:
                    user.locked_until = timezone.now() + timedelta(minutes=30)
                    security_logger.warning(
                        f"Account locked for 30 minutes: {username} after {user.failed_login_attempts} failed attempts"
                    )
                
                user.save()
            except User.DoesNotExist:
                pass

    @staticmethod
    def clear_login_attempts(username):
        """Clear failed login attempts after successful login"""
        timeout_time = timezone.now() - timedelta(seconds=settings.LOGIN_ATTEMPT_TIMEOUT)
        LoginAttempt.objects.filter(
            username=username,
            timestamp__gte=timeout_time
        ).delete()
        
        # Reset User model failed attempts
        try:
            user = User.objects.get(username=username)
            user.failed_login_attempts = 0
            user.locked_until = None
            user.save()
        except User.DoesNotExist:
            pass
    
    @staticmethod
    def get_remaining_attempts(username):
        """Get remaining login attempts for a user"""
        try:
            user = User.objects.get(username=username)
            remaining = settings.MAX_LOGIN_ATTEMPTS - user.failed_login_attempts
            return max(0, remaining)
        except User.DoesNotExist:
            return settings.MAX_LOGIN_ATTEMPTS


class SecurityHeadersMiddleware:
    """Add security headers to all responses"""
    
    def __init__(self, get_response):
        self.get_response = get_response
    
    def __call__(self, request):
        response = self.get_response(request)
        
        # Prevent clickjacking attacks
        response['X-Frame-Options'] = 'DENY'
        
        # Prevent MIME type sniffing
        response['X-Content-Type-Options'] = 'nosniff'
        
        # Enable XSS protection (for older browsers)
        response['X-XSS-Protection'] = '1; mode=block'
        
        # Referrer policy
        response['Referrer-Policy'] = 'strict-origin-when-cross-origin'
        
        # Permissions policy (restrict features)
        response['Permissions-Policy'] = 'geolocation=(), microphone=(), camera=()'
        
        # HTTPS enforcement (only if using HTTPS)
        if request.is_secure():
            response['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains'
        
        return response
