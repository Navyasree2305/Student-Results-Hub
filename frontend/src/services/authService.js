import api from './api';
import { tokenManager } from '../utils/tokenManager';

export const authService = {
  // Student login
  studentLogin: async (hallTicketNumber, password) => {
    const response = await api.post('/login/', {
      username: hallTicketNumber,
      password: password,
      login_type: 'student',
    });
    
    const { access, refresh, user } = response.data;
    tokenManager.setToken(access);
    tokenManager.setRefreshToken(refresh);
    tokenManager.setUser(user);
    
    return response.data;
  },

  // Admin login
  adminLogin: async (username, password) => {
    const response = await api.post('/login/', {
      username: username,
      password: password,
      login_type: 'admin',
    });
    
    const { access, refresh, user } = response.data;
    tokenManager.setToken(access);
    tokenManager.setRefreshToken(refresh);
    tokenManager.setUser(user);
    
    return response.data;
  },

  // Student registration
  register: async (userData) => {
    const response = await api.post('/register/', userData);
    return response.data;
  },

  // Logout
  logout: async () => {
    try {
      const access = tokenManager.getToken();
      const refresh = tokenManager.getRefreshToken();
      
      await api.post('/logout/', {
        access: access,
        refresh: refresh
      });
    } catch (error) {
      console.error('Logout error:', error);
    } finally {
      tokenManager.clearAll();
    }
  },

  // Change password
  changePassword: async (oldPassword, newPassword) => {
    const response = await api.post('/change-password/', {
      old_password: oldPassword,
      new_password: newPassword,
    });
    return response.data;
  },

  // Get current user
  getCurrentUser: () => {
    return tokenManager.getUser();
  },

  // Check if authenticated
  isAuthenticated: () => {
    const token = tokenManager.getToken();
    return token && !tokenManager.isTokenExpired(token);
  },

  // Check user role
  hasRole: (role) => {
    const user = tokenManager.getUser();
    return user?.role === role;
  },
};
