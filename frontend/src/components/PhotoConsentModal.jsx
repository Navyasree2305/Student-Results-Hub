import React, { useState } from 'react';
import { FaTimes, FaCamera, FaCheckCircle } from 'react-icons/fa';
import useEscapeKey from '../hooks/useEscapeKey';

const PhotoConsentModal = ({ isOpen, onClose, onConfirm, selectedFile }) => {
  const [consentChecked, setConsentChecked] = useState(false);

  // ESC key handler
  useEscapeKey(handleClose, isOpen);

  if (!isOpen) return null;

  const handleConfirm = () => {
    if (consentChecked) {
      onConfirm();
    }
  };

  function handleClose() {
    setConsentChecked(false);
    onClose();
  }

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-lg shadow-xl max-w-md w-full">
        {/* Header */}
        <div className="bg-gradient-to-r from-blue-600 to-blue-700 text-white px-6 py-4 flex justify-between items-center rounded-t-lg">
          <h2 className="text-xl font-semibold flex items-center gap-2">
            <FaCamera />
            Photo Upload Consent
          </h2>
          <button
            onClick={handleClose}
            className="text-white hover:text-gray-200 transition-colors"
          >
            <FaTimes size={20} />
          </button>
        </div>

        {/* Body */}
        <div className="p-6">
          {/* Selected File Info */}
          {selectedFile && (
            <div className="mb-4 p-3 bg-blue-50 border border-blue-200 rounded-lg">
              <p className="text-sm text-gray-700">
                <strong>Selected file:</strong> {selectedFile.name}
              </p>
              <p className="text-xs text-gray-600 mt-1">
                Size: {(selectedFile.size / 1024).toFixed(2)} KB
              </p>
            </div>
          )}

          {/* Consent Information */}
          <div className="mb-6">
            <h3 className="font-semibold text-gray-900 mb-3">
              Photo Usage Consent
            </h3>
            <div className="bg-yellow-50 border-l-4 border-yellow-400 p-4 mb-4">
              <p className="text-sm text-gray-700 leading-relaxed">
                Your photograph will be used for the following purposes:
              </p>
              <ul className="list-disc list-inside text-sm text-gray-700 mt-2 space-y-1">
                <li>Hall ticket generation for examinations</li>
                <li>Student identification purposes</li>
                <li>Official university records</li>
              </ul>
            </div>

            {/* Consent Checkbox */}
            <label className="flex items-start gap-3 cursor-pointer group">
              <input
                type="checkbox"
                checked={consentChecked}
                onChange={(e) => setConsentChecked(e.target.checked)}
                className="mt-1 w-5 h-5 text-blue-600 border-gray-300 rounded focus:ring-2 focus:ring-blue-500"
              />
              <span className="text-sm text-gray-700 leading-relaxed group-hover:text-gray-900">
                <strong>I hereby give my consent</strong> to use my photograph for 
                hall ticket generation, examination identification, and official university 
                records. I understand that this photo will be visible on my hall ticket 
                and may be used for verification purposes.
              </span>
            </label>
          </div>

          {/* Action Buttons */}
          <div className="flex gap-3">
            <button
              onClick={handleConfirm}
              disabled={!consentChecked}
              className="flex-1 bg-blue-600 text-white px-4 py-2.5 rounded-lg hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors flex items-center justify-center gap-2 font-medium"
            >
              <FaCheckCircle />
              {consentChecked ? 'Confirm & Upload' : 'Please Accept Consent'}
            </button>
            <button
              onClick={handleClose}
              className="px-6 py-2.5 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors font-medium"
            >
              Cancel
            </button>
          </div>

          <p className="text-xs text-gray-500 mt-4 text-center">
            You must accept the consent to proceed with photo upload
          </p>
        </div>
      </div>
    </div>
  );
};

export default PhotoConsentModal;
