import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import circularService from '../services/circularService';
import Navbar from '../components/Navbar';
import Toast from '../components/Toast';
import useEscapeKey from '../hooks/useEscapeKey';
import { FaPlus, FaEdit, FaTrash, FaFileAlt, FaFilePdf, FaFileImage, FaEye, FaEyeSlash, FaUsers, FaUserGraduate, FaUserTie } from 'react-icons/fa';

const AUDIENCE_OPTIONS = [
  { value: 'all',      label: 'All (Students + Staff)',  icon: FaUsers,          color: 'bg-blue-100 text-blue-800' },
  { value: 'students', label: 'Students Only',           icon: FaUserGraduate,   color: 'bg-green-100 text-green-800' },
  { value: 'staff',    label: 'Staff Only',              icon: FaUserTie,        color: 'bg-purple-100 text-purple-800' },
];

const CircularManagement = () => {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [circulars, setCirculars] = useState([]);
  const [loading, setLoading] = useState(false);
  const [showModal, setShowModal] = useState(false);
  const [editingCircular, setEditingCircular] = useState(null);
  const [toast, setToast] = useState({ show: false, message: '', type: '' });

  const [formData, setFormData] = useState({
    title: '',
    category: 'general',
    description: '',
    target_branch: '',
    target_audience: 'all',
    is_active: true,
    attachment: null,
  });

  const [filterCategory, setFilterCategory] = useState('all');
  const [filterAudience, setFilterAudience] = useState('all');
  const [downloading, setDownloading] = useState(null);
  const [filterActive, setFilterActive] = useState('all');

  const categories = [
    { value: 'general',   label: 'General' },
    { value: 'exam',      label: 'Exam' },
    { value: 'academic',  label: 'Academic' },
    { value: 'admission', label: 'Admission' },
    { value: 'event',     label: 'Event' },
    { value: 'urgent',    label: 'Urgent' },
  ];

  const branches = [
    'CSE', 'ECE', 'EEE', 'MECH', 'CIVIL', 'IT', 'EIE', 'CHEM', 'BT', 'FT'
  ];

  useEffect(() => {
    if (user?.role !== 'admin') {
      navigate('/');
      return;
    }
    fetchCirculars();
  }, [user, navigate]);

  const fetchCirculars = async () => {
    setLoading(true);
    try {
      const data = await circularService.getCirculars();
      setCirculars(data.circulars || []);
    } catch (error) {
      showToast('Failed to load circulars', 'error');
    } finally {
      setLoading(false);
    }
  };

  const showToast = (message, type) => {
    setToast({ show: true, message, type });
  };

  const handleOpenModal = (circular = null) => {
    if (circular) {
      setEditingCircular(circular);
      setFormData({
        title: circular.title,
        category: circular.category,
        description: circular.description,
        target_branch: circular.target_branch || '',
        target_audience: circular.target_audience || 'all',
        is_active: circular.is_active,
        attachment: null,
      });
    } else {
      setEditingCircular(null);
      setFormData({
        title: '',
        category: 'general',
        description: '',
        target_branch: '',
        target_audience: 'all',
        is_active: true,
        attachment: null,
      });
    }
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
    setEditingCircular(null);
  };

  useEscapeKey(handleCloseModal, showModal);

  const handleInputChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value
    }));
  };

  const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      const validTypes = ['application/pdf', 'image/jpeg', 'image/jpg', 'image/png'];
      const maxSize = 10 * 1024 * 1024;
      if (!validTypes.includes(file.type)) {
        showToast('Only PDF, JPG, JPEG, and PNG files are allowed', 'error');
        e.target.value = '';
        return;
      }
      if (file.size > maxSize) {
        showToast('File size must be less than 10MB', 'error');
        e.target.value = '';
        return;
      }
      setFormData(prev => ({ ...prev, attachment: file }));
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    try {
      const submitData = new FormData();
      submitData.append('title', formData.title);
      submitData.append('category', formData.category);
      submitData.append('description', formData.description);
      submitData.append('is_active', formData.is_active);
      submitData.append('target_audience', formData.target_audience);
      if (formData.target_branch) submitData.append('target_branch', formData.target_branch);
      if (formData.attachment) submitData.append('attachment', formData.attachment);
      if (editingCircular) {
        await circularService.updateCircular(editingCircular.id, submitData);
        showToast('Circular updated successfully', 'success');
      } else {
        await circularService.createCircular(submitData);
        showToast('Circular created successfully', 'success');
      }
      handleCloseModal();
      fetchCirculars();
    } catch (error) {
      showToast(error.response?.data?.error || 'Failed to save circular', 'error');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this circular?')) return;
    try {
      await circularService.deleteCircular(id);
      showToast('Circular deleted successfully', 'success');
      fetchCirculars();
    } catch (error) {
      showToast('Failed to delete circular', 'error');
    }
  };

  const getFileIcon = (fileUrl) => {
    if (!fileUrl) return <FaFileAlt />;
    if (fileUrl.endsWith('.pdf')) return <FaFilePdf className="text-red-500" />;
    if (fileUrl.match(/\.(jpg|jpeg|png)$/i)) return <FaFileImage className="text-blue-500" />;
    return <FaFileAlt />;
  };

  const handleDownloadAttachment = async (circular) => {
    if (!circular.attachment_name) return;
    setDownloading(circular.id);
    try {
      await circularService.downloadCircularAttachment(circular.id, circular.attachment_name);
    } catch (error) {
      console.error('Download failed:', error);
      showToast('Failed to download attachment', 'error');
    } finally {
      setDownloading(null);
    }
  };

  const getCategoryBadge = (category) => {
    const colors = {
      general:   'bg-gray-100 text-gray-800',
      exam:      'bg-blue-100 text-blue-800',
      academic:  'bg-green-100 text-green-800',
      admission: 'bg-yellow-100 text-yellow-800',
      event:     'bg-purple-100 text-purple-800',
      urgent:    'bg-red-100 text-red-800',
    };
    return colors[category] || colors.general;
  };

  const getAudienceBadge = (audience) => {
    return AUDIENCE_OPTIONS.find(a => a.value === audience) || AUDIENCE_OPTIONS[0];
  };

  const filteredCirculars = circulars.filter(circular => {
    if (filterCategory !== 'all' && circular.category !== filterCategory) return false;
    if (filterAudience !== 'all' && circular.target_audience !== filterAudience) return false;
    if (filterActive === 'active' && !circular.is_active) return false;
    if (filterActive === 'inactive' && circular.is_active) return false;
    return true;
  });

  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex justify-between items-center mb-6">
          <h1 className="text-3xl font-bold text-gray-900">Circular Management</h1>
          <button onClick={() => handleOpenModal()} className="bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-700 flex items-center gap-2">
            <FaPlus /> Create Circular
          </button>
        </div>

        {/* Filters */}
        <div className="bg-white p-4 rounded-lg shadow mb-6 flex flex-wrap gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Category</label>
            <select value={filterCategory} onChange={(e) => setFilterCategory(e.target.value)} className="border rounded-lg px-3 py-2">
              <option value="all">All Categories</option>
              {categories.map(cat => (<option key={cat.value} value={cat.value}>{cat.label}</option>))}
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Audience</label>
            <select value={filterAudience} onChange={(e) => setFilterAudience(e.target.value)} className="border rounded-lg px-3 py-2">
              <option value="all">All Audiences</option>
              {AUDIENCE_OPTIONS.map(a => (<option key={a.value} value={a.value}>{a.label}</option>))}
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Status</label>
            <select value={filterActive} onChange={(e) => setFilterActive(e.target.value)} className="border rounded-lg px-3 py-2">
              <option value="all">All</option>
              <option value="active">Active</option>
              <option value="inactive">Inactive</option>
            </select>
          </div>
        </div>

        {/* List */}
        {loading && !showModal ? (
          <div className="text-center py-8">Loading circulars...</div>
        ) : filteredCirculars.length === 0 ? (
          <div className="bg-white p-8 rounded-lg shadow text-center text-gray-500">No circulars found</div>
        ) : (
          <div className="grid gap-4">
            {filteredCirculars.map(circular => {
              const aud = getAudienceBadge(circular.target_audience || 'all');
              const AudIcon = aud.icon;
              return (
                <div key={circular.id} className="bg-white p-6 rounded-lg shadow hover:shadow-md transition">
                  <div className="flex justify-between items-start">
                    <div className="flex-1">
                      <div className="flex flex-wrap items-center gap-3 mb-2">
                        <h3 className="text-xl font-semibold text-gray-900">{circular.title}</h3>
                        {/* Category badge */}
                        <span className={`px-3 py-1 rounded-full text-xs font-medium ${getCategoryBadge(circular.category)}`}>
                          {circular.category.charAt(0).toUpperCase() + circular.category.slice(1)}
                        </span>
                        {/* Audience badge */}
                        <span className={`inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium ${aud.color}`}>
                          <AudIcon className="text-xs" /> {aud.label}
                        </span>
                        {/* Active/Inactive */}
                        {circular.is_active
                          ? <span className="flex items-center gap-1 text-green-600 text-sm"><FaEye /> Active</span>
                          : <span className="flex items-center gap-1 text-gray-400 text-sm"><FaEyeSlash /> Inactive</span>}
                      </div>
                      <p className="text-gray-600 mb-3">{circular.description}</p>
                      <div className="flex flex-wrap gap-4 text-sm text-gray-500">
                        <span>Created by: {circular.created_by_name}</span>
                        <span>Date: {circular.created_at_formatted || circular.created_at}</span>
                        {circular.target_branch && <span>Branch: {circular.target_branch}</span>}
                      </div>
                      {circular.file_url && (
                        <div className="mt-3">
                          <a href={circular.file_url} target="_blank" rel="noopener noreferrer"
                            className="inline-flex items-center gap-2 text-indigo-600 hover:text-indigo-800">
                            {getFileIcon(circular.file_url)}
                            <span>View Attachment ({circular.file_extension})</span>
                          </a>
                        </div>
                      )}
                    </div>
                    <div className="flex gap-2 ml-4">
                      <button onClick={() => handleOpenModal(circular)} className="text-blue-600 hover:text-blue-800 p-2" title="Edit"><FaEdit size={20} /></button>
                      <button onClick={() => handleDelete(circular.id)} className="text-red-600 hover:text-red-800 p-2" title="Delete"><FaTrash size={20} /></button>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="p-6">
              <h2 className="text-2xl font-bold mb-4">{editingCircular ? 'Edit Circular' : 'Create New Circular'}</h2>
              <form onSubmit={handleSubmit}>
                <div className="space-y-4">

                  {/* Title */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Title <span className="text-red-500">*</span></label>
                    <input type="text" name="title" value={formData.title} onChange={handleInputChange}
                      required maxLength={300} className="w-full border rounded-lg px-3 py-2" />
                  </div>

                  {/* Category */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Category <span className="text-red-500">*</span></label>
                    <select name="category" value={formData.category} onChange={handleInputChange}
                      required className="w-full border rounded-lg px-3 py-2">
                      {categories.map(cat => (<option key={cat.value} value={cat.value}>{cat.label}</option>))}
                    </select>
                  </div>

                  {/* Audience */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">
                      Target Audience <span className="text-red-500">*</span>
                    </label>
                    <div className="grid grid-cols-3 gap-3 mt-1">
                      {AUDIENCE_OPTIONS.map(opt => {
                        const Icon = opt.icon;
                        const selected = formData.target_audience === opt.value;
                        return (
                          <button
                            key={opt.value}
                            type="button"
                            onClick={() => setFormData(prev => ({ ...prev, target_audience: opt.value }))}
                            className={`flex flex-col items-center justify-center gap-2 p-3 rounded-lg border-2 transition-all text-sm font-medium
                              ${selected
                                ? 'border-indigo-500 bg-indigo-50 text-indigo-700'
                                : 'border-gray-200 bg-white text-gray-600 hover:border-indigo-300 hover:bg-indigo-50'}`}
                          >
                            <Icon className={`text-xl ${selected ? 'text-indigo-600' : 'text-gray-400'}`} />
                            {opt.label}
                          </button>
                        );
                      })}
                    </div>
                    <p className="text-xs text-gray-400 mt-1">
                      "Staff Only" circulars will not appear on the student dashboard.
                    </p>
                  </div>

                  {/* Description */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Description <span className="text-red-500">*</span></label>
                    <textarea name="description" value={formData.description} onChange={handleInputChange}
                      required rows={4} className="w-full border rounded-lg px-3 py-2" />
                  </div>

                  {/* Target Branch */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Target Branch (Optional)</label>
                    <input type="text" name="target_branch" value={formData.target_branch} onChange={handleInputChange}
                      placeholder="Enter branch code (e.g., CSE, ECE) — leave blank for all branches"
                      className="w-full border rounded-lg px-3 py-2" maxLength={20} />
                  </div>

                  {/* Attachment */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">
                      Attachment {!editingCircular && <span className="text-red-500">*</span>}
                      <span className="text-gray-500 text-xs ml-2">(PDF, JPG, JPEG, PNG — Max 10MB)</span>
                    </label>
                    <input type="file" onChange={handleFileChange} accept=".pdf,.jpg,.jpeg,.png"
                      required={!editingCircular} className="w-full border rounded-lg px-3 py-2" />
                    {editingCircular && editingCircular.file_url && (
                      <p className="text-sm text-gray-500 mt-1">
                        Current: {editingCircular.attachment_name} (leave empty to keep current)
                      </p>
                    )}
                  </div>

                  {/* Active */}
                  <div className="flex items-center">
                    <input type="checkbox" name="is_active" checked={formData.is_active}
                      onChange={handleInputChange} className="mr-2" id="is_active" />
                    <label htmlFor="is_active" className="text-sm font-medium text-gray-700">
                      Active (visible to the selected audience)
                    </label>
                  </div>
                </div>

                <div className="flex gap-3 mt-6">
                  <button type="submit" disabled={loading}
                    className="flex-1 bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-700 disabled:opacity-50">
                    {loading ? 'Saving...' : (editingCircular ? 'Update' : 'Create')}
                  </button>
                  <button type="button" onClick={handleCloseModal} disabled={loading}
                    className="flex-1 bg-gray-200 text-gray-800 px-4 py-2 rounded-lg hover:bg-gray-300 disabled:opacity-50">
                    Cancel
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      )}

      {toast.show && (
        <Toast message={toast.message} type={toast.type} onClose={() => setToast({ show: false, message: '', type: '' })} />
      )}
    </div>
  );
};

export default CircularManagement;
