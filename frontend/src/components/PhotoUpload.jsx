import React, { useState, useEffect } from 'react';
import { FaCamera, FaUpload, FaCheckCircle, FaExclamationTriangle } from 'react-icons/fa';
import * as hallTicketService from '../services/hallTicketService';

const PhotoUpload = () => {
  const [photo, setPhoto] = useState(null);
  const [photoPreview, setPhotoPreview] = useState(null);
  const [existingPhoto, setExistingPhoto] = useState(null);
  const [consentGiven, setConsentGiven] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [message, setMessage] = useState({ text: '', type: '' });

  useEffect(() => {
    fetchExistingPhoto();
  }, []);

  const fetchExistingPhoto = async () => {
    try {
      const data = await hallTicketService.getStudentPhoto();
      setExistingPhoto(data);
      setPhotoPreview(data.photo_url);
      setConsentGiven(data.consent_given);
    } catch (error) {
      // No photo uploaded yet
      console.log('No existing photo');
    }
  };

  const handlePhotoChange = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    // Validate file type
    if (!file.type.startsWith('image/')) {
      showMessage('Please select an image file', 'error');
      return;
    }

    // Validate file size (max 2MB)
    if (file.size > 2 * 1024 * 1024) {
      showMessage('Photo size must be less than 2MB', 'error');
      return;
    }

    setPhoto(file);
    
    // Create preview
    const reader = new FileReader();
    reader.onloadend = () => {
      setPhotoPreview(reader.result);
    };
    reader.readAsDataURL(file);
  };

  const handleUpload = async () => {
    if (!photo && !existingPhoto) {
      showMessage('Please select a photo', 'error');
      return;
    }

    if (!consentGiven) {
      showMessage('Please provide consent to upload photo', 'error');
      return;
    }

    setUploading(true);
    try {
      const consentText = 'I hereby give consent to use my photograph for hall ticket generation and examination purposes.';
      const result = await hallTicketService.uploadStudentPhoto(photo, consentGiven, consentText);
      
      showMessage('Photo uploaded successfully!', 'success');
      setExistingPhoto(result.photo);
      setPhoto(null);
      
      // Refresh the photo
      setTimeout(() => {
        fetchExistingPhoto();
      }, 1000);
    } catch (error) {
      showMessage('Failed to upload photo. Please try again.', 'error');
      console.error('Upload error:', error);
    } finally {
      setUploading(false);
    }
  };

  const showMessage = (text, type) => {
    setMessage({ text, type });
    setTimeout(() => setMessage({ text: '', type: '' }), 5000);
  };

  return (
    <div className="bg-white rounded-lg shadow-lg p-6">
      <div className="flex items-center gap-3 mb-6">
        <FaCamera className="text-3xl text-blue-600" />
        <div>
          <h2 className="text-2xl font-bold text-gray-800">Upload Your Photo</h2>
          <p className="text-sm text-gray-600">Upload your photo for hall ticket generation</p>
        </div>
      </div>

      {/* Message Alert */}
      {message.text && (
        <div className={`mb-4 p-4 rounded-lg flex items-center gap-3 ${
          message.type === 'error' ? 'bg-red-50 text-red-800' : 'bg-green-50 text-green-800'
        }`}>
          {message.type === 'error' ? (
            <FaExclamationTriangle className="text-xl" />
          ) : (
            <FaCheckCircle className="text-xl" />
          )}
          <span>{message.text}</span>
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Photo Preview */}
        <div>
          <h3 className="text-lg font-semibold mb-3">Photo Preview</h3>
          <div className="border-2 border-dashed border-gray-300 rounded-lg p-4 flex items-center justify-center bg-gray-50">
            {photoPreview ? (
              <img
                src={photoPreview}
                alt="Preview"
                className="max-w-full max-h-64 rounded-lg shadow"
              />
            ) : (
              <div className="text-center text-gray-400 py-12">
                <FaCamera className="text-6xl mx-auto mb-3" />
                <p>No photo uploaded yet</p>
              </div>
            )}
          </div>

          {existingPhoto && (
            <div className="mt-3 p-3 bg-blue-50 rounded-lg text-sm">
              <p className="font-semibold text-blue-800">Current Photo Status:</p>
              <p className="text-blue-700">
                Uploaded on: {new Date(existingPhoto.uploaded_at).toLocaleDateString()}
              </p>
              <p className="text-blue-700">
                Consent: {existingPhoto.consent_given ? 'Given ✓' : 'Not Given'}
              </p>
            </div>
          )}
        </div>

        {/* Upload Form */}
        <div>
          <h3 className="text-lg font-semibold mb-3">
            {existingPhoto ? 'Update Photo' : 'Upload New Photo'}
          </h3>

          <div className="space-y-4">
            {/* File Input */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Select Photo *
              </label>
              <input
                type="file"
                accept="image/*"
                onChange={handlePhotoChange}
                className="w-full border border-gray-300 rounded-lg px-3 py-2"
              />
              <p className="text-xs text-gray-500 mt-1">
                Accepted formats: JPG, PNG (Max size: 2MB)
              </p>
            </div>

            {/* Photo Guidelines */}
            <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
              <h4 className="font-semibold text-yellow-800 mb-2">Photo Guidelines:</h4>
              <ul className="text-sm text-yellow-700 space-y-1">
                <li>• Passport size photo with clear face visibility</li>
                <li>• Plain background (white or light colored)</li>
                <li>• Face should be centered and clearly visible</li>
                <li>• No sunglasses or headwear (except religious)</li>
                <li>• Recent photograph (taken within last 6 months)</li>
              </ul>
            </div>

            {/* Consent Checkbox */}
            <div className="bg-gray-50 border border-gray-200 rounded-lg p-4">
              <label className="flex items-start gap-3 cursor-pointer">
                <input
                  type="checkbox"
                  checked={consentGiven}
                  onChange={(e) => setConsentGiven(e.target.checked)}
                  className="mt-1 w-4 h-4"
                />
                <span className="text-sm text-gray-700">
                  <strong className="font-semibold">I hereby give consent</strong> to use my photograph 
                  for hall ticket generation and examination purposes. I confirm that the photo uploaded 
                  is recent and meets the specified guidelines.
                </span>
              </label>
            </div>

            {/* Upload Button */}
            <button
              onClick={handleUpload}
              disabled={uploading || (!photo && !existingPhoto) || !consentGiven}
              className={`w-full py-3 rounded-lg font-semibold flex items-center justify-center gap-2 transition-colors ${
                uploading || (!photo && !existingPhoto) || !consentGiven
                  ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
                  : 'bg-blue-600 hover:bg-blue-700 text-white'
              }`}
            >
              {uploading ? (
                <>
                  <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></div>
                  <span>Uploading...</span>
                </>
              ) : (
                <>
                  <FaUpload />
                  <span>{existingPhoto ? 'Update Photo' : 'Upload Photo'}</span>
                </>
              )}
            </button>

            {existingPhoto && (
              <p className="text-xs text-center text-gray-500">
                Uploading a new photo will replace the existing one
              </p>
            )}
          </div>
        </div>
      </div>

      {/* Important Notes */}
      <div className="mt-6 bg-blue-50 border border-blue-200 rounded-lg p-4">
        <h4 className="font-semibold text-blue-800 mb-2">Important Notes:</h4>
        <ul className="text-sm text-blue-700 space-y-1">
          <li>• Photo upload is <strong>mandatory</strong> for hall ticket generation</li>
          <li>• You can re-upload your photo if needed before hall tickets are generated</li>
          <li>• Once hall tickets are generated, photo cannot be changed</li>
          <li>• Make sure your photo is clear and meets all guidelines</li>
          <li>• Your consent is required to proceed with the upload</li>
        </ul>
      </div>
    </div>
  );
};

export default PhotoUpload;
