import api from './api';

export const resultsService = {
  // Get student results
  getStudentResults: async () => {
    const response = await api.get('/results/');
    return response.data;
  },

  // Get consolidated results grouped by year/semester
  getConsolidatedResults: async () => {
    const response = await api.get('/results/consolidated/');
    return response.data;
  },

  // Get all results (admin)
  getAllResults: async (filters = {}) => {
    const params = new URLSearchParams();
    if (filters.semester) params.append('semester', filters.semester);
    if (filters.hallTicket) params.append('hall_ticket', filters.hallTicket);
    if (filters.year) params.append('year', filters.year);
    
    const response = await api.get(`/results/all/?${params.toString()}`);
    return response.data;
  },

  // Get uploaded exams list (admin)
  getUploadedExams: async () => {
    const response = await api.get('/exams/');
    return response.data;
  },

  // Download exam results as Excel (admin)
  downloadExamResults: async (examName) => {
    const response = await api.get(`/exams/${encodeURIComponent(examName)}/download/`, {
      responseType: 'blob',
    });
    
    // Create download link
    const url = window.URL.createObjectURL(new Blob([response.data]));
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', `${examName.replace(/ /g, '_')}.xlsx`);
    document.body.appendChild(link);
    link.click();
    link.remove();
    window.URL.revokeObjectURL(url);
    
    return response.data;
  },

  // Upload results (admin)
  uploadResults: async (file, year, semester, resultType, course, examHeldDate) => {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('year', year);
    formData.append('semester', semester);
    formData.append('result_type', resultType);
    formData.append('course', course);
    if (examHeldDate) {
      formData.append('exam_held_date', examHeldDate);
    }

    const response = await api.post('/results/upload/', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
    return response.data;
  },

  // Get statistics (admin)
  getStatistics: async (examName = null, resultType = 'all', branch = 'all') => {
    let url = '/statistics/?';
    if (examName) url += `exam_name=${encodeURIComponent(examName)}&`;
    if (resultType && resultType !== 'all') url += `result_type=${resultType}&`;
    if (branch && branch !== 'all') url += `branch=${branch}&`;
    const response = await api.get(url);
    return response.data;
  },

  // Download sample template (admin)
  // Get dashboard stats (admin)
  getDashboardStats: async () => {
    const response = await api.get('/dashboard-stats/');
    return response.data;
  },
  downloadSampleTemplate: async () => {
    const response = await api.get('/sample-template/', {
      responseType: 'blob'
    });
    const url = window.URL.createObjectURL(new Blob([response.data]));
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', 'SPMVV_Results_Template.xlsx');
    document.body.appendChild(link);
    link.click();
    link.remove();
    window.URL.revokeObjectURL(url);
    return response.data;
  },

  // Get session-wise audit logs (admin) - last 5 days
  getAuditLogs: async (filters = {}) => {
    const params = new URLSearchParams();
    if (filters.user) params.append('user', filters.user);
    if (filters.action) params.append('action', filters.action);
    const query = params.toString();
    const response = await api.get(`/audit-logs/${query ? '?' + query : ''}`);
    return response.data;
  },

  // Get result by hall ticket (admin)
  getResultByHallTicket: async (hallTicketNumber) => {
    const response = await api.get(`/results/hall-ticket/${hallTicketNumber}`);
    return response.data;
  },

  // Delete result (admin)
  deleteResult: async (resultId) => {
    const response = await api.delete(`/results/${resultId}`);
    return response.data;
  },

  // Delete exam results (admin)
  deleteExamResults: async (examName) => {
    const response = await api.delete(`/exams/${encodeURIComponent(examName)}/delete/`);
    return response.data;
  },
};

// Student Management APIs
export const studentService = {
  // Search students by roll number
  searchStudent: async (query) => {
    const response = await api.get(`/students/search/?q=${encodeURIComponent(query)}`);
    return response.data;
  },

  // Get student semester-wise history
  getStudentHistory: async (rollNumber) => {
    const response = await api.get(`/students/${encodeURIComponent(rollNumber)}/history/`);
    return response.data;
  },

  // Get subject details for a specific semester
  getSemesterSubjects: async (resultId) => {
    const response = await api.get(`/semesters/${resultId}/subjects/`);
    return response.data;
  },

  // Update subject marks
  updateSubjectMarks: async (subjectId, data) => {
    const response = await api.put(`/subjects/${subjectId}/update/`, data);
    return response.data;
  },
};

// Detained Students service
export const detainedService = {
  // Get detained students with filters
  getDetainedStudents: async ({ year, semester, branch, course, credits, operator, exam_month_year }) => {
    const params = new URLSearchParams();
    if (year) params.append('year', year);
    if (semester) params.append('semester', semester);
    if (branch && branch !== 'all') params.append('branch', branch);
    if (course && course !== 'all') params.append('course', course);
    params.append('credits', credits);
    params.append('operator', operator);
    if (exam_month_year) params.append('exam_month_year', exam_month_year);
    const response = await api.get(`/detained-students/?${params.toString()}`);
    return response.data;
  },
  // Get available exam month-years for filter dropdown
  getExamMonthYears: async () => {
    const response = await api.get('/exam-month-years/');
    return response.data;
  },
};
