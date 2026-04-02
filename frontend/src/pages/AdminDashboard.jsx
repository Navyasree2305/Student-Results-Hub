import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { resultsService, studentService } from '../services/resultsService';
import Navbar from '../components/Navbar';
import StatCard from '../components/StatCard';
import DashboardCard from '../components/DashboardCard';
import StatisticsModal from '../components/StatisticsModal';
import SearchStudentModal from '../components/SearchStudentModal';
import Toast from '../components/Toast';
import SemesterSummaryTable from '../components/SemesterSummaryTable';
import { validateExcelFile } from '../utils/validation';
import useEscapeKey from '../hooks/useEscapeKey';
import DetainedStudentsModal from '../components/DetainedStudentsModal';
import TimetableModal from '../components/TimetableModal';
import SubjectDifficultyAnalyzer from '../components/SubjectDifficultyAnalyzer';
import { 
  FaUpload, FaUsers, FaBullhorn, FaIdCard, FaSearch, 
  FaCalendar, FaTrash, FaChartBar, FaDownload, FaFileExcel, FaUserSlash, FaTable, FaShieldAlt, FaBrain
} from 'react-icons/fa';

const AdminDashboard = () => {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [exams, setExams] = useState([]);
  const [loading, setLoading] = useState(false);
  const [uploadLoading, setUploadLoading] = useState(false);
  const [error, setError] = useState('');
  const [toast, setToast] = useState({ show: false, message: '', type: '' });
  const [showSearchModal, setShowSearchModal] = useState(false);
  const [showUploadModal, setShowUploadModal] = useState(false);
  const [showDetainedModal, setShowDetainedModal] = useState(false);
  const [showTimetableModal, setShowTimetableModal] = useState(false);
  const [showDifficultyModal, setShowDifficultyModal] = useState(false);
  const [file, setFile] = useState(null);
  const [year, setYear] = useState('');
  const [semester, setSemester] = useState('');
  const [resultType, setResultType] = useState('');
  const [course, setCourse] = useState('btech');
  const [statistics, setStatistics] = useState(null);
  const [showStatsModal, setShowStatsModal] = useState(false);
  const [examHeldDate, setExamHeldDate] = useState('');
  const [examMonth, setExamMonth] = useState('');
  const [examYear, setExamYear] = useState('');
  
  // Student management state
  const [selectedStudent, setSelectedStudent] = useState(null);
  const [studentHistory, setStudentHistory] = useState(null);
  const [loadingHistory, setLoadingHistory] = useState(false);

  // Stats
  const [stats, setStats] = useState({
    totalExams: 0,
    hallTickets: 0,
    circulars: 0,
    users: 0
  });

  useEffect(() => {
    fetchUploadedExams();
    fetchDashboardStats();
  }, []);

  useEffect(() => {
    if (course === 'mtech' && (year === '3' || year === '4')) {
      setYear('');
    }
  }, [course]);

  // ESC key handlers to close modals
  useEscapeKey(() => setShowUploadModal(false), showUploadModal);
  useEscapeKey(() => setShowDetainedModal(false), showDetainedModal);
  useEscapeKey(() => setShowTimetableModal(false), showTimetableModal);

  const fetchDashboardStats = async () => {
    try {
      // Fetch dashboard stats from backend API
      const dashboardData = await resultsService.getDashboardStats();
      setStats({
        totalExams: dashboardData.total_exams || 0,
        hallTickets: dashboardData.total_hall_tickets || 0,
        circulars: dashboardData.active_circulars || 0,
        users: dashboardData.total_users || 0
      });
    } catch (err) {
      console.error('Failed to fetch stats', err);
      // Fallback to zeros on error
      setStats({
        totalExams: 0,
        hallTickets: 0,
        circulars: 0,
        users: 0
      });
    }
  };

  const getYearOptions = () => {
    if (course === 'mtech') {
      return [
        { value: '1', label: 'I Year' },
        { value: '2', label: 'II Year' }
      ];
    }
    return [
      { value: '1', label: 'I Year' },
      { value: '2', label: 'II Year' },
      { value: '3', label: 'III Year' },
      { value: '4', label: 'IV Year' }
    ];
  };

  const showToast = (message, type) => {
    setToast({ show: true, message, type });
  };

  const handleDownloadTemplate = async () => {
    try {
      await resultsService.downloadSampleTemplate();
      showToast('Template downloaded successfully!', 'success');
    } catch (err) {
      showToast('Failed to download template', 'error');
    }
  };

  const fetchUploadedExams = async () => {
    setLoading(true);
    try {
      const data = await resultsService.getUploadedExams();
      setExams(data.exams || []);
    } catch (err) {
      setError('Failed to load exams');
    } finally {
      setLoading(false);
    }
  };

  const handleDownloadExam = async (examName) => {
    try {
      await resultsService.downloadExamResults(examName);
    } catch (err) {
      setError('Failed to download exam results');
    }
  };

  const handleDeleteExam = async (examName) => {
    if (!window.confirm(`Are you sure you want to delete "${examName}"? This will permanently delete all student results for this exam.`)) {
      return;
    }
    
    try {
      await resultsService.deleteExamResults(examName);
      showToast(`Successfully deleted ${examName}`, 'success');
      fetchUploadedExams();
      fetchDashboardStats();
    } catch (err) {
      const errorMsg = err.response?.data?.error || 'Failed to delete exam results';
      showToast(errorMsg, 'error');
    }
  };

  const handleViewExamStatistics = async (examName) => {
    try {
      const data = await resultsService.getStatistics(examName);
      setStatistics({ ...data, examName });
      setShowStatsModal(true);
    } catch (err) {
      console.error('Failed to fetch statistics:', err);
      showToast('Failed to load statistics', 'error');
    }
  };

  const handleFileChange = (e) => {
    const selectedFile = e.target.files[0];
    const validation = validateExcelFile(selectedFile);
    if (!validation.valid) {
      showToast(validation.message, 'error');
      setFile(null);
    } else {
      setFile(selectedFile);
    }
  };

  const handleUpload = async (e) => {
    e.preventDefault();
    if (!file || !year || !semester || !resultType || !course || !examMonth || !examYear) {
      showToast('Please fill all required fields (Course, Year, Semester, Result Type, Exam Month & Year, Excel File)', 'error');
      return;
    }
    
    // Validate exam held date if provided
    let examDate = '';
    if (examMonth && examYear) {
      const selectedDate = new Date(examYear, parseInt(examMonth) - 1, 1);
      const currentDate = new Date();
      currentDate.setHours(0, 0, 0, 0);
      
      if (selectedDate > currentDate) {
        showToast('Exam Held Date cannot be in the future', 'error');
        return;
      }
      
      examDate = `${examYear}-${examMonth.padStart(2, '0')}`;
    } else if (examMonth || examYear) {
      showToast('Please provide both month and year or leave both empty', 'error');
      return;
    }
    
    setUploadLoading(true);
    try {
      const result = await resultsService.uploadResults(file, year, semester, resultType, course, examDate);
      showToast(result.message || 'Results uploaded successfully', 'success');
      setFile(null);
      setYear('');
      setSemester('');
      setResultType('');
      setCourse('btech');
      setExamHeldDate('');
      setExamMonth('');
      setExamYear('');
      setShowUploadModal(false);
      fetchUploadedExams();
      fetchDashboardStats();
      e.target.reset();
    } catch (err) {
      const errorMsg = err.response?.data?.error || err.response?.data?.errors?.join(', ') || 'Failed to upload results';
      showToast(errorMsg, 'error');
    } finally {
      setUploadLoading(false);
    }
  };

  // Student selection handler
  const handleStudentSelect = async (student) => {
    setSelectedStudent(student);
    setLoadingHistory(true);
    try {
      const data = await studentService.getStudentHistory(student.roll_number);
      setStudentHistory(data);
    } catch (err) {
      console.error('Failed to load student history:', err);
      showToast('Failed to load student history', 'error');
    } finally {
      setLoadingHistory(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">Admin Dashboard</h1>
          <p className="text-gray-600 mt-2">Manage exams, users, and system settings</p>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <StatCard
            title="Exams Uploaded"
            value={stats.totalExams}
            icon={<FaCalendar />}
            color="blue"
          />
          <StatCard
            title="Hall Tickets"
            value={stats.hallTickets}
            icon={<FaIdCard />}
            color="purple"
          />
          <StatCard
            title="Active Circulars"
            value={stats.circulars}
            icon={<FaBullhorn />}
            color="cyan"
          />
          <StatCard
            title="Total Users"
            value={stats.users}
            icon={<FaUsers />}
            color="green"
          />
        </div>

        {/* Admin Panel Header */}
        <div className="mb-4">
          <h2 className="text-xl font-bold text-gray-900">Admin Panel</h2>
          <p className="text-sm text-gray-600 mt-1">Click on any card to get started</p>
        </div>

        {/* Action Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
          {/* Upload Results Card */}
          <DashboardCard
            title="Upload Results"
            description="Upload exam results via Excel file and manage existing uploads"
            icon={<FaUpload />}
            color="blue"
            onClick={() => setShowUploadModal(true)}
            footer={
              <button
                onClick={(e) => {
                  e.stopPropagation();
                  handleDownloadTemplate();
                }}
                className="text-sm text-blue-600 hover:text-blue-700 font-medium flex items-center space-x-2"
              >
                <FaFileExcel />
                <span>Download Excel Template</span>
              </button>
            }
          />

          {/* Manage Users Card */}
          {(user?.role === 'admin' || user?.users_view || user?.users_create || user?.users_edit || user?.users_delete) && (
            <DashboardCard
              title="Manage Users"
              description="Add, edit, or remove user accounts and manage permissions"
              icon={<FaUsers />}
              color="indigo"
              onClick={() => navigate("/user-management")}
            />
          )}

          {/* Manage Circulars Card */}
          <DashboardCard
            title="Manage Circulars"
            description="Create and publish notices, announcements, and circulars for students"
            icon={<FaBullhorn />}
            color="purple"
            onClick={() => navigate("/admin/circulars")}
            badge={`${stats.circulars} active`}
          />

          {/* Manage Hall Tickets Card */}
          <DashboardCard
            title="Manage Hall Tickets"
            description="Generate and manage hall tickets for examinations"
            icon={<FaIdCard />}
            color="cyan"
            onClick={() => navigate("/admin/hall-tickets")}
            
          />

          {/* Search Student Card */}
          <DashboardCard
            title="Search Student"
            description="Look up student results and academic history by roll number"
            icon={<FaSearch />}
            color="teal"
            onClick={() => setShowSearchModal(true)}
          />

          {/* Detained Students Card */}
          <DashboardCard
            title="Detained Students"
            description="Generate detained student reports by year, semester, branch and credits threshold"
            icon={<FaUserSlash />}
            color="red"
            onClick={() => setShowDetainedModal(true)}
          />

          {/* Timetable Generator Card */}
          <DashboardCard
            title="Timetable Generator"
            description="Auto-generate conflict-free class timetables using AI and constraint solving"
            icon={<FaTable />}
            color="green"
            onClick={() => setShowTimetableModal(true)}
          />

          {/* Audit Logs Card */}
          <DashboardCard
            title="Audit Logs"
            description="View session-wise activity logs for all users over the last 5 days"
            icon={<FaShieldAlt />}
            color="indigo"
            onClick={() => navigate("/admin/audit-logs")}
          />

          {/* ML Subject Difficulty Analyzer Card */}
          <DashboardCard
            title="ML Subject Analyzer"
            description="AI-powered subject difficulty analysis with pass rate predictions and rankings"
            icon={<FaBrain />}
            color="orange"
            onClick={() => setShowDifficultyModal(true)}
          />
        </div>

        {/* Student History Section */}
        {loadingHistory && (
          <div className="card mb-8">
            <div className="text-center py-12">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600 mx-auto"></div>
              <p className="text-gray-500 mt-4">Loading student history...</p>
            </div>
          </div>
        )}

        {studentHistory && !loadingHistory && (
          <div className="mb-8">
            <SemesterSummaryTable
              studentInfo={studentHistory.student_info}
              semesterSummary={studentHistory.semester_summary}
              onRefresh={() => handleStudentSelect(selectedStudent)}
            />
          </div>
        )}
        
        {/* Recent Exams Table */}
        <div className="card">
          <h2 className="text-xl font-bold mb-4 flex items-center">
            <FaCalendar className="mr-2 text-blue-600" />
            Recent Exam Uploads
          </h2>
          
          {loading ? (
            <div className="text-center py-12">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600 mx-auto"></div>
              <p className="text-gray-500 mt-4">Loading exams...</p>
            </div>
          ) : exams.length === 0 ? (
            <div className="text-center py-12 text-gray-500">
              <FaCalendar className="text-5xl mx-auto mb-4 text-gray-300" />
              <p className="text-lg font-medium">No exams uploaded yet</p>
              <p className="text-sm mt-2">Click "Upload Results" to get started</p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Exam Name</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Uploaded Date</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Uploaded By</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {exams.map((exam, i) => (
                    <tr key={i} className="hover:bg-gray-50 transition-colors">
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{exam.exam_name}</td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {new Date(exam.uploaded_at).toLocaleDateString('en-US', { 
                          year: 'numeric', 
                          month: 'short', 
                          day: 'numeric',
                          hour: '2-digit',
                          minute: '2-digit'
                        })}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{exam.uploaded_by__username}</td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm">
                        <div className="flex space-x-3">
                          <button 
                            onClick={() => handleViewExamStatistics(exam.exam_name)}
                            className="text-blue-600 hover:text-blue-800 hover:bg-blue-50 p-2 rounded-md transition-colors"
                            title="View Statistics"
                          >
                            <FaChartBar className="text-lg" />
                          </button>
                          <button 
                            onClick={() => handleDownloadExam(exam.exam_name)}
                            className="text-green-600 hover:text-green-800 hover:bg-green-50 p-2 rounded-md transition-colors"
                            title="Download Results"
                          >
                            <FaDownload className="text-lg" />
                          </button>
                          <button 
                            onClick={() => handleDeleteExam(exam.exam_name)}
                            className="text-red-600 hover:text-red-800 hover:bg-red-50 p-2 rounded-md transition-colors"
                            title="Delete Exam"
                          >
                            <FaTrash className="text-lg" />
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>
      
      {/* Upload Modal */}
      {showUploadModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="bg-gradient-to-r from-blue-600 to-blue-700 text-white px-6 py-4 flex justify-between items-center rounded-t-xl">
              <h2 className="text-xl font-semibold flex items-center">
                <FaUpload className="mr-2" />
                Upload Exam Results
              </h2>
              <button
                onClick={() => setShowUploadModal(false)}
                className="text-white hover:text-gray-200 transition-colors text-2xl"
              >
                ×
              </button>
            </div>
            
            <form onSubmit={handleUpload} className="p-6">
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Course <span className="text-red-500">*</span>
                  </label>
                  <select 
                    value={course} 
                    onChange={(e) => setCourse(e.target.value)}
                    className="input-field"
                    required
                  >
                    <option value="btech">B.Tech</option>
                    <option value="mtech">M.Tech</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Academic Year <span className="text-red-500">*</span>
                  </label>
                  <select 
                    value={year} 
                    onChange={(e) => setYear(e.target.value)}
                    className="input-field"
                    required
                  >
                    <option value="">Select Year</option>
                    {getYearOptions().map(option => (
                      <option key={option.value} value={option.value}>{option.label}</option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Semester <span className="text-red-500">*</span>
                  </label>
                  <select 
                    value={semester} 
                    onChange={(e) => setSemester(e.target.value)}
                    className="input-field"
                    required
                  >
                    <option value="">Select Semester</option>
                    <option value="1">I Semester</option>
                    <option value="2">II Semester</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Result Type <span className="text-red-500">*</span>
                  </label>
                  <select 
                    value={resultType} 
                    onChange={(e) => setResultType(e.target.value)}
                    className="input-field"
                    required
                  >
                    <option value="">Select Result Type</option>
                    <option value="regular">Regular</option>
                    <option value="supplementary">Supplementary</option>
                    <option value="both">Regular and Supplementary</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Exam Held Month & Year <span className="text-red-500">*</span>
                  </label>
                  <div className="grid grid-cols-2 gap-4">
                    <select 
                      value={examMonth}
                      onChange={(e) => setExamMonth(e.target.value)}
                      className="input-field"
                    >
                      <option value="">Select Month</option>
                      <option value="01">January</option>
                      <option value="02">February</option>
                      <option value="03">March</option>
                      <option value="04">April</option>
                      <option value="05">May</option>
                      <option value="06">June</option>
                      <option value="07">July</option>
                      <option value="08">August</option>
                      <option value="09">September</option>
                      <option value="10">October</option>
                      <option value="11">November</option>
                      <option value="12">December</option>
                    </select>
                    <input 
                      type="number"
                      value={examYear}
                      onChange={(e) => setExamYear(e.target.value)}
                      placeholder="Year (e.g., 2026)"
                      min="2000"
                      max={new Date().getFullYear()}
                      className="input-field"
                    />
                  </div>
                  <p className="text-xs text-gray-500 mt-1">
                    Select month and year for exam name generation
                  </p>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Excel File <span className="text-red-500">*</span>
                  </label>
                  <input 
                    type="file" 
                    onChange={handleFileChange} 
                    accept=".xlsx,.xls,.csv" 
                    className="input-field"
                    required
                  />
                  <p className="text-xs text-gray-500 mt-1">
                    Excel file should contain: Roll Number, Student Name, and Subject details
                  </p>
                </div>
              </div>

              <div className="flex gap-3 mt-6">
                <button 
                  type="submit" 
                  disabled={uploadLoading || !file}
                  className="flex-1 bg-blue-600 text-white py-2.5 px-4 rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors font-medium"
                >
                  {uploadLoading ? "Uploading..." : "Upload Results"}
                </button>
                <button
                  type="button"
                  onClick={() => setShowUploadModal(false)}
                  disabled={uploadLoading}
                  className="px-6 py-2.5 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors font-medium"
                >
                  Cancel
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Statistics Modal */}
      {showStatsModal && statistics && (
        <StatisticsModal 
          statistics={statistics} 
          onClose={() => setShowStatsModal(false)} 
        />
      )}
      
      {/* Search Student Modal */}
      <SearchStudentModal 
        isOpen={showSearchModal} 
        onClose={() => setShowSearchModal(false)} 
        onStudentSelect={handleStudentSelect}
      />
      
      {/* Detained Students Modal */}
      <DetainedStudentsModal
        isOpen={showDetainedModal}
        onClose={() => setShowDetainedModal(false)}
      />

      {/* Timetable Generator Modal */}
      <TimetableModal
        isOpen={showTimetableModal}
        onClose={() => setShowTimetableModal(false)}
      />

      {/* Subject Difficulty Analyzer Modal */}
      {showDifficultyModal && (
        <SubjectDifficultyAnalyzer onClose={() => setShowDifficultyModal(false)} />
      )}

      {/* Toast Notification */}
      {toast.show && (
        <Toast 
          message={toast.message}
          type={toast.type}
          onClose={() => setToast({ show: false, message: '', type: '' })}
        />
      )}
    </div>
  );
};

export default AdminDashboard;
