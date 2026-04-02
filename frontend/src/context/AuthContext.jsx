import React, { createContext, useState, useContext, useEffect } from 'react';
import { authService } from '../services/authService';
import { tokenManager } from '../utils/tokenManager';

const AuthContext = createContext(null);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const initializeAuth = () => {
      const storedUser = tokenManager.getUser();
      const token = tokenManager.getToken();
      if (storedUser && token && !tokenManager.isTokenExpired(token)) {
        setUser(storedUser);
      } else {
        tokenManager.clearAll();
      }
      setLoading(false);
    };
    initializeAuth();
  }, []);

  const login = async (credentials, userType = 'student') => {
    try {
      let response;
      if (userType === 'admin') {
        response = await authService.adminLogin(credentials.username, credentials.password);
      } else {
        response = await authService.studentLogin(credentials.hallTicketNumber, credentials.password);
      }
      setUser(response.user);
      return { success: true, user: response.user };
    } catch (error) {
      return {
        success: false,
        error: error.response?.data?.error || 'Login failed. Please try again.'
      };
    }
  };

  const register = async (userData) => {
    try {
      const response = await authService.register(userData);
      return { success: true, message: response.message };
    } catch (error) {
      return {
        success: false,
        error: error.response?.data?.error || 'Registration failed. Please try again.'
      };
    }
  };

  const logout = async () => {
    await authService.logout();
    setUser(null);
    tokenManager.clearAll();
  };

  const changePassword = async (oldPassword, newPassword) => {
    try {
      const response = await authService.changePassword(oldPassword, newPassword);
      return { success: true, message: response.message };
    } catch (error) {
      return {
        success: false,
        error: error.response?.data?.error || 'Failed to change password. Please try again.'
      };
    }
  };

  // Merge updated fields into user state AND sessionStorage immediately.
  const updateUser = (updatedFields) => {
    setUser((prev) => {
      const merged = { ...prev, ...updatedFields };
      tokenManager.setUser(merged);
      return merged;
    });
  };

  const value = {
    user,
    loading,
    login,
    register,
    logout,
    changePassword,
    updateUser,
    isAuthenticated: authService.isAuthenticated,
    hasRole: authService.hasRole,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};
