import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import ProtectedRoute from './components/ProtectedRoute';
import Login from './pages/Login';
import Register from './pages/Register';
import StudentDashboard from './pages/StudentDashboard';
import AdminDashboard from './pages/AdminDashboard';
import UserManagement from './pages/UserManagement';
import CircularManagement from './pages/CircularManagement';
import StudentCirculars from './pages/StudentCirculars';
import HallTicketPage from './pages/HallTicketPage';

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route path="/" element={<Navigate to="/login" replace />} />
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Register />} />
          <Route path="/student/dashboard" element={
            <ProtectedRoute requiredRole="student">
              <StudentDashboard />
            </ProtectedRoute>
          } />
          <Route path="/student/circulars" element={
            <ProtectedRoute requiredRole="student">
              <StudentCirculars />
            </ProtectedRoute>
          } />
          <Route path="/admin/dashboard" element={
            <ProtectedRoute requiredRole="admin">
              <AdminDashboard />
            </ProtectedRoute>
          } />
          <Route path="/admin/circulars" element={
            <ProtectedRoute requiredRole="admin">
              <CircularManagement />
            </ProtectedRoute>
          } />
          <Route path="/admin/hall-tickets" element={
            <ProtectedRoute requiredRole="admin">
              <HallTicketPage />
            </ProtectedRoute>
          } />
          <Route path="/user-management" element={
            <ProtectedRoute requiredRole="admin">
              <UserManagement />
            </ProtectedRoute>
          } />
          <Route path="/unauthorized" element={
            <div className="min-h-screen flex items-center justify-center bg-gray-50">
              <div className="text-center">
                <h1 className="text-4xl font-bold text-red-600 mb-4">Unauthorized</h1>
                <p className="text-gray-600">You do not have permission to access this page.</p>
              </div>
            </div>
          } />
          <Route path="*" element={
            <div className="min-h-screen flex items-center justify-center bg-gray-50">
              <div className="text-center">
                <h1 className="text-4xl font-bold text-gray-800 mb-4">404 - Not Found</h1>
                <p className="text-gray-600">The page you are looking for does not exist.</p>
              </div>
            </div>
          } />
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  );
}

export default App;
