import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { notificationService } from '../services/notificationService';
import Navbar from '../components/Navbar';
import { FaGraduationCap, FaBell, FaDownload, FaEye } from 'react-icons/fa';

const StudentCirculars = () => {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [notifications, setNotifications] = useState([]);
  const [loading, setLoading] = useState(false);
  const [filterType, setFilterType] = useState('all'); // all, exam_notification, circular
  const [filterCategory, setFilterCategory] = useState('all'); // for circulars

  const circularCategories = [
    { value: 'general', label: 'General' },
    { value: 'exam', label: 'Exam' },
    { value: 'academic', label: 'Academic' },
    { value: 'admission', label: 'Admission' },
    { value: 'event', label: 'Event' },
    { value: 'urgent', label: 'Urgent' },
  ];

  useEffect(() => {
    if (user?.role !== 'student') {
      navigate('/');
      return;
    }
    fetchNotifications();
  }, [user, navigate]);

  const fetchNotifications = async () => {
    localStorage.setItem('circulars_last_seen', new Date().toISOString());
    setLoading(true);
    try {
      // Get notifications from last 1 year using 'page' filter
      const data = await notificationService.getCombinedNotifications('page');
      setNotifications(data.items || []);
    } catch (error) {
      console.error('Failed to load notifications');
    } finally {
      setLoading(false);
    }
  };

  const getCategoryBadge = (category) => {
    const colors = {
      general: 'bg-gray-100 text-gray-800',
      exam: 'bg-blue-100 text-blue-800',
      academic: 'bg-green-100 text-green-800',
      admission: 'bg-yellow-100 text-yellow-800',
      event: 'bg-purple-100 text-purple-800',
      urgent: 'bg-red-100 text-red-800',
    };
    return colors[category] || colors.general;
  };

  const handleNotificationClick = async (notification) => {
    // Mark exam notifications as read
    if (notification.type === 'exam_notification' && !notification.is_read) {
      try {
        await notificationService.markAsRead(notification.notification_id);
        // Update local state
        setNotifications(notifications.map(n => 
          n.id === notification.id ? { ...n, is_read: true } : n
        ));
      } catch (error) {
        console.error('Failed to mark notification as read');
      }
    }

    // Navigate to dashboard for exam notifications
    if (notification.type === 'exam_notification' && notification.result_id) {
      navigate('/student/dashboard', { state: { scrollToResult: notification.result_id } });
    }
  };

  const handleDownloadAttachment = (fileUrl) => {
    if (!fileUrl) return;
    window.open(fileUrl, '_blank');
  };

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    });
  };

  // Get display title for notification
  const getNotificationTitle = (notification) => {
    if (notification.type === 'exam_notification') {
      // Use the message content as title (it contains exam name)
      return notification.message || notification.title || 'New Exam Result';
    } else if (notification.type === 'circular') {
      return notification.title;
    }
    return notification.title || notification.message;
  };

  // Filter notifications
  const filteredNotifications = notifications.filter(notification => {
    // Filter by type (exam_notification or circular)
    if (filterType !== 'all' && notification.type !== filterType) return false;
    
    // Filter by circular category (only for circulars)
    if (notification.type === 'circular' && filterCategory !== 'all' && 
        notification.category !== filterCategory) return false;
    
    return true;
  });

  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-6">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">Circulars and Notifications</h1>
          <p className="text-gray-600">View important announcements and notices from the past year</p>
        </div>

        {/* Filters */}
        <div className="bg-white p-4 rounded-lg shadow mb-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {/* Filter by Type */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Filter by Type</label>
              <select
                value={filterType}
                onChange={(e) => setFilterType(e.target.value)}
                className="border rounded-lg px-3 py-2 w-full focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
              >
                <option value="all">All Types</option>
                <option value="exam_notification">Exam Results</option>
                <option value="circular">Circulars</option>
              </select>
            </div>

            {/* Filter by Category (for circulars) */}
            {(filterType === 'all' || filterType === 'circular') && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Filter by Category</label>
                <select
                  value={filterCategory}
                  onChange={(e) => setFilterCategory(e.target.value)}
                  className="border rounded-lg px-3 py-2 w-full focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                >
                  <option value="all">All Categories</option>
                  {circularCategories.map(cat => (
                    <option key={cat.value} value={cat.value}>{cat.label}</option>
                  ))}
                </select>
              </div>
            )}
          </div>
        </div>

        {loading ? (
          <div className="text-center py-8">
            <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600"></div>
            <p className="mt-2 text-gray-600">Loading notifications...</p>
          </div>
        ) : filteredNotifications.length === 0 ? (
          <div className="bg-white p-8 rounded-lg shadow text-center text-gray-500">
            <p className="text-lg">No notifications available at the moment</p>
          </div>
        ) : (
          <div className="space-y-3">
            {filteredNotifications.map(notification => (
              <div 
                key={notification.id} 
                className={`bg-white rounded-lg shadow hover:shadow-md transition-shadow ${
                  notification.type === 'exam_notification' && !notification.is_read 
                    ? 'border-l-4 border-green-500' 
                    : 'border-l-4 border-transparent'
                }`}
              >
                <div className="p-4 flex items-center justify-between gap-4">
                  {/* Left side: Icon, Title, Date, and Badges */}
                  <div className="flex items-center gap-4 flex-1 min-w-0">
                    {/* Icon */}
                    <div className="flex-shrink-0">
                      {notification.type === 'exam_notification' ? (
                        <div className="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center">
                          <FaGraduationCap className="text-green-600 text-xl" />
                        </div>
                      ) : (
                        <div className="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
                          <FaBell className="text-blue-600 text-xl" />
                        </div>
                      )}
                    </div>

                    {/* Title, Date, and Badges */}
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 mb-1 flex-wrap">
                        <h3 className="text-lg font-semibold text-gray-900 truncate">
                          {getNotificationTitle(notification)}
                        </h3>
                        
                        {/* New Badge for unread exam notifications */}
                        {notification.type === 'exam_notification' && !notification.is_read && (
                          <span className="px-2 py-1 bg-red-500 text-white text-xs rounded-full font-medium flex-shrink-0">
                            New
                          </span>
                        )}

                        {/* Urgent Badge */}
                        {notification.category === 'urgent' && (
                          <span className="px-2 py-1 bg-red-100 text-red-800 text-xs rounded-full font-semibold flex-shrink-0">
                            URGENT
                          </span>
                        )}
                      </div>

                      <div className="flex items-center gap-3 text-sm text-gray-500 flex-wrap">
                        <span>{formatDate(notification.created_at)}</span>
                        
                        {/* Category Badge (for circulars) */}
                        {notification.type === 'circular' && notification.category && (
                          <span className={`px-2 py-1 rounded-full text-xs font-medium ${getCategoryBadge(notification.category)}`}>
                            {notification.category.charAt(0).toUpperCase() + notification.category.slice(1)}
                          </span>
                        )}
                      </div>
                    </div>
                  </div>

                  {/* Right side: Action Button */}
                  <div className="flex-shrink-0">
                    {/* View Result Button (for exam notifications) */}
                    {notification.type === 'exam_notification' && notification.result_id && (
                      <button
                        onClick={() => handleNotificationClick(notification)}
                        className="inline-flex items-center gap-2 bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition-colors font-medium"
                      >
                        <FaEye />
                        <span className="hidden sm:inline">View Result</span>
                      </button>
                    )}
                    
                    {/* Download Circular Button (for circulars) */}
                    {notification.type === 'circular' && notification.file_url && (
                      <button
                        onClick={() => handleDownloadAttachment(notification.file_url)}
                        className="inline-flex items-center gap-2 bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-700 transition-colors font-medium"
                      >
                        <FaDownload />
                        <span className="hidden sm:inline">Download Circular</span>
                      </button>
                    )}

                    {/* If circular has no file, just show a view button */}
                    {notification.type === 'circular' && !notification.file_url && (
                      <span className="text-sm text-gray-400 italic">No attachment</span>
                    )}
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default StudentCirculars;
