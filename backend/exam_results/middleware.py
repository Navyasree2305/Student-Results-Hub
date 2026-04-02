from django.utils.deprecation import MiddlewareMixin

class MediaCORSMiddleware(MiddlewareMixin):
    """Add CORS headers to media file responses"""
    
    def process_response(self, request, response):
        # Add CORS headers for media files
        if request.path.startswith('/media/'):
            response['Access-Control-Allow-Origin'] = '*'
            response['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
            response['Access-Control-Allow-Headers'] = '*'
            response['Cross-Origin-Resource-Policy'] = 'cross-origin'
        
        return response
