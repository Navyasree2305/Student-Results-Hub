import React, { useState, useEffect } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { resultsService } from '../services/resultsService';
import { notificationService } from '../services/notificationService';
import Navbar from '../components/Navbar';
import ChangePasswordModal from '../components/ChangePasswordModal';
import IdleWarningModal from '../components/IdleWarningModal';
import { useIdleTimeout } from '../hooks/useIdleTimeout';
import { FaGraduationCap, FaBell, FaBullhorn, FaChevronDown, FaChevronUp } from 'react-icons/fa';

const StudentDashboard = () => {
  const [consolidatedResults, setConsolidatedResults] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showPasswordModal, setShowPasswordModal] = useState(false);
  const [notifications, setNotifications] = useState([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const [expandedSemesters, setExpandedSemesters] = useState({});
  const [expandedNotifications, setExpandedNotifications] = useState({});
  const [hasNewCirculars, setHasNewCirculars] = useState(false);
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();

  const handleIdle = () => {
    logout();
    navigate('/login', { state: { message: 'You were logged out due to inactivity' } });
  };

  const { showWarning, remainingTime, stayActive } = useIdleTimeout(handleIdle);

  const handleLogoutNow = () => { logout(); navigate('/login'); };

  useEffect(() => {
    fetchConsolidatedResults();
    fetchNotifications();
    const interval = setInterval(() => {
      fetchNotifications();
      fetchConsolidatedResults();
    }, 60000);
    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    if (location.state?.scrollToResult && consolidatedResults.length > 0) {
      const resultId = location.state.scrollToResult;
      const targetSemester = consolidatedResults.find(sem =>
        sem.attempts.some(att => att.result_id === resultId)
      );
      if (targetSemester) {
        const key = `${targetSemester.year}-${targetSemester.semester}`;
        setExpandedSemesters(prev => ({ ...prev, [key]: true }));
        setTimeout(() => {
          const element = document.getElementById(`semester-${key}`);
          if (element) element.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }, 300);
        navigate(location.pathname, { replace: true, state: {} });
      }
    }
  }, [location.state, consolidatedResults, navigate, location.pathname]);

  const fetchConsolidatedResults = async () => {
    setLoading(true);
    try {
      const data = await resultsService.getConsolidatedResults();
      setConsolidatedResults(data.consolidated_results || []);
      const expanded = {};
      (data.consolidated_results || []).forEach((semResult) => {
        expanded[`${semResult.year}-${semResult.semester}`] = false;
      });
      setExpandedSemesters(expanded);
    } catch (err) {
      setError('Failed to load results');
    } finally {
      setLoading(false);
    }
  };

  const fetchNotifications = async () => {
    try {
      const data = await notificationService.getCombinedNotifications();
      setNotifications(data.notifications || []);
      setUnreadCount(data.unread_count || 0);
      const now = new Date();
      const twentyFourHoursAgo = new Date(now.getTime() - 24 * 60 * 60 * 1000);
      const newCirculars = (data.items || []).filter(item =>
        item.type === 'circular' && new Date(item.created_at) > twentyFourHoursAgo
      );
      setHasNewCirculars(newCirculars.length > 0);
    } catch (err) {}
  };

  const handleNotificationClick = async (notification) => {
    if (notification.type === 'exam_notification') {
      if (notification.notification_id && !notification.is_read) {
        try { await notificationService.markAsRead(notification.notification_id); fetchNotifications(); } catch (err) {}
      }
      if (notification.result_id) {
        const targetSemester = consolidatedResults.find(sem =>
          sem.attempts.some(att => att.result_id === notification.result_id)
        );
        if (targetSemester) {
          const key = `${targetSemester.year}-${targetSemester.semester}`;
          setExpandedSemesters(prev => ({ ...prev, [key]: true }));
          setTimeout(() => {
            const element = document.getElementById(`semester-${key}`);
            if (element) element.scrollIntoView({ behavior: 'smooth', block: 'start' });
          }, 100);
        }
      }
    } else if (notification.type === 'circular') {
      navigate('/student/circulars');
    }
  };

  const toggleSemester = (key) => setExpandedSemesters(prev => ({ ...prev, [key]: !prev[key] }));
  const toggleNotification = (index) => setExpandedNotifications(prev => ({ ...prev, [index]: !prev[index] }));
  const getResultBadgeColor = (result) => result === 'Pass' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800';

  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">
            Welcome, {user?.first_name && user?.last_name ? `${user.first_name} ${user.last_name}` : user?.roll_number}
          </h1>
          <p className="text-gray-600 mt-2">Roll Number: {user?.roll_number}</p>
        </div>

        {notifications.length > 0 && (
          <div className="mb-6 bg-blue-50 border border-blue-200 rounded-lg p-4">
            <div className="flex items-start">
              <FaBell className="text-blue-500 text-xl mr-3 mt-1" />
              <div className="flex-1">
                <h3 className="font-semibold text-blue-900 mb-2">Recent Updates ({notifications.length})</h3>
                <div className="space-y-2">
                  {notifications.slice(0, 3).map((notification, index) => {
                    const isExpanded = expandedNotifications[index];
                    return (
                      <div key={index} className="bg-white rounded border border-blue-100 overflow-hidden">
                        <div className="p-3 cursor-pointer hover:bg-gray-50 transition" onClick={() => toggleNotification(index)}>
                          <div className="flex items-center justify-between">
                            <div className="flex items-center flex-1">
                              {notification.type === 'circular' && <FaBullhorn className="text-purple-500 mr-2" />}
                              <p className="text-sm text-gray-700 font-medium truncate">{notification.title || notification.message}</p>
                            </div>
                            <div className="flex items-center gap-2">
                              <span className="text-xs text-gray-500 whitespace-nowrap">{new Date(notification.created_at).toLocaleDateString()}</span>
                              {isExpanded ? <FaChevronUp className="text-gray-400" /> : <FaChevronDown className="text-gray-400" />}
                            </div>
                          </div>
                        </div>
                        {isExpanded && (
                          <div className="px-3 pb-3 border-t border-gray-100 pt-2">
                            <p className="text-sm text-gray-600 mb-2">{notification.message}</p>
                            <button onClick={(e) => { e.stopPropagation(); handleNotificationClick(notification); }}
                              className="text-xs text-blue-600 hover:text-blue-800 font-medium">
                              {notification.type === 'circular' ? 'View Details' : 'View Results'}
                            </button>
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Quick actions: only Circulars + Total Semesters */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8">
          <button onClick={() => navigate("/student/circulars")}
            className="card flex items-center space-x-4 hover:shadow-lg transition-shadow relative">
            <FaBullhorn className="text-3xl text-purple-600" />
            <div className="text-left">
              <h3 className="font-semibold text-gray-900 flex items-center gap-2">
                Circulars and Notifications
                {hasNewCirculars && (
                  <span className="inline-block px-2 py-0.5 text-xs font-bold text-white bg-red-500 rounded-full animate-pulse">NEW</span>
                )}
              </h3>
              <p className="text-sm text-gray-600">Check notifications and announcements</p>
            </div>
          </button>
          <div className="card flex items-center space-x-4">
            <FaGraduationCap className="text-3xl text-primary-600" />
            <div className="text-left">
              <h3 className="font-semibold text-gray-900">Total Semesters</h3>
              <p className="text-2xl font-bold text-primary-600">{consolidatedResults.length}</p>
            </div>
          </div>
        </div>

        {loading ? (
          <div className="text-center py-12">
            <div className="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
            <p className="mt-4 text-gray-600">Loading your results...</p>
          </div>
        ) : error ? (
          <div className="bg-red-50 border border-red-200 rounded-lg p-6 text-center">
            <p className="text-red-800">{error}</p>
          </div>
        ) : consolidatedResults.length === 0 ? (
          <div className="bg-white rounded-lg shadow p-8 text-center">
            <FaGraduationCap className="text-6xl text-gray-300 mx-auto mb-4" />
            <p className="text-gray-600 text-lg">No results available yet</p>
          </div>
        ) : (
          <div className="space-y-6">
            {consolidatedResults.map((semesterData) => {
              const key = `${semesterData.year}-${semesterData.semester}`;
              const isExpanded = expandedSemesters[key];
              return (
                <div key={key} id={`semester-${key}`} className="bg-white rounded-lg shadow">
                  <div className="p-6 cursor-pointer hover:bg-gray-50 transition" onClick={() => toggleSemester(key)}>
                    <div className="flex justify-between items-center mb-4">
                      <div className="flex items-center gap-4">
                        <h2 className="text-2xl font-bold text-gray-900">
                          {semesterData.year_display} {semesterData.semester_display}
                        </h2>
                        <span className="text-sm text-gray-500">
                          {semesterData.attempts.length} attempt{semesterData.attempts.length > 1 ? 's' : ''}
                        </span>
                        {isExpanded ? <FaChevronUp className="text-gray-500" /> : <FaChevronDown className="text-gray-500" />}
                      </div>
                    </div>
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                      <div className="border rounded-lg p-4">
                        <p className="text-sm text-gray-600 mb-1">Total Marks</p>
                        <p className="text-2xl font-bold text-gray-900">
                          {semesterData.attempts[semesterData.attempts.length - 1]?.total_marks || 0}
                        </p>
                      </div>
                      <div className="border rounded-lg p-4">
                        <p className="text-sm text-gray-600 mb-1">Current SGPA</p>
                        <p className="text-2xl font-bold text-gray-900">
                          {semesterData.current_sgpa?.toFixed(2) || 'N/A'}
                        </p>
                      </div>
                      <div className="border rounded-lg p-4">
                        <p className="text-sm text-gray-600 mb-1">Result</p>
                        <span className={`inline-block px-3 py-1 rounded-full text-sm font-semibold ${getResultBadgeColor(semesterData.current_result)}`}>
                          {semesterData.current_result}
                        </span>
                      </div>
                      <div className="border rounded-lg p-4">
                        <p className="text-sm text-gray-600 mb-1">Pending Subjects</p>
                        <p className="text-2xl font-bold text-red-600">{semesterData.pending_subjects_count}</p>
                        {semesterData.pending_subjects_count > 0 && (
                          <p className="text-xs text-gray-500 mt-1">
                            {semesterData.pending_subjects.map(s => s.subject_code).join(', ')}
                          </p>
                        )}
                      </div>
                    </div>
                  </div>

                  {isExpanded && (
                    <div className="border-t p-6 bg-gray-50">
                      <h3 className="font-semibold text-gray-900 mb-4">Exam Attempts</h3>
                      {semesterData.attempts.map((attempt) => (
                        <div key={attempt.result_id} className="mb-6 last:mb-0">
                          <div className="bg-white rounded-lg p-4 mb-3">
                            <div className="flex justify-between items-start mb-2">
                              <div>
                                <h4 className="font-semibold text-gray-900">{attempt.exam_name}</h4>
                                <p className="text-sm text-gray-600">{attempt.result_type_display} • Uploaded: {attempt.uploaded_at}</p>
                              </div>
                              <span className={`inline-block px-2 py-1 rounded text-xs font-semibold ${getResultBadgeColor(attempt.original_result)}`}>
                                {attempt.original_result}
                              </span>
                            </div>
                          </div>
                          <div className="bg-white rounded-lg overflow-hidden">
                            <h5 className="font-semibold text-gray-900 p-4 bg-gray-100">Subject-wise Details</h5>
                            <div className="overflow-x-auto">
                              <table className="min-w-full divide-y divide-gray-200">
                                <thead className="bg-gray-50">
                                  <tr>
                                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Subject</th>
                                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Subject Code</th>
                                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Internal Marks</th>
                                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">External Marks</th>
                                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Total Marks</th>
                                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Grade</th>
                                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Credits</th>
                                  </tr>
                                </thead>
                                <tbody className="bg-white divide-y divide-gray-200">
                                  {attempt.subjects.map((subject) => (
                                    <tr key={subject.id} className={subject.grade === 'F' ? 'bg-red-50' : ''}>
                                      <td className="px-4 py-3 text-sm text-gray-900">{subject.subject_name}</td>
                                      <td className="px-4 py-3 text-sm text-gray-900">{subject.subject_code}</td>
                                      <td className="px-4 py-3 text-sm text-gray-900">{subject.internal_marks}</td>
                                      <td className="px-4 py-3 text-sm text-gray-900">{subject.external_marks}</td>
                                      <td className="px-4 py-3 text-sm font-semibold text-gray-900">{subject.total_marks}</td>
                                      <td className="px-4 py-3 text-sm">
                                        <span className={`inline-block px-2 py-1 rounded text-xs font-semibold ${
                                          subject.grade === 'F' ? 'bg-red-100 text-red-800' :
                                          subject.grade === 'O' || subject.grade === 'A' ? 'bg-green-100 text-green-800' :
                                          'bg-gray-100 text-gray-800'
                                        }`}>{subject.grade}</span>
                                      </td>
                                      <td className="px-4 py-3 text-sm text-gray-900">{subject.credits}</td>
                                    </tr>
                                  ))}
                                </tbody>
                              </table>
                            </div>
                          </div>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}
      </div>

      {showPasswordModal && <ChangePasswordModal onClose={() => setShowPasswordModal(false)} />}

      {showWarning && (
        <IdleWarningModal
          remainingTime={remainingTime}
          onStayActive={stayActive}
          onLogout={handleLogoutNow}
        />
      )}
    </div>
  );
};

export default StudentDashboard;
