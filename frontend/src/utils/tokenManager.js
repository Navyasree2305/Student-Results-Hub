// Token management utilities
const TOKEN_KEY = 'spmvv_auth_token';
const REFRESH_TOKEN_KEY = 'spmvv_refresh_token';
const USER_KEY = 'spmvv_user';
const CSRF_TOKEN_KEY = 'spmvv_csrf_token';

export const tokenManager = {
  // Get token from sessionStorage (more secure than localStorage)
  getToken: () => {
    return sessionStorage.getItem(TOKEN_KEY);
  },

  // Set token
  setToken: (token) => {
    sessionStorage.setItem(TOKEN_KEY, token);
  },

  // Remove token
  removeToken: () => {
    sessionStorage.removeItem(TOKEN_KEY);
  },

  // Get refresh token
  getRefreshToken: () => {
    return sessionStorage.getItem(REFRESH_TOKEN_KEY);
  },

  // Set refresh token
  setRefreshToken: (token) => {
    sessionStorage.setItem(REFRESH_TOKEN_KEY, token);
  },

  // Remove refresh token
  removeRefreshToken: () => {
    sessionStorage.removeItem(REFRESH_TOKEN_KEY);
  },

  // Get user data
  getUser: () => {
    const user = sessionStorage.getItem(USER_KEY);
    return user ? JSON.parse(user) : null;
  },

  // Set user data
  setUser: (user) => {
    sessionStorage.setItem(USER_KEY, JSON.stringify(user));
  },

  // Remove user data
  removeUser: () => {
    sessionStorage.removeItem(USER_KEY);
  },

  // Get CSRF token
  getCsrfToken: () => {
    return sessionStorage.getItem(CSRF_TOKEN_KEY);
  },

  // Set CSRF token
  setCsrfToken: (token) => {
    sessionStorage.setItem(CSRF_TOKEN_KEY, token);
  },

  // Remove CSRF token
  removeCsrfToken: () => {
    sessionStorage.removeItem(CSRF_TOKEN_KEY);
  },

  // Clear all auth data
  clearAll: () => {
    sessionStorage.removeItem(TOKEN_KEY);
    sessionStorage.removeItem(REFRESH_TOKEN_KEY);
    sessionStorage.removeItem(USER_KEY);
    sessionStorage.removeItem(CSRF_TOKEN_KEY);
  },

  // Check if token is expired
  isTokenExpired: (token) => {
    if (!token) return true;
    
    try {
      const payload = JSON.parse(atob(token.split('.')[1]));
      const expiry = payload.exp * 1000; // Convert to milliseconds
      return Date.now() >= expiry;
    } catch (error) {
      return true;
    }
  }
};
