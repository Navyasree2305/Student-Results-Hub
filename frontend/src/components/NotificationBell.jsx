import React, { useState, useEffect, useRef } from 'react';
import { FaBell } from 'react-icons/fa';
import { notificationService } from '../services/notificationService';
import { useNavigate } from 'react-router-dom';

const NotificationBell = () => {
  const [unreadCount, setUnreadCount] = useState(0);
  const [notifications, setNotifications] = useState([]);
  const [showDropdown, setShowDropdown] = useState(false);
  const [loading, setLoading] = useState(false);
  const dropdownRef = useRef(null);
  const navigate = useNavigate();

  useEffect(() => {
    fetchNotifications();
    const interval = setInterval(fetchNotifications, 60000);
    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setShowDropdown(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const fetchNotifications = async () => {
    try {
      const data = await notificationService.getCombinedNotifications('bell');
      setUnreadCount(data.unread_count || 0);
      setNotifications(data.notifications || []);
    } catch (error) {
      console.error('Error fetching notifications:', error);
    }
  };

  const handleBellClick = () => {
    setShowDropdown(!showDropdown);
    if (!showDropdown) {
      fetchNotifications();
    }
  };

  const handleMarkAsRead = async (notification) => {
    try {
      if (notification.type === 'exam_notification' && notification.notification_id) {
        await notificationService.markAsRead(notification.notification_id);
      }
      fetchNotifications();
    } catch (error) {
      console.error('Error marking notification as read:', error);
    }
  };

  const handleNotificationClick = (notification) => {
    if (notification.type === 'exam_notification' && !notification.is_read) {
      handleMarkAsRead(notification);
    }
    setShowDropdown(false);
    navigate('/student/circulars');
  };

  const handleViewAll = () => {
    setShowDropdown(false);
    navigate('/student/circulars');
  };

  const formatTimeAgo = (dateString) => {
    const date = new Date(dateString);
    const now = new Date();
    const diffInHours = Math.floor((now - date) / (1000 * 60 * 60));
    if (diffInHours < 1) {
      const diffInMinutes = Math.floor((now - date) / (1000 * 60));
      return `${diffInMinutes}m ago`;
    } else if (diffInHours < 24) {
      return `${diffInHours}h ago`;
    } else {
      return date.toLocaleDateString();
    }
  };

  return (
    <div className="relative" ref={dropdownRef}>
      <button onClick={handleBellClick} className="relative p-2 text-gray-600 hover:text-primary-600 focus:outline-none" title="Notifications (last 24 hours)">
        <FaBell className="text-2xl" />
        {unreadCount > 0 && (
          <span className="absolute top-0 right-0 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white transform translate-x-1/2 -translate-y-1/2 bg-red-600 rounded-full">
            {unreadCount > 99 ? '99+' : unreadCount}
          </span>
        )}
      </button>
      {showDropdown && (
        <div className="absolute right-0 mt-2 w-96 bg-white rounded-lg shadow-xl z-50 max-h-96 overflow-y-auto">
          <div className="p-4 border-b border-gray-200 flex justify-between items-center sticky top-0 bg-white">
            <div>
              <h3 className="text-lg font-semibold text-gray-800">Notifications</h3>
              <p className="text-xs text-gray-500">Last 24 hours</p>
            </div>
            <button onClick={handleViewAll} className="text-sm text-primary-600 hover:text-primary-700 font-medium">View All</button>
          </div>
          {loading ? (
            <div className="p-4 text-center"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600 mx-auto"></div></div>
          ) : notifications.length === 0 ? (
            <div className="p-6 text-center text-gray-500"><FaBell className="text-4xl text-gray-300 mx-auto mb-2" /><p>No new notifications in last 24 hours</p></div>
          ) : (
            <div>
              {notifications.map((notification) => (
                <div key={notification.id} className={`p-4 border-b border-gray-100 hover:bg-gray-50 cursor-pointer transition-colors ${!notification.is_read ? 'bg-blue-50' : ''}`} onClick={() => handleNotificationClick(notification)}>
                  <div className="flex items-start justify-between">
                    <div className="flex-1">
                      <div className="flex items-center gap-2">
                        <span className={`inline-block px-2 py-0.5 text-xs font-semibold rounded ${notification.type === 'exam_notification' ? 'bg-green-100 text-green-800' : 'bg-blue-100 text-blue-800'}`}>
                          {notification.type === 'exam_notification' ? 'Exam Result' : notification.category || 'Circular'}
                        </span>
                        {!notification.is_read && (<span className="w-2 h-2 bg-red-600 rounded-full"></span>)}
                      </div>
                      <p className="text-sm text-gray-800 font-medium mt-1">{notification.title}</p>
                      <p className="text-xs text-gray-600 mt-1 line-clamp-2">{notification.message}</p>
                    </div>
                  </div>
                  <p className="text-xs text-gray-400 mt-2">{formatTimeAgo(notification.created_at)}</p>
                </div>
              ))}
            </div>
          )}
          {notifications.length > 0 && (
            <div className="p-3 border-t border-gray-200 text-center bg-gray-50">
              <button onClick={handleViewAll} className="text-sm text-primary-600 hover:text-primary-700 font-medium">View All Notifications & Circulars →</button>
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export default NotificationBell;
