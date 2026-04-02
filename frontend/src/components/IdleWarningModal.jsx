import React, { useEffect, useState } from 'react';
import { FaClock, FaExclamationTriangle } from 'react-icons/fa';

const IdleWarningModal = ({ isOpen, remainingSeconds, onStayActive, onLogout }) => {
  const [countdown, setCountdown] = useState(remainingSeconds);

  useEffect(() => {
    setCountdown(remainingSeconds);
  }, [remainingSeconds]);

  if (!isOpen) return null;

  const minutes = Math.floor(countdown / 60);
  const seconds = countdown % 60;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg shadow-2xl max-w-md w-full mx-4 p-6 animate-fade-in">
        <div className="flex items-center justify-center mb-4">
          <div className="bg-yellow-100 rounded-full p-4">
            <FaExclamationTriangle className="text-yellow-600 text-4xl" />
          </div>
        </div>

        <h2 className="text-2xl font-bold text-center text-gray-900 mb-2">
          Session Timeout Warning
        </h2>

        <p className="text-gray-600 text-center mb-6">
          You have been inactive for a while. For your security, you will be automatically logged out.
        </p>

        <div className="bg-yellow-50 border-l-4 border-yellow-400 p-4 mb-6">
          <div className="flex items-center">
            <FaClock className="text-yellow-600 text-2xl mr-3" />
            <div>
              <p className="text-sm font-medium text-yellow-800">Time Remaining</p>
              <p className="text-3xl font-bold text-yellow-900">
                {minutes}:{seconds.toString().padStart(2, '0')}
              </p>
            </div>
          </div>
        </div>

        <div className="flex space-x-3">
          <button
            onClick={onStayActive}
            className="flex-1 bg-primary-600 hover:bg-primary-700 text-white font-semibold py-3 px-4 rounded-lg transition-colors duration-200"
          >
            Stay Logged In
          </button>
          <button
            onClick={onLogout}
            className="flex-1 bg-gray-200 hover:bg-gray-300 text-gray-700 font-semibold py-3 px-4 rounded-lg transition-colors duration-200"
          >
            Logout Now
          </button>
        </div>

        <p className="text-xs text-gray-500 text-center mt-4">
          Click anywhere or move your mouse to stay active
        </p>
      </div>
    </div>
  );
};

export default IdleWarningModal;
