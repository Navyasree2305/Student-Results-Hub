import React, { useState, useRef, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { FaUserCircle, FaChevronDown, FaKey, FaUser, FaSignOutAlt } from 'react-icons/fa';
import ChangePasswordModal from './ChangePasswordModal';
import ProfileEditModal from './ProfileEditModal';
import useEscapeKey from '../hooks/useEscapeKey';
import { profileService } from '../services/profileService';

const Navbar = () => {
  const { user, logout, updateUser } = useAuth();
  const navigate = useNavigate();
  const [showDropdown, setShowDropdown] = useState(false);
  const [showPasswordModal, setShowPasswordModal] = useState(false);
  const [showProfileModal, setShowProfileModal] = useState(false);
  const [profilePhotoUrl, setProfilePhotoUrl] = useState(null);
  const dropdownRef = useRef(null);

  useEscapeKey(() => setShowDropdown(false), showDropdown);

  useEffect(() => {
    if (user && user.role === 'student') {
      loadProfilePhoto();
    }
  }, [user]);

  const buildAbsoluteUrl = (url) => {
    if (!url) return null;
    if (url.startsWith('http')) return url;
    const base = (import.meta.env.VITE_API_URL || 'http://localhost:8000').replace(/\/api\/?$/, '');
    return base + url;
  };

  const loadProfilePhoto = async () => {
    try {
      const data = await profileService.getProfile();
      if (data.profile_photo_url) {
        setProfilePhotoUrl(buildAbsoluteUrl(data.profile_photo_url));
      }
    } catch (err) {}
  };

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setShowDropdown(false);
      }
    };
    if (showDropdown) document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, [showDropdown]);

  const handleLogout = async () => { await logout(); navigate('/login'); };
  const handleChangePassword = () => { setShowDropdown(false); setShowPasswordModal(true); };
  const handleEditProfile = () => { setShowDropdown(false); setShowProfileModal(true); };

  const handleProfileUpdate = (updatedData) => {
    if (updatedData?.photoUrl) setProfilePhotoUrl(updatedData.photoUrl);
    if (updatedData?.first_name !== undefined) {
      updateUser({
        first_name: updatedData.first_name,
        last_name: updatedData.last_name,
        email: updatedData.email,
      });
    }
  };

  if (!user) return null;

  const ADMIN_ROLES = ['admin', 'dean', 'vice_principal', 'principal', 'hod', 'faculty', 'staff'];

  const getDashboardLink = () => {
    if (ADMIN_ROLES.includes(user.role)) return '/admin/dashboard';
    return '/student/dashboard';
  };

  const getDisplayName = () => {
    if (user.role === 'admin') return user.username;
    if (user.first_name && user.last_name) return `${user.first_name} ${user.last_name}`;
    if (user.first_name) return user.first_name;
    return user.hall_ticket_number || user.username;
  };

  return (
    <>
      <nav className="bg-white shadow-lg sticky top-0 z-40">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            <div className="flex items-center space-x-8">
              <Link to={getDashboardLink()} className="flex items-center space-x-2">
                <img src="/logo.png" alt="SPMVV Logo" className="h-9 w-auto object-contain" />
                <span className="text-xl font-bold text-primary-600 hover:text-primary-700 transition-colors">
                  SPMVV SOET Exam Results
                </span>
              </Link>
            </div>
            <div className="flex items-center space-x-4">
              <div className="relative" ref={dropdownRef}>
                <button onClick={() => setShowDropdown(!showDropdown)}
                  className="flex items-center space-x-2 px-3 py-2 rounded-lg hover:bg-gray-100 transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500">
                  {user.role === 'student' && profilePhotoUrl ? (
                    <img src={profilePhotoUrl} alt="Profile"
                      className="w-8 h-8 rounded-full object-cover border border-gray-300" />
                  ) : (
                    <FaUserCircle className="text-gray-600 text-2xl" />
                  )}
                  <div className="hidden md:block text-left">
                    <p className="text-sm font-medium text-gray-700">{getDisplayName()}</p>
                    <p className="text-xs text-gray-500 capitalize">{user.role}</p>
                  </div>
                  <FaChevronDown className={`text-gray-500 text-xs transition-transform duration-200 ${showDropdown ? 'transform rotate-180' : ''}`} />
                </button>

                {showDropdown && (
                  <div className="absolute right-0 mt-2 w-56 bg-white rounded-lg shadow-xl border border-gray-200 py-2 animate-slide-in-top">
                    <div className="px-4 py-3 border-b border-gray-100">
                      <p className="text-sm font-semibold text-gray-900">{getDisplayName()}</p>
                    </div>
                    <div className="py-2">
                      {user.role === 'student' && (
                        <button onClick={handleEditProfile}
                          className="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors flex items-center space-x-3">
                          <FaUser className="text-gray-500" /><span>Edit Profile</span>
                        </button>
                      )}
                      <button onClick={handleChangePassword}
                        className="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors flex items-center space-x-3">
                        <FaKey className="text-gray-500" /><span>Change Password</span>
                      </button>
                      <div className="border-t border-gray-100 my-2"></div>
                      <button onClick={handleLogout}
                        className="w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors flex items-center space-x-3">
                        <FaSignOutAlt className="text-red-500" /><span>Logout</span>
                      </button>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </nav>

      <ChangePasswordModal isOpen={showPasswordModal} onClose={() => setShowPasswordModal(false)} />

      {user.role === 'student' && (
        <ProfileEditModal
          isOpen={showProfileModal}
          onClose={() => setShowProfileModal(false)}
          onUpdate={handleProfileUpdate}
        />
      )}
    </>
  );
};

export default Navbar;
