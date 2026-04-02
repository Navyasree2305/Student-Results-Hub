import React, { useState, useEffect } from 'react';
import { FaPlus, FaTrash, FaDownload, FaFileUpload, FaEye, FaFileExcel, FaTimes, FaUsers, FaIdCard } from 'react-icons/fa';
import * as hallTicketService from '../services/hallTicketService';

const HallTicketManagement = () => {
  const [exams, setExams] = useState([]);
  const [loading, setLoading] = useState(false);
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [showDetailsModal, setShowDetailsModal] = useState(false);
  const [selectedExam, setSelectedExam] = useState(null);
  const [enrollments, setEnrollments] = useState([]);
  const [hallTickets, setHallTickets] = useState([]);
  const [toast, setToast] = useState({ show: false, message: '', type: '' });

  // Exam Form State with exact fields from requirements
  const [examForm, setExamForm] = useState({
    year: 'I',              // Roman numeral dropdown
    semester: 'I',          // I or II
    course: 'B.Tech',       // B.Tech or M.Tech
    branch: '',             // NEW: Branch name text input
    exam_type: 'Regular',   // Regular, Supplementary, Regular/Supplementary
    month: 'January',       // Month dropdown
    year_of_exam: new Date().getFullYear().toString(), // Text input
    exam_center: 'Main Campus',
    exam_start_time: '09:00',
    exam_end_time: '12:00',
  });

  // Subjects array - dynamic addition (single row per subject)
  const [subjects, setSubjects] = useState([
    {
      subject_code: '',
      subject_name: '',
      subject_type: 'Theory', // Theory or Lab
      exam_date: '',          // Mandatory for Theory, optional for Lab
    }
  ]);

  // Excel upload state
  const [uploadFile, setUploadFile] = useState(null);

  // Year options based on course
  const getYearOptions = () => {
    if (examForm.course === 'B.Tech') {
      return ['I', 'II', 'III', 'IV'];
    } else if (examForm.course === 'M.Tech') {
      return ['I', 'II'];
    }
    return ['I'];
  };

  // ESC key handler to close modal
  useEffect(() => {
    const handleEsc = (e) => {
      if (e.key === 'Escape' && showCreateModal) {
        closeModal();
      }
    };
    document.addEventListener('keydown', handleEsc);
    return () => document.removeEventListener('keydown', handleEsc);
  }, [showCreateModal]);

  useEffect(() => {
    fetchExams();
  }, []);

  const fetchExams = async () => {
    try {
      setLoading(true);
      const response = await hallTicketService.getExams();
      setExams(response || []);
    } catch (error) {
      showToast('Error fetching exams', 'error');
    } finally {
      setLoading(false);
    }
  };

  const showToast = (message, type = 'info') => {
    setToast({ show: true, message, type });
    setTimeout(() => setToast({ show: false, message: '', type: '' }), 3000);
  };

  const closeModal = () => {
    setShowCreateModal(false);
    resetForm();
  };

  const resetForm = () => {
    setExamForm({
      year: 'I',
      semester: 'I',
      course: 'B.Tech',
      branch: '',
      exam_type: 'Regular',
      month: 'January',
      year_of_exam: new Date().getFullYear().toString(),
      exam_center: 'Main Campus',
      exam_start_time: '09:00',
      exam_end_time: '12:00',
    });
    setSubjects([
      {
        subject_code: '',
        subject_name: '',
        subject_type: 'Theory',
        exam_date: '',
      }
    ]);
    setUploadFile(null);
  };

  // Add new subject
  const addSubject = () => {
    setSubjects([
      ...subjects,
      {
        subject_code: '',
        subject_name: '',
        subject_type: 'Theory',
        exam_date: '',
      }
    ]);
  };

  // Remove subject
  const removeSubject = (index) => {
    if (subjects.length > 1) {
      setSubjects(subjects.filter((_, i) => i !== index));
    } else {
      showToast('At least one subject is required', 'error');
    }
  };

  // Update subject field
  const updateSubject = (index, field, value) => {
    const updatedSubjects = [...subjects];
    updatedSubjects[index] = {
      ...updatedSubjects[index],
      [field]: value
    };
    setSubjects(updatedSubjects);
  };

  // Validate form
  const validateForm = () => {
    // Check all required fields
    if (!examForm.year || !examForm.semester || !examForm.course || 
        !examForm.branch || !examForm.exam_type || !examForm.month || !examForm.year_of_exam) {
      showToast('Please fill all exam details', 'error');
      return false;
    }

    if (!examForm.exam_start_time || !examForm.exam_end_time) {
      showToast('Please set the exam start and end time', 'error');
      return false;
    }

    // Check subjects
    for (let i = 0; i < subjects.length; i++) {
      const subject = subjects[i];
      if (!subject.subject_code || !subject.subject_name || !subject.subject_type) {
        showToast(`Please fill all fields for subject ${i + 1}`, 'error');
        return false;
      }
      
      // Theory subjects must have exam date
      if (subject.subject_type === 'Theory' && !subject.exam_date) {
        showToast(`Exam date is mandatory for Theory subject: ${subject.subject_name}`, 'error');
        return false;
      }
    }

    // Check file upload
    console.log('Validating file upload. uploadFile:', uploadFile);
    if (!uploadFile) {
      showToast('Please upload student list Excel file', 'error');
      return false;
    }

    console.log('Validation passed. File ready:', uploadFile.name);
    return true;
  };

  // Handle form submission
  const handleSubmit = async () => {
    if (!validateForm()) return;

    try {
      setLoading(true);

      // Prepare exam data (only include fields that exist in Exam model)
      const examData = {
        exam_name: `${examForm.year} Year ${examForm.course} ${examForm.semester} Semester ${examForm.exam_type} Examinations ${examForm.month} ${examForm.year_of_exam}`,
        year: examForm.year,
        semester: examForm.semester,
        course: examForm.course,
        branch: examForm.branch,
        exam_center: examForm.exam_center,
        is_active: true,
        exam_start_time: examForm.exam_start_time,
        exam_end_time: examForm.exam_end_time,
      };

      // Step 1: Create exam
      console.log('Creating exam...', examData);
      const examResponse = await hallTicketService.createExam(examData);
      const examId = examResponse.id;
      console.log('Exam created with ID:', examId);

      // Step 2: Add subjects to the exam
      console.log('Adding subjects...');
      for (let i = 0; i < subjects.length; i++) {
        const subject = subjects[i];
        await hallTicketService.addExamSubject(examId, {
          subject_code: subject.subject_code,
          subject_name: subject.subject_name,
          exam_date: subject.exam_date || null,
          exam_time: '10:00',
          duration: subject.subject_type === 'Theory' ? '3 hours' : '2 hours',
          subject_type: subject.subject_type,
          order: i + 1,
        });
      }
      console.log('Subjects added successfully');

      // Step 3: Upload student list
      if (uploadFile) {
        console.log('Uploading student list...', uploadFile.name);
        await hallTicketService.uploadStudentList(examId, uploadFile);
        console.log('Student list uploaded successfully');
      }

      showToast('Hall ticket exam created successfully!', 'success');
      closeModal();
      fetchExams();
    } catch (error) {
      console.error('Error creating exam:', error);
      console.error('Error response:', error.response);
      const errorMessage = error.response?.data?.error || error.response?.data?.message || error.message || 'Error creating exam';
      showToast(errorMessage, 'error');
    } finally {
      setLoading(false);
    }
  };

  // Handle file selection
  const handleFileChange = (e) => {
    const file = e.target.files[0];
    console.log('File selected:', file);
    if (file) {
      if (!file.name.endsWith('.xlsx') && !file.name.endsWith('.xls')) {
        showToast('Please upload a valid Excel file', 'error');
        e.target.value = '';
        setUploadFile(null);
        return;
      }
      setUploadFile(file);
      console.log('Upload file set to:', file.name, 'Size:', file.size, 'Type:', file.type);
      showToast('File selected: ' + file.name, 'success');
    } else {
      console.log('No file selected');
      setUploadFile(null);
    }
  };

  // Download sample template
  const downloadSampleTemplate = async () => {
    try {
      const response = await hallTicketService.downloadSampleTemplate();
      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', 'hall_ticket_student_template.xlsx');
      document.body.appendChild(link);
      link.click();
      link.remove();
      showToast('Sample template downloaded', 'success');
    } catch (error) {
      showToast('Error downloading template', 'error');
    }
  };

  // View exam details (enrollments and hall tickets)
  const viewExamDetails = async (exam) => {
    try {
      setLoading(true);
      setSelectedExam(exam);
      
      // Fetch enrollments
      const enrollmentsData = await hallTicketService.getEnrollments(exam.id);
      setEnrollments(enrollmentsData);
      
      // Fetch hall tickets
      try {
        const ticketsData = await hallTicketService.getHallTickets(exam.id);
        setHallTickets(ticketsData);
      } catch (error) {
        // Hall tickets might not be generated yet
        setHallTickets([]);
      }
      
      setShowDetailsModal(true);
    } catch (error) {
      showToast('Error loading exam details', 'error');
    } finally {
      setLoading(false);
    }
  };

  // Generate hall tickets for an exam
  const generateHallTickets = async (examId) => {
    try {
      setLoading(true);
      const response = await hallTicketService.generateHallTickets(examId);
      showToast(`${response.generated_count} hall tickets generated successfully!`, 'success');
      
      // Refresh the exam details if modal is open
      if (selectedExam && selectedExam.id === examId) {
        const ticketsData = await hallTicketService.getHallTickets(examId);
        setHallTickets(ticketsData);
      }
      
      fetchExams();
    } catch (error) {
      showToast(error.response?.data?.error || 'Error generating hall tickets', 'error');
    } finally {
      setLoading(false);
    }
  };

  // Download a single hall ticket
  const downloadHallTicket = async (ticketId) => {
    try {
      await hallTicketService.downloadHallTicket(ticketId);
      showToast('Hall ticket downloaded', 'success');
    } catch (error) {
      showToast('Error downloading hall ticket', 'error');
    }
  };

  // Download all hall tickets for an exam
  const downloadAllHallTickets = async (examId) => {
    try {
      setLoading(true);
      
      // First, try to generate hall tickets if they don't exist
      try {
        await hallTicketService.generateHallTickets(examId);
        console.log('Hall tickets generated');
      } catch (genError) {
        // Hall tickets might already exist, continue to download
        console.log('Hall tickets may already exist, proceeding to download');
      }
      
      // Download all hall tickets as ZIP file
      await hallTicketService.downloadAllHallTickets(examId);
      showToast('Hall tickets PDF downloaded successfully', 'success');
      
    } catch (error) {
      console.error('Error in downloadAllHallTickets:', error);
      const errorMsg = error.response?.data?.error || 'Error downloading hall tickets';
      showToast(errorMsg, 'error');
    } finally {
      setLoading(false);
    }
  };

  // Delete exam
  const deleteExam = async (examId) => {
    if (!window.confirm('Are you sure you want to delete this exam? This will also delete all enrollments and hall tickets.')) {
      return;
    }
    
    try {
      setLoading(true);
      await hallTicketService.deleteExam(examId);
      showToast('Exam deleted successfully', 'success');
      fetchExams();
    } catch (error) {
      console.error('Error deleting exam:', error);
      showToast(error.response?.data?.error || 'Error deleting exam', 'error');
    } finally {
      setLoading(false);
    }
  };

  // Close details modal
  const closeDetailsModal = () => {
    setShowDetailsModal(false);
    setSelectedExam(null);
    setEnrollments([]);
    setHallTickets([]);
  };

  return (
    <div className="p-6">
      {/* Toast Notification */}
      {toast.show && (
        <div className={`fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg ${
          toast.type === 'success' ? 'bg-green-500' : 
          toast.type === 'error' ? 'bg-red-500' : 'bg-blue-500'
        } text-white`}>
          {toast.message}
        </div>
      )}

      {/* Header */}
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold text-gray-800">Hall Ticket Management</h1>
        <button
          onClick={() => setShowCreateModal(true)}
          className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg flex items-center gap-2"
        >
          <FaPlus /> Create New Exam
        </button>
      </div>

      {/* Exams List */}
      {loading && !showCreateModal ? (
        <div className="text-center py-8">Loading...</div>
      ) : (
        <div className="bg-white rounded-lg shadow overflow-hidden">
          <table className="min-w-full">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Exam Name</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Course</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Branch</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Year/Sem</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Uploaded By</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {exams.length === 0 ? (
                <tr>
                  <td colSpan="7" className="px-6 py-4 text-center text-gray-500">
                    No exams found. Click "Create New Exam" to add one.
                  </td>
                </tr>
              ) : (
                exams.map((exam) => (
                  <tr key={exam.id}>
                    <td className="px-6 py-4 text-sm text-gray-900">{exam.exam_name}</td>
                    <td className="px-6 py-4 text-sm text-gray-900">{exam.course}</td>
                    <td className="px-6 py-4 text-sm text-gray-900">{exam.branch || 'N/A'}</td>
                    <td className="px-6 py-4 text-sm text-gray-900">{exam.year}/{exam.semester}</td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      {exam.created_by ? `${exam.created_by.first_name || 'HOD'} (${exam.branch})` : 'Admin'}
                    </td>
                    <td className="px-6 py-4 text-sm">
                      <span className={`px-2 py-1 rounded ${exam.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'}`}>
                        {exam.is_active ? 'Active' : 'Inactive'}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-sm">
                      <div className="flex gap-2">
                        <button 
                          onClick={() => viewExamDetails(exam)}
                          className="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded flex items-center gap-1 text-xs"
                          title="View Details"
                        >
                          <FaEye /> View
                        </button>
                        <button 
                          onClick={() => downloadAllHallTickets(exam.id)}
                          className="bg-green-600 hover:bg-green-700 text-white px-3 py-1 rounded flex items-center gap-1 text-xs"
                          title="Download All Hall Tickets as PDF"
                          disabled={loading}
                        >
                          <FaDownload /> Download
                        </button>
                        <button 
                          onClick={() => deleteExam(exam.id)}
                          className="bg-red-600 hover:bg-red-700 text-white px-3 py-1 rounded flex items-center gap-1 text-xs"
                          title="Delete Exam"
                          disabled={loading}
                        >
                          <FaTrash /> Delete
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      )}

      {/* Create Exam Modal */}
      {showCreateModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            {/* Modal Header */}
            <div className="flex justify-between items-center p-6 border-b sticky top-0 bg-white z-10">
              <h2 className="text-xl font-bold text-gray-800">Create Hall Ticket Exam</h2>
              <button
                onClick={closeModal}
                className="text-gray-500 hover:text-gray-700 text-2xl"
              >
                <FaTimes />
              </button>
            </div>

            {/* Modal Body */}
            <div className="p-6 space-y-6">
              {/* Exam Details Section */}
              <div>
                <h3 className="text-lg font-semibold mb-4 text-gray-700">Exam Details</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  {/* Course */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Course <span className="text-red-500">*</span>
                    </label>
                    <select
                      value={examForm.course}
                      onChange={(e) => setExamForm({ ...examForm, course: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      <option value="B.Tech">B.Tech</option>
                      <option value="M.Tech">M.Tech</option>
                    </select>
                  </div>

                  {/* Branch - NEW FIELD */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Branch <span className="text-red-500">*</span>
                    </label>
                    <input
                      type="text"
                      value={examForm.branch}
                      onChange={(e) => setExamForm({ ...examForm, branch: e.target.value })}
                      placeholder="e.g., Computer Science Engineering"
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>

                  {/* Year */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Year <span className="text-red-500">*</span>
                    </label>
                    <select
                      value={examForm.year}
                      onChange={(e) => setExamForm({ ...examForm, year: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      {getYearOptions().map(year => (
                        <option key={year} value={year}>{year}</option>
                      ))}
                    </select>
                  </div>

                  {/* Semester */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Semester <span className="text-red-500">*</span>
                    </label>
                    <select
                      value={examForm.semester}
                      onChange={(e) => setExamForm({ ...examForm, semester: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      <option value="I">I</option>
                      <option value="II">II</option>
                    </select>
                  </div>

                  {/* Exam Type */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Exam Type <span className="text-red-500">*</span>
                    </label>
                    <select
                      value={examForm.exam_type}
                      onChange={(e) => setExamForm({ ...examForm, exam_type: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      <option value="Regular">Regular</option>
                      <option value="Supplementary">Supplementary</option>
                      <option value="Regular/Supplementary">Regular/Supplementary</option>
                    </select>
                  </div>

                  {/* Month */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Month <span className="text-red-500">*</span>
                    </label>
                    <select
                      value={examForm.month}
                      onChange={(e) => setExamForm({ ...examForm, month: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      {['January', 'February', 'March', 'April', 'May', 'June', 
                        'July', 'August', 'September', 'October', 'November', 'December'].map(month => (
                        <option key={month} value={month}>{month}</option>
                      ))}
                    </select>
                  </div>

                  {/* Year of Exam */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Year of Exam <span className="text-red-500">*</span>
                    </label>
                    <input
                      type="text"
                      value={examForm.year_of_exam}
                      onChange={(e) => setExamForm({ ...examForm, year_of_exam: e.target.value })}
                      placeholder="e.g., 2026"
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>

                  {/* Exam Start Time */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Exam Start Time <span className="text-red-500">*</span>
                    </label>
                    <input
                      type="time"
                      value={examForm.exam_start_time}
                      onChange={(e) => setExamForm({ ...examForm, exam_start_time: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>

                  {/* Exam End Time */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Exam End Time <span className="text-red-500">*</span>
                    </label>
                    <input
                      type="time"
                      value={examForm.exam_end_time}
                      onChange={(e) => setExamForm({ ...examForm, exam_end_time: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                </div>
              </div>

              {/* Subjects Section - IMPROVED: Single row per subject with plus button moving down */}
              <div>
                <h3 className="text-lg font-semibold mb-4 text-gray-700">Subjects</h3>

                {subjects.map((subject, index) => (
                  <div key={index} className="mb-3">
                    {/* Single row with all fields */}
                    <div className="flex items-start gap-3">
                      {/* Subject Code */}
                      <div className="flex-1">
                        <input
                          type="text"
                          value={subject.subject_code}
                          onChange={(e) => updateSubject(index, 'subject_code', e.target.value)}
                          placeholder="Subject Code *"
                          className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                      </div>

                      {/* Subject Name */}
                      <div className="flex-[2]">
                        <input
                          type="text"
                          value={subject.subject_name}
                          onChange={(e) => updateSubject(index, 'subject_name', e.target.value)}
                          placeholder="Subject Name *"
                          className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                      </div>

                      {/* Subject Type */}
                      <div className="flex-1">
                        <select
                          value={subject.subject_type}
                          onChange={(e) => updateSubject(index, 'subject_type', e.target.value)}
                          className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                        >
                          <option value="Theory">Theory</option>
                          <option value="Lab">Lab</option>
                        </select>
                      </div>

                      {/* Exam Date */}
                      <div className="flex-1">
                        <input
                          type="date"
                          value={subject.exam_date}
                          onChange={(e) => updateSubject(index, 'exam_date', e.target.value)}
                          placeholder={subject.subject_type === 'Theory' ? 'Date *' : 'Date (Opt)'}
                          className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                      </div>

                      {/* Remove button */}
                      {subjects.length > 1 && (
                        <button
                          onClick={() => removeSubject(index)}
                          className="p-2 text-red-500 hover:text-red-700 hover:bg-red-50 rounded-lg"
                          title="Remove subject"
                        >
                          <FaTrash />
                        </button>
                      )}
                    </div>

                    {/* Add button appears after the last subject */}
                    {index === subjects.length - 1 && (
                      <div className="mt-2">
                        <button
                          onClick={addSubject}
                          className="text-blue-600 hover:text-blue-800 flex items-center gap-2 text-sm font-medium"
                        >
                          <FaPlus /> Add Another Subject
                        </button>
                      </div>
                    )}
                  </div>
                ))}
              </div>

              {/* Student List Upload Section */}
              <div>
                <h3 className="text-lg font-semibold mb-4 text-gray-700">Student List</h3>
                
                {/* Download Sample Template */}
                <div className="mb-4">
                  <button
                    type="button"
                    onClick={downloadSampleTemplate}
                    className="text-blue-600 hover:text-blue-800 flex items-center gap-2 text-sm font-medium"
                  >
                    <FaFileExcel /> Download Sample Template
                  </button>
                </div>

                {/* File Upload - Same style as Results Upload */}
                <div className="mb-4">
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Excel File <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="file"
                    accept=".xlsx,.xls"
                    onChange={handleFileChange}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                  <p className="text-xs text-gray-500 mt-1">
                    Excel file should contain: Roll Number and Student Name
                  </p>
                  {uploadFile && (
                    <p className="text-sm text-green-600 mt-2 flex items-center gap-2">
                      <FaFileExcel /> Selected: {uploadFile.name}
                    </p>
                  )}
                </div>
              </div>
            </div>

            {/* Modal Footer */}
            <div className="flex justify-end gap-3 p-6 border-t bg-gray-50 sticky bottom-0">
              <button
                onClick={closeModal}
                className="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-100"
                disabled={loading}
              >
                Cancel
              </button>
              <button
                onClick={handleSubmit}
                className="px-6 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg disabled:bg-blue-300"
                disabled={loading}
              >
                {loading ? 'Creating...' : 'Create Exam'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Details Modal - View Enrollments and Hall Tickets */}
      {showDetailsModal && selectedExam && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-6xl w-full max-h-[90vh] overflow-y-auto">
            {/* Modal Header */}
            <div className="flex justify-between items-center p-6 border-b sticky top-0 bg-white z-10">
              <div>
                <h2 className="text-xl font-bold text-gray-800">{selectedExam.exam_name}</h2>
                <p className="text-sm text-gray-600">{selectedExam.course} - {selectedExam.branch} - Year {selectedExam.year} Sem {selectedExam.semester}</p>
              </div>
              <button
                onClick={closeDetailsModal}
                className="text-gray-500 hover:text-gray-700 text-2xl"
              >
                <FaTimes />
              </button>
            </div>

            {/* Modal Body */}
            <div className="p-6">
              {/* Action Buttons */}
              <div className="flex gap-3 mb-6">
                <button
                  onClick={() => generateHallTickets(selectedExam.id)}
                  className="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg flex items-center gap-2"
                  disabled={loading}
                >
                  <FaIdCard /> {hallTickets.length > 0 ? 'Regenerate' : 'Generate'} Hall Tickets
                </button>
                {hallTickets.length > 0 && (
                  <button
                    onClick={() => downloadAllHallTickets(selectedExam.id)}
                    className="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-lg flex items-center gap-2"
                    disabled={loading}
                  >
                    <FaDownload /> Download All as PDF ({hallTickets.length})
                  </button>
                )}
              </div>

              {/* Enrollments Section */}
              <div className="mb-6">
                <h3 className="text-lg font-semibold mb-3 flex items-center gap-2">
                  <FaUsers /> Enrolled Students ({enrollments.length})
                </h3>
                <div className="bg-white rounded-lg border overflow-hidden">
                  <table className="min-w-full">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Roll Number</th>
                        <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Student Name</th>
                        <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-200">
                      {enrollments.length === 0 ? (
                        <tr>
                          <td colSpan="3" className="px-4 py-4 text-center text-gray-500">
                            No students enrolled yet
                          </td>
                        </tr>
                      ) : (
                        enrollments.map((enrollment, idx) => (
                          <tr key={idx}>
                            <td className="px-4 py-2 text-sm text-gray-900">{enrollment.roll_number}</td>
                            <td className="px-4 py-2 text-sm text-gray-900">{enrollment.student_name}</td>
                            <td className="px-4 py-2 text-sm">
                              <span className="px-2 py-1 bg-green-100 text-green-800 rounded text-xs">
                                Enrolled
                              </span>
                            </td>
                          </tr>
                        ))
                      )}
                    </tbody>
                  </table>
                </div>
              </div>

              {/* Hall Tickets Section */}
              {hallTickets.length > 0 && (
                <div>
                  <h3 className="text-lg font-semibold mb-3 flex items-center gap-2">
                    <FaIdCard /> Generated Hall Tickets ({hallTickets.length})
                  </h3>
                  <div className="bg-white rounded-lg border overflow-hidden">
                    <table className="min-w-full">
                      <thead className="bg-gray-50">
                        <tr>
                          <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Roll Number</th>
                          <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Student Name</th>
                          <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-gray-200">
                        {hallTickets.map((ticket) => (
                          <tr key={ticket.id}>
                            <td className="px-4 py-2 text-sm text-gray-900 font-mono">{ticket.roll_number}</td>
                            <td className="px-4 py-2 text-sm text-gray-900">{ticket.student_name}</td>
                            <td className="px-4 py-2 text-sm">
                              <button
                                onClick={() => downloadHallTicket(ticket.id)}
                                className="text-blue-600 hover:text-blue-800 flex items-center gap-1"
                              >
                                <FaDownload /> Download
                              </button>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              )}
            </div>

            {/* Modal Footer */}
            <div className="flex justify-end gap-3 p-6 border-t bg-gray-50 sticky bottom-0">
              <button
                onClick={closeDetailsModal}
                className="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-100"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default HallTicketManagement;
