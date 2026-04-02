import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { sanitizeInput } from '../utils/validation';

const Login = () => {
  const [userType, setUserType] = useState('student');
  const [formData, setFormData] = useState({
    hallTicketNumber: '',
    username: '',
    password: ''
  });
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: sanitizeInput(value) }));
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: '' }));
    }
  };

  const validateForm = () => {
    const newErrors = {};
    if (userType === 'student') {
      if (!formData.hallTicketNumber.trim()) {
        newErrors.hallTicketNumber = 'Hall Ticket Number is required';
      }
    } else {
      if (!formData.username.trim()) {
        newErrors.username = 'Username is required';
      }
    }
    if (!formData.password) {
      newErrors.password = 'Password is required';
    }
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validateForm()) return;
    setLoading(true);
    try {
      const credentials = userType === 'student'
        ? { hallTicketNumber: formData.hallTicketNumber, password: formData.password }
        : { username: formData.username, password: formData.password };
      const result = await login(credentials, userType);
      if (result.success) {
        const role = result.user?.role;
        if (role === 'student') {
          navigate('/student/dashboard');
        } else {
          navigate('/admin/dashboard');
        }
      } else {
        setErrors({ general: result.error });
      }
    } catch (error) {
      setErrors({ general: 'An unexpected error occurred. Please try again.' });
    } finally {
      setLoading(false);
    }
  };

  const studentBtnClass = 'flex-1 py-2 px-4 rounded-md transition-colors ' + (userType === 'student' ? 'bg-primary-600 text-white' : 'text-gray-600 hover:text-gray-800');
  const adminBtnClass = 'flex-1 py-2 px-4 rounded-md transition-colors ' + (userType === 'admin' ? 'bg-primary-600 text-white' : 'text-gray-600 hover:text-gray-800');

  return (
    <div
      className="min-h-screen flex items-center justify-center p-4"
      style={{
        backgroundImage: 'url(/banner_arch.jpg)',
        backgroundSize: 'cover',
        backgroundPosition: 'center',
        backgroundRepeat: 'no-repeat',
      }}
    >
      <div className="absolute inset-0 bg-black/50" />

      <div className="max-w-md w-full relative z-10">
        <div className="text-center mb-8">
          <img src="/logo.png" alt="SPMVV Logo" className="h-20 w-auto object-contain mx-auto mb-4 drop-shadow-lg" />
          <h1 className="text-3xl font-bold text-white mb-2 drop-shadow-md">
            SPMVV SOET Exam Results
          </h1>
          <p className="text-gray-200 drop-shadow">Sign in to view your results</p>
        </div>

        <div className="bg-white/90 backdrop-blur-sm rounded-lg shadow-2xl p-8">
          <div className="flex mb-6 bg-gray-100 rounded-lg p-1">
            <button
              type="button"
              onClick={() => { setUserType('student'); setErrors({}); }}
              className={studentBtnClass}
            >
              Student
            </button>
            <button
              type="button"
              onClick={() => { setUserType('admin'); setErrors({}); }}
              className={adminBtnClass}
            >
              Admin
            </button>
          </div>

          <form onSubmit={handleSubmit}>
            {errors.general && (
              <div className="mb-4 p-3 bg-red-100 text-red-700 rounded-lg text-sm">
                {errors.general}
              </div>
            )}

            {userType === 'student' ? (
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Hall Ticket Number
                </label>
                <input
                  type="text"
                  name="hallTicketNumber"
                  value={formData.hallTicketNumber}
                  onChange={handleChange}
                  className="input-field"
                  placeholder="Enter your hall ticket number"
                  disabled={loading}
                />
                {errors.hallTicketNumber && (
                  <p className="error-message">{errors.hallTicketNumber}</p>
                )}
              </div>
            ) : (
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Username
                </label>
                <input
                  type="text"
                  name="username"
                  value={formData.username}
                  onChange={handleChange}
                  className="input-field"
                  placeholder="Enter your username"
                  disabled={loading}
                />
                {errors.username && (
                  <p className="error-message">{errors.username}</p>
                )}
              </div>
            )}

            <div className="mb-6">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Password
              </label>
              <input
                type="password"
                name="password"
                value={formData.password}
                onChange={handleChange}
                className="input-field"
                placeholder="Enter your password"
                disabled={loading}
              />
              {errors.password && (
                <p className="error-message">{errors.password}</p>
              )}
            </div>

            <button
              type="submit"
              disabled={loading}
              className="btn-primary w-full"
            >
              {loading ? 'Signing in...' : 'Sign In'}
            </button>
          </form>

          <div className="mt-6 text-center" style={{ visibility: userType === 'student' ? 'visible' : 'hidden' }}>
            <p className="text-sm text-gray-600">
              Don't have an account?{' '}
              <Link
                to="/register"
                className="text-primary-600 hover:text-primary-700 font-medium"
              >
                Register here
              </Link>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Login;
