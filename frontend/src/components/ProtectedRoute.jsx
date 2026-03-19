import React from 'react';
import { Navigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

const ADMIN_ROLES = ['admin', 'dean', 'vice_principal', 'principal', 'hod', 'faculty', 'staff'];

const ProtectedRoute = ({ children, requiredRole }) => {
  const { user, loading, isAuthenticated } = useAuth();

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  if (!isAuthenticated()) {
    return <Navigate to="/login" replace />;
  }

  if (requiredRole === 'admin' && !ADMIN_ROLES.includes(user?.role)) {
    return <Navigate to="/unauthorized" replace />;
  }

  if (requiredRole === 'student' && user?.role !== 'student') {
    return <Navigate to="/unauthorized" replace />;
  }

  return children;
};

export default ProtectedRoute;
