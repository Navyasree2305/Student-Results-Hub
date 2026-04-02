import api from './api';

// ==================== EXAM MANAGEMENT ====================

export const getExams = async (filters = {}) => {
  const params = new URLSearchParams();
  if (filters.is_active !== undefined) params.append('is_active', filters.is_active);
  if (filters.year) params.append('year', filters.year);
  if (filters.semester) params.append('semester', filters.semester);
  if (filters.course) params.append('course', filters.course);
  if (filters.branch) params.append('branch', filters.branch);
  
  const response = await api.get(`/hall-tickets/exams/?${params.toString()}`);
  return response.data;
};

export const getExamDetail = async (examId) => {
  const response = await api.get(`/hall-tickets/exams/${examId}/`);
  return response.data;
};

export const createExam = async (examData) => {
  const response = await api.post('/hall-tickets/exams/', examData);
  return response.data;
};

export const updateExam = async (examId, examData) => {
  const response = await api.put(`/hall-tickets/exams/${examId}/`, examData);
  return response.data;
};

export const deleteExam = async (examId) => {
  const response = await api.delete(`/hall-tickets/exams/${examId}/`);
  return response.data;
};

// ==================== SUBJECT MANAGEMENT ====================

export const addExamSubject = async (examId, subjectData) => {
  const response = await api.post(`/hall-tickets/exams/${examId}/subjects/`, subjectData);
  return response.data;
};

export const updateExamSubject = async (subjectId, subjectData) => {
  const response = await api.put(`/hall-tickets/subjects/${subjectId}/`, subjectData);
  return response.data;
};

export const deleteExamSubject = async (subjectId) => {
  const response = await api.delete(`/hall-tickets/subjects/${subjectId}/delete/`);
  return response.data;
};

// ==================== STUDENT ENROLLMENT ====================

export const uploadStudentList = async (examId, file) => {
  const formData = new FormData();
  formData.append('file', file);
  
  const response = await api.post(`/hall-tickets/exams/${examId}/upload-students/`, formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  });
  return response.data;
};

export const getEnrollments = async (examId) => {
  const response = await api.get(`/hall-tickets/exams/${examId}/enrollments/`);
  return response.data;
};

// ==================== STUDENT PHOTO UPLOAD ====================

export const uploadStudentPhoto = async (photo, consentGiven, consentText) => {
  const formData = new FormData();
  formData.append('photo', photo);
  formData.append('consent_given', consentGiven);
  if (consentText) {
    formData.append('consent_text', consentText);
  }
  
  const response = await api.post('/hall-tickets/photo/upload/', formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  });
  return response.data;
};

export const getStudentPhoto = async () => {
  const response = await api.get('/hall-tickets/photo/');
  return response.data;
};

// ==================== HALL TICKET GENERATION ====================

export const generateHallTickets = async (examId) => {
  const response = await api.post(`/hall-tickets/exams/${examId}/generate/`);
  return response.data;
};

export const getHallTickets = async (examId) => {
  const response = await api.get(`/hall-tickets/exams/${examId}/tickets/`);
  return response.data;
};

export const downloadHallTicket = async (ticketId) => {
  const response = await api.get(`/hall-tickets/${ticketId}/download/`, {
    responseType: 'blob',
  });
  
  // Create download link
  const url = window.URL.createObjectURL(new Blob([response.data]));
  const link = document.createElement('a');
  link.href = url;
  link.setAttribute('download', `hall_ticket_${ticketId}.pdf`);
  document.body.appendChild(link);
  link.click();
  link.remove();
  window.URL.revokeObjectURL(url);
  
  return response.data;
};

export const downloadAllHallTickets = async (examId) => {
  const response = await api.get(`/hall-tickets/exams/${examId}/download-all/`, {
    responseType: 'blob',
  });
  
  // Extract filename from content-disposition header or use default
  const contentDisposition = response.headers['content-disposition'];
  let filename = `hall_tickets_exam_${examId}.pdf`;
  if (contentDisposition) {
    const filenameMatch = contentDisposition.match(/filename="(.+)"/);
    if (filenameMatch) {
      filename = filenameMatch[1];
    }
  }
  
  // Create download link for PDF
  const url = window.URL.createObjectURL(new Blob([response.data], { type: 'application/pdf' }));
  const link = document.createElement('a');
  link.href = url;
  link.setAttribute('download', filename);
  document.body.appendChild(link);
  link.click();
  link.remove();
  window.URL.revokeObjectURL(url);
  
  return response.data;
};

export const getMyHallTickets = async () => {
  const response = await api.get('/hall-tickets/my-tickets/');
  return response.data;
};

// ==================== SAMPLE TEMPLATE ====================

export const downloadSampleTemplate = async () => {
  const response = await api.get('/hall-tickets/sample-template/', {
    responseType: 'blob',
  });
  
  // Create download link
  const url = window.URL.createObjectURL(new Blob([response.data]));
  const link = document.createElement('a');
  link.href = url;
  link.setAttribute('download', 'student_list_template.xlsx');
  document.body.appendChild(link);
  link.click();
  link.remove();
  window.URL.revokeObjectURL(url);
  
  return response.data;
};

// ==================== UTILITY FUNCTIONS ====================

export const COURSE_OPTIONS = [
  { value: 'ug', label: 'UG - Undergraduate' },
  { value: 'pg', label: 'PG - Postgraduate' },
  { value: 'phd', label: 'PhD - Doctorate' },
];

export const BRANCH_OPTIONS = [
  { value: 'CSE', label: 'Computer Science and Engineering' },
  { value: 'ECE', label: 'Electronics and Communication Engineering' },
  { value: 'EEE', label: 'Electrical and Electronics Engineering' },
  { value: 'MECH', label: 'Mechanical Engineering' },
  { value: 'CIVIL', label: 'Civil Engineering' },
  { value: 'IT', label: 'Information Technology' },
  { value: 'MBA', label: 'Master of Business Administration' },
  { value: 'MCA', label: 'Master of Computer Applications' },
];

export const SEMESTER_OPTIONS = [
  { value: 1, label: 'Semester 1' },
  { value: 2, label: 'Semester 2' },
  { value: 3, label: 'Semester 3' },
  { value: 4, label: 'Semester 4' },
  { value: 5, label: 'Semester 5' },
  { value: 6, label: 'Semester 6' },
  { value: 7, label: 'Semester 7' },
  { value: 8, label: 'Semester 8' },
];

export const YEAR_OPTIONS = Array.from({ length: 10 }, (_, i) => {
  const year = new Date().getFullYear() - 5 + i;
  return { value: year, label: year.toString() };
});

// ==================== SUPPLEMENTARY HALL TICKET GENERATION ====================

export const getSupplementaryCombos = async () => {
  const response = await api.get('/hall-tickets/supplementary/generate/');
  return response.data;
};

export const generateSupplementaryHallTickets = async (payload) => {
  const response = await api.post('/hall-tickets/supplementary/generate/', payload);
  return response.data;
};
