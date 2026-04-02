import React, { useState, useEffect, useRef } from "react";
import { FaTimes, FaUser, FaEnvelope, FaSave, FaCamera } from "react-icons/fa";
import { profileService } from "../services/profileService";
import useEscapeKey from "../hooks/useEscapeKey";

const ProfileEditModal = ({ isOpen, onClose, onUpdate }) => {
  const [formData, setFormData] = useState({ first_name: "", last_name: "", email: "" });
  const [loading, setLoading] = useState(false);
  const [photoLoading, setPhotoLoading] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");
  const [photoSuccess, setPhotoSuccess] = useState("");
  const [profilePhotoUrl, setProfilePhotoUrl] = useState(null);
  const [previewUrl, setPreviewUrl] = useState(null);
  const fileInputRef = useRef(null);

  useEscapeKey(onClose, isOpen);

  useEffect(() => {
    if (isOpen) {
      setError(""); setSuccess(""); setPhotoSuccess("");
      loadProfile();
    }
  }, [isOpen]);

  const buildAbsoluteUrl = (url) => {
    if (!url) return null;
    if (url.startsWith("http")) return url;
    const base = (import.meta.env.VITE_API_URL || "http://localhost:8000").replace(/\/api\/?$/, "");
    return base + url;
  };

  const loadProfile = async () => {
    try {
      const data = await profileService.getProfile();
      setFormData({
        first_name: data.first_name || "",
        last_name: data.last_name || "",
        email: data.email || "",
      });
      setProfilePhotoUrl(data.profile_photo_url ? buildAbsoluteUrl(data.profile_photo_url) : null);
      setPreviewUrl(null);
    } catch (err) {
      setError("Failed to load profile");
    }
  };

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
    setError(""); setSuccess("");
  };

  const handlePhotoChange = (e) => {
    const file = e.target.files[0];
    if (!file) return;
    if (!file.type.startsWith("image/")) { setError("Please select a valid image file."); return; }
    if (file.size > 5 * 1024 * 1024) { setError("Photo must be smaller than 5MB."); return; }
    setPreviewUrl(URL.createObjectURL(file));
    handleUploadPhoto(file);
  };

  const handleUploadPhoto = async (file) => {
    setPhotoLoading(true); setError(""); setPhotoSuccess("");
    try {
      await profileService.uploadPhoto(file, true);
      const updated = await profileService.getProfile();
      const serverUrl = updated.profile_photo_url
        ? buildAbsoluteUrl(updated.profile_photo_url)
        : previewUrl;
      setProfilePhotoUrl(serverUrl);
      setPreviewUrl(null);
      setPhotoSuccess("Photo updated successfully!");
      if (onUpdate) onUpdate({ photoUrl: serverUrl });
    } catch (err) {
      setError(err.response?.data?.error || "Failed to upload photo");
      setPreviewUrl(null);
    } finally {
      setPhotoLoading(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(""); setSuccess("");
    if (!formData.first_name.trim()) { setError("First name is required"); return; }
    if (formData.email && !formData.email.includes("@")) { setError("Please enter a valid email address"); return; }
    setLoading(true);
    try {
      await profileService.updateProfile(formData);
      setSuccess("Profile updated successfully!");
      if (onUpdate) onUpdate({
        first_name: formData.first_name,
        last_name: formData.last_name,
        email: formData.email,
        photoUrl: profilePhotoUrl,
      });
      setTimeout(() => onClose(), 1500);
    } catch (err) {
      setError(err.response?.data?.error || "Failed to update profile");
    } finally {
      setLoading(false);
    }
  };

  if (!isOpen) return null;

  const displayPhoto = previewUrl || profilePhotoUrl;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-lg shadow-xl max-w-md w-full flex flex-col" style={{maxHeight: "90vh"}}>
        <div className="bg-gradient-to-r from-blue-600 to-blue-700 text-white px-6 py-4 flex justify-between items-center rounded-t-lg flex-shrink-0">
          <h2 className="text-xl font-semibold flex items-center gap-2"><FaUser />Edit Profile</h2>
          <button onClick={onClose} className="text-white hover:text-gray-200 transition-colors" type="button">
            <FaTimes size={20} />
          </button>
        </div>

        <div className="overflow-y-auto flex-1 p-6">
          <div className="flex flex-col items-center mb-6">
            <div className="relative">
              {displayPhoto ? (
                <img src={displayPhoto} alt="Profile"
                  className="w-24 h-24 rounded-full object-cover border-4 border-blue-100 shadow" />
              ) : (
                <div className="w-24 h-24 rounded-full bg-gray-200 flex items-center justify-center border-4 border-blue-100 shadow">
                  <FaUser className="text-gray-400 text-4xl" />
                </div>
              )}
              <button type="button" onClick={() => fileInputRef.current?.click()} disabled={photoLoading}
                className="absolute bottom-0 right-0 bg-blue-600 text-white rounded-full p-2 shadow hover:bg-blue-700 transition-colors disabled:opacity-50"
                title="Change photo">
                {photoLoading
                  ? <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white" />
                  : <FaCamera size={14} />}
              </button>
            </div>
            <input ref={fileInputRef} type="file" accept="image/*" className="hidden" onChange={handlePhotoChange} />
            <p className="text-xs text-gray-500 mt-2">Click the camera icon to upload your photo</p>
            {photoSuccess && <p className="text-xs text-green-600 mt-1 font-medium">{photoSuccess}</p>}
          </div>

          {error && <div className="mb-4 p-3 bg-red-50 border border-red-200 text-red-700 rounded-lg text-sm">{error}</div>}
          {success && <div className="mb-4 p-3 bg-green-50 border border-green-200 text-green-700 rounded-lg text-sm">{success}</div>}

          <form onSubmit={handleSubmit}>
            <div className="mb-4">
              <label className="block text-sm font-medium text-gray-700 mb-2">First Name <span className="text-red-500">*</span></label>
              <input type="text" name="first_name" value={formData.first_name} onChange={handleChange}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                placeholder="Enter first name" required />
            </div>
            <div className="mb-4">
              <label className="block text-sm font-medium text-gray-700 mb-2">Last Name</label>
              <input type="text" name="last_name" value={formData.last_name} onChange={handleChange}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                placeholder="Enter last name" />
            </div>
            <div className="mb-6">
              <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2"><FaEnvelope size={14} />Email Address</label>
              <input type="email" name="email" value={formData.email} onChange={handleChange}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                placeholder="Enter your email" />
              <p className="text-xs text-gray-500 mt-1">Optional - for receiving notifications</p>
            </div>
            <div className="flex gap-3">
              <button type="submit" disabled={loading}
                className="flex-1 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors flex items-center justify-center gap-2">
                {loading ? <><div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white" />Saving...</> : <><FaSave />Save Changes</>}
              </button>
              <button type="button" onClick={onClose} disabled={loading}
                className="px-6 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 disabled:opacity-50 transition-colors">
                Cancel
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default ProfileEditModal;
