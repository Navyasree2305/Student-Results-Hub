from django.apps import AppConfig


class ResultsConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'results'
    verbose_name = 'SPMVV Exam Results Management'
    
    def ready(self):
        """
        Import signal handlers and perform app initialization
        """
        # Import signals if any
        # import results.signals
        pass
