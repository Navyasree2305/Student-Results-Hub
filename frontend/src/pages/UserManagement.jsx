import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { FaUsers, FaEdit, FaTrash, FaKey, FaPlus, FaTimes, FaSearch, FaCheckSquare, FaSquare } from 'react-icons/fa';
import { useAuth } from '../context/AuthContext';
import api from '../services/api';
import Navbar from '../components/Navbar';
import Toast from '../components/Toast';
import useEscapeKey from '../hooks/useEscapeKey';

const EMPTY_FORM = {
  username: '',
  password: '',
  email: '',
  first_name: '',
  last_name: '',
  role: 'student',
  branch: '',
  department: '',
  // Results
  results_upload: false,
  results_edit: false,
  results_delete: false,
  results_download: false,
  // Students
  students_view: false,
  students_detained_report: false,
  // Circulars
  circulars_view: false,
  circulars_create: false,
  circulars_edit: false,
  circulars_delete: false,
  // Timetable
  timetable_view: false,
  timetable_create: false,
  // Hall Tickets
  halltickets_view: false,
  halltickets_create: false,
  halltickets_generate: false,
  halltickets_download: false,
  // Statistics
  statistics_view: false,
  // Audit Logs
  auditlogs_view: false,
  // User Management
  users_view: false,
  users_create: false,
  users_edit: false,
  users_delete: false,
  // Branch Access
  access_all_branches: false,
  is_active_user: true,
};

const PERM_GROUPS = [
  {
    label: 'Results',
    color: 'green',
    perms: [
      { key: 'results_upload',   label: 'Upload',   desc: 'Upload exam result Excel files' },
      { key: 'results_edit',     label: 'Edit',     desc: 'Edit individual subject marks' },
      { key: 'results_delete',   label: 'Delete',   desc: 'Delete uploaded exam results' },
      { key: 'results_download', label: 'Download', desc: 'Download result Excel files' },
    ],
  },
  {
    label: 'Students',
    color: 'blue',
    perms: [
      { key: 'students_view',            label: 'View',           desc: 'Search students and view academic history' },
      { key: 'students_detained_report', label: 'Detained Report',desc: 'View detained students report' },
    ],
  },
  {
    label: 'Circulars',
    color: 'yellow',
    perms: [
      { key: 'circulars_view',   label: 'View',   desc: 'View circulars' },
      { key: 'circulars_create', label: 'Create', desc: 'Create new circulars' },
      { key: 'circulars_edit',   label: 'Edit',   desc: 'Edit existing circulars' },
      { key: 'circulars_delete', label: 'Delete', desc: 'Delete circulars' },
    ],
  },
  {
    label: 'Timetable',
    color: 'teal',
    perms: [
      { key: 'timetable_view',   label: 'View',   desc: 'View and download timetables' },
      { key: 'timetable_create', label: 'Create', desc: 'Generate and manage timetables' },
    ],
  },
  {
    label: 'Hall Tickets',
    color: 'purple',
    perms: [
      { key: 'halltickets_view',     label: 'View',     desc: 'View hall ticket exams and enrollments' },
      { key: 'halltickets_create',   label: 'Create',   desc: 'Create/manage hall ticket exams and upload student lists' },
      { key: 'halltickets_generate', label: 'Generate', desc: 'Generate hall tickets' },
      { key: 'halltickets_download', label: 'Download', desc: 'Download hall ticket PDFs' },
    ],
  },
  {
    label: 'Statistics',
    color: 'indigo',
    perms: [
      { key: 'statistics_view', label: 'View', desc: 'View statistics and reports dashboard' },
    ],
  },
  {
    label: 'Audit Logs',
    color: 'orange',
    perms: [
      { key: 'auditlogs_view', label: 'View', desc: 'View security and activity audit logs' },
    ],
  },
  {
    label: 'User Management',
    color: 'red',
    perms: [
      { key: 'users_view',   label: 'View',   desc: 'View the user list' },
      { key: 'users_create', label: 'Create', desc: 'Create new users' },
      { key: 'users_edit',   label: 'Edit',   desc: 'Edit users and assign permissions' },
      { key: 'users_delete', label: 'Delete', desc: 'Delete users' },
    ],
  },
  {
    label: 'Branch Access',
    color: 'gray',
    perms: [
      { key: 'access_all_branches', label: 'All Branches', desc: 'View data for all branches (overrides branch restriction)' },
    ],
  },
];

// Flat list of all perm keys for mapping
const ALL_PERM_KEYS = PERM_GROUPS.flatMap(g => g.perms.map(p => p.key));

// Badge colour lookup for table column
const BADGE_COLORS = {
  green:  'bg-green-100 text-green-800',
  blue:   'bg-blue-100 text-blue-800',
  yellow: 'bg-yellow-100 text-yellow-800',
  teal:   'bg-teal-100 text-teal-800',
  purple: 'bg-purple-100 text-purple-800',
  indigo: 'bg-indigo-100 text-indigo-800',
  orange: 'bg-orange-100 text-orange-800',
  red:    'bg-red-100 text-red-800',
  gray:   'bg-gray-100 text-gray-800',
};

const PERM_BADGE = {};
PERM_GROUPS.forEach(g => {
  g.perms.forEach(p => {
    PERM_BADGE[p.key] = { label: `${g.label}: ${p.label}`, color: BADGE_COLORS[g.color] };
  });
});

const UserManagement = () => {
  const { user: currentUser } = useAuth();
  const navigate = useNavigate();
  const [users, setUsers] = useState([]);
  const [filteredUsers, setFilteredUsers] = useState([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedUsers, setSelectedUsers] = useState([]);
  const [showBulkDeleteConfirm, setShowBulkDeleteConfirm] = useState(false);
  const [loading, setLoading] = useState(true);
  const [showUserModal, setShowUserModal] = useState(false);
  const [showPasswordModal, setShowPasswordModal] = useState(false);
  const [modalMode, setModalMode] = useState('create');
  const [selectedUser, setSelectedUser] = useState(null);
  const [toast, setToast] = useState(null);
  const [formData, setFormData] = useState(EMPTY_FORM);
  const [passwordData, setPasswordData] = useState({ new_password: '', confirm_password: '' });

  const roleOptions = [
    { value: 'faculty',        label: 'Faculty' },
    { value: 'staff',          label: 'Staff' },
    { value: 'hod',            label: 'Head of Department (HOD)' },
    { value: 'dean',           label: 'Dean' },
    { value: 'vice_principal', label: 'Vice Principal' },
    { value: 'principal',      label: 'Principal' },
    { value: 'admin',          label: 'Admin' },
  ];

  useEscapeKey(() => setShowUserModal(false), showUserModal);
  useEscapeKey(() => setShowPasswordModal(false), showPasswordModal);
  useEscapeKey(() => setShowBulkDeleteConfirm(false), showBulkDeleteConfirm);

  useEffect(() => { fetchUsers(); }, []);

  const fetchUsers = async () => {
    try {
      setLoading(true);
      const response = await api.get('/users/');
      setUsers(response.data.users || response.data);
    } catch (error) {
      showToast('Failed to fetch users', 'error');
    } finally {
      setLoading(false);
    }
  };

  const showToast = (message, type = 'success') => setToast({ message, type });

  useEffect(() => {
    if (searchTerm.trim() === '') {
      setFilteredUsers(users);
    } else {
      const q = searchTerm.toLowerCase();
      setFilteredUsers(users.filter(u =>
        u.username.toLowerCase().includes(q) ||
        u.email?.toLowerCase().includes(q) ||
        u.first_name?.toLowerCase().includes(q) ||
        u.last_name?.toLowerCase().includes(q) ||
        u.role.toLowerCase().includes(q) ||
        u.branch?.toLowerCase().includes(q)
      ));
    }
  }, [searchTerm, users]);

  const canSelectUser = (u) =>
    u.username !== currentUser.username && !(u.username === 'admin' && u.role === 'admin');

  const handleSelectAll = () => {
    const selectable = filteredUsers.filter(canSelectUser);
    setSelectedUsers(
      selectedUsers.length === selectable.length ? [] : selectable.map(u => u.id)
    );
  };

  const handleSelectUser = (id) =>
    setSelectedUsers(prev => prev.includes(id) ? prev.filter(x => x !== id) : [...prev, id]);

  const handleBulkDelete = async () => {
    const toDelete = users.filter(u => selectedUsers.includes(u.id) && canSelectUser(u));
    if (!toDelete.length) { showToast('No users selected for deletion', 'error'); setShowBulkDeleteConfirm(false); return; }
    const results = await Promise.allSettled(toDelete.map(u => api.delete(`/users/${u.id}/delete/`)));
    const ok = results.filter(r => r.status === 'fulfilled').length;
    const fail = results.filter(r => r.status === 'rejected').length;
    showToast(fail ? `Deleted ${ok}, ${fail} failed` : `${ok} user(s) deleted`, fail ? 'warning' : 'success');
    setSelectedUsers([]);
    setShowBulkDeleteConfirm(false);
    fetchUsers();
  };

  const buildFormFromUser = (u) => ({
    username:              u.username,
    password:              '',
    email:                 u.email || '',
    first_name:            u.first_name || '',
    last_name:             u.last_name || '',
    role:                  u.role,
    branch:                u.branch || '',
    department:            u.department || '',
    ...Object.fromEntries(ALL_PERM_KEYS.map(k => [k, u[k] || false])),
    is_active_user: u.is_active_user !== undefined ? u.is_active_user : true,
  });

  const handleCreateUser = () => {
    setModalMode('create');
    setFormData(EMPTY_FORM);
    setShowUserModal(true);
  };

  const handleEditUser = (u) => {
    setModalMode('edit');
    setSelectedUser(u);
    setFormData(buildFormFromUser(u));
    setShowUserModal(true);
  };

  const handleResetPassword = (u) => {
    setSelectedUser(u);
    setPasswordData({ new_password: '', confirm_password: '' });
    setShowPasswordModal(true);
  };

  const handleDeleteUser = async (u) => {
    if (u.username === currentUser.username) { showToast('You cannot delete your own account', 'error'); return; }
    if (!window.confirm(`Delete user "${u.username}"?`)) return;
    try {
      await api.delete(`/users/${u.id}/delete/`);
      showToast('User deleted successfully');
      fetchUsers();
    } catch { showToast('Failed to delete user', 'error'); }
  };

  const handleSubmitUser = async (e) => {
    e.preventDefault();
    if (!formData.username || !formData.role) { showToast('Username and role are required', 'error'); return; }
    if (modalMode === 'create' && !formData.password) { showToast('Password is required for new users', 'error'); return; }
    try {
      if (modalMode === 'create') {
        await api.post('/users/create/', formData);
        showToast('User created successfully');
      } else {
        await api.put(`/users/${selectedUser.id}/update/`, formData);
        showToast('User updated successfully');
      }
      setShowUserModal(false);
      fetchUsers();
    } catch (error) {
      showToast(error.response?.data?.error || 'Failed to save user', 'error');
    }
  };

  const handleSubmitPassword = async (e) => {
    e.preventDefault();
    if (!passwordData.new_password) { showToast('Password is required', 'error'); return; }
    if (passwordData.new_password !== passwordData.confirm_password) { showToast('Passwords do not match', 'error'); return; }
    try {
      await api.post(`/users/${selectedUser.id}/reset-password/`, { new_password: passwordData.new_password });
      showToast('Password reset successfully');
      setShowPasswordModal(false);
    } catch { showToast('Failed to reset password', 'error'); }
  };

  const getRoleBadgeClass = (role) => ({
    admin:          'bg-red-500',
    dean:           'bg-purple-600',
    vice_principal: 'bg-purple-500',
    principal:      'bg-indigo-500',
    hod:            'bg-blue-500',
    faculty:        'bg-green-500',
    staff:          'bg-teal-500',
    student:        'bg-gray-500',
  }[role] || 'bg-gray-500');

  const getRoleLabel = (role) => ({
    admin: 'Admin', dean: 'Dean', vice_principal: 'Vice Principal',
    principal: 'Principal', hod: 'HOD', faculty: 'Faculty', staff: 'Staff', student: 'Student',
  }[role] || role);

  const handleFormChange = (field, value) =>
    setFormData(prev => ({ ...prev, [field]: value }));

  // Active permissions for display in table
  const activePerms = (u) => ALL_PERM_KEYS.filter(k => u[k]);

  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">User Management</h1>
          <p className="text-gray-600 mt-2">Manage user accounts and permissions</p>
        </div>

        <div className="bg-white rounded-lg shadow-md p-6 mb-6">
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-xl font-bold text-gray-900">Users</h2>
            <button onClick={handleCreateUser}
              className="flex items-center space-x-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors">
              <FaPlus /><span>Create User</span>
            </button>
          </div>

          <div className="mb-6 flex flex-col md:flex-row gap-4 items-start md:items-center justify-between">
            <div className="flex-1 max-w-md">
              <div className="relative">
                <FaSearch className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                <input type="text" placeholder="Search by username, email, role, or branch..."
                  value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)}
                  className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" />
              </div>
            </div>
            {selectedUsers.length > 0 && (
              <div className="flex items-center space-x-3">
                <span className="text-sm text-gray-600">{selectedUsers.length} user(s) selected</span>
                <button onClick={() => setShowBulkDeleteConfirm(true)}
                  className="flex items-center space-x-2 bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition-colors">
                  <FaTrash /><span>Delete Selected</span>
                </button>
              </div>
            )}
          </div>

          {loading ? (
            <div className="text-center py-12">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
              <p className="mt-4 text-gray-600">Loading users...</p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-4 py-3 text-left">
                      <button onClick={handleSelectAll} className="text-gray-600 hover:text-blue-600"
                        title={selectedUsers.length === filteredUsers.filter(canSelectUser).length ? 'Deselect All' : 'Select All'}>
                        {selectedUsers.length > 0 && selectedUsers.length === filteredUsers.filter(canSelectUser).length
                          ? <FaCheckSquare className="text-blue-600" /> : <FaSquare />}
                      </button>
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">User</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Branch/Dept</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Permissions</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {filteredUsers.map((u) => (
                    <tr key={u.id} className={`hover:bg-gray-50 ${selectedUsers.includes(u.id) ? 'bg-blue-50' : ''}`}>
                      <td className="px-4 py-4">
                        <button onClick={() => canSelectUser(u) && handleSelectUser(u.id)}
                          className="text-gray-600 hover:text-blue-600"
                          disabled={!canSelectUser(u)} title={!canSelectUser(u) ? 'Cannot select this user' : ''}>
                          {selectedUsers.includes(u.id) ? <FaCheckSquare className="text-blue-600" /> : <FaSquare />}
                        </button>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="text-sm font-medium text-gray-900">{u.username}</div>
                        <div className="text-sm text-gray-500">{u.first_name} {u.last_name}</div>
                        {u.email && <div className="text-xs text-gray-400">{u.email}</div>}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full ${getRoleBadgeClass(u.role)} text-white`}>
                          {getRoleLabel(u.role)}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {u.branch && <div>Branch: {u.branch}</div>}
                        {u.department && <div className="text-xs text-gray-500">{u.department}</div>}
                        {!u.branch && !u.department && <span className="text-gray-400">N/A</span>}
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex flex-wrap gap-1">
                          {u.role === 'admin' ? (
                            <span className="text-xs px-2 py-0.5 rounded bg-purple-100 text-purple-800 font-semibold">All Access</span>
                          ) : activePerms(u).length === 0 ? (
                            <span className="text-xs text-gray-400">None</span>
                          ) : (
                            activePerms(u).map(k => (
                              <span key={k} className={`text-xs px-2 py-0.5 rounded ${PERM_BADGE[k]?.color || 'bg-gray-100 text-gray-800'}`}>
                                {PERM_BADGE[k]?.label || k}
                              </span>
                            ))
                          )}
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full ${u.is_active_user ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>
                          {u.is_active_user ? 'Active' : 'Inactive'}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <div className="flex space-x-2">
                          <button onClick={() => handleEditUser(u)} className="text-blue-600 hover:text-blue-900" title="Edit User"><FaEdit /></button>
                          <button onClick={() => handleResetPassword(u)} className="text-orange-600 hover:text-orange-900" title="Reset Password"><FaKey /></button>
                          <button onClick={() => handleDeleteUser(u)}
                            className={`text-red-600 hover:text-red-900 ${u.username === currentUser.username ? 'opacity-50 cursor-not-allowed' : ''}`}
                            title="Delete User" disabled={u.username === currentUser.username}><FaTrash /></button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
              {filteredUsers.length === 0 && (
                <div className="text-center py-12"><p className="text-gray-500">No users found</p></div>
              )}
            </div>
          )}
        </div>
      </div>

      {/* ── Create / Edit User Modal ── */}
      {showUserModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-3xl w-full max-h-[90vh] overflow-y-auto">
            <div className="flex justify-between items-center p-6 border-b">
              <h2 className="text-2xl font-bold text-gray-800">
                {modalMode === 'create' ? 'Create New User' : 'Edit User'}
              </h2>
              <button onClick={() => setShowUserModal(false)} className="text-gray-500 hover:text-gray-700">
                <FaTimes size={24} />
              </button>
            </div>

            <form onSubmit={handleSubmitUser} className="p-6">
              {/* Basic info */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Username *</label>
                  <input type="text" value={formData.username}
                    onChange={(e) => handleFormChange('username', e.target.value)}
                    disabled={modalMode === 'edit'}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 disabled:bg-gray-100" required />
                </div>
                {modalMode === 'create' && (
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Password *</label>
                    <input type="password" value={formData.password}
                      onChange={(e) => handleFormChange('password', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" required />
                  </div>
                )}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Email</label>
                  <input type="email" value={formData.email}
                    onChange={(e) => handleFormChange('email', e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">First Name</label>
                  <input type="text" value={formData.first_name}
                    onChange={(e) => handleFormChange('first_name', e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Last Name</label>
                  <input type="text" value={formData.last_name}
                    onChange={(e) => handleFormChange('last_name', e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Role *</label>
                  <select value={formData.role} onChange={(e) => handleFormChange('role', e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" required>
                    {roleOptions.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Branch</label>
                  <input type="text" value={formData.branch}
                    onChange={(e) => handleFormChange('branch', e.target.value)}
                    placeholder="e.g., CSE, ECE, MECH"
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
                  <p className="text-xs text-gray-500 mt-1">Leave empty for access to all branches</p>
                </div>
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-gray-700 mb-2">Department</label>
                  <input type="text" value={formData.department}
                    onChange={(e) => handleFormChange('department', e.target.value)}
                    placeholder="e.g., Computer Science & Engineering"
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
                </div>
              </div>

              {/* Permissions */}
              <div className="border-t pt-6 mb-6">
                <h3 className="text-lg font-semibold text-gray-800 mb-1">Permissions</h3>
                <p className="text-sm text-gray-500 mb-4">Select which features and actions this user can perform:</p>

                <div className="space-y-5">
                  {PERM_GROUPS.map(group => (
                    <div key={group.label} className="border border-gray-100 rounded-lg p-4 bg-gray-50">
                      <p className="text-xs font-semibold text-gray-600 uppercase tracking-wider mb-3">{group.label}</p>
                      <div className="grid grid-cols-1 md:grid-cols-2 gap-2">
                        {group.perms.map(p => (
                          <div key={p.key} className="flex items-start">
                            <input type="checkbox" id={p.key} checked={formData[p.key]}
                              onChange={(e) => handleFormChange(p.key, e.target.checked)}
                              className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded mt-1" />
                            <label htmlFor={p.key} className="ml-3 block">
                              <span className="text-sm font-medium text-gray-700">{p.label}</span>
                              <p className="text-xs text-gray-500">{p.desc}</p>
                            </label>
                          </div>
                        ))}
                      </div>
                    </div>
                  ))}

                  {/* Account status — separate */}
                  <div className="border-t pt-4">
                    <div className="flex items-start">
                      <input type="checkbox" id="is_active_user" checked={formData.is_active_user}
                        onChange={(e) => handleFormChange('is_active_user', e.target.checked)}
                        className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded mt-1" />
                      <label htmlFor="is_active_user" className="ml-3 block">
                        <span className="text-sm font-medium text-gray-700">Account is Active</span>
                        <p className="text-xs text-gray-500">User can log in (uncheck to disable account)</p>
                      </label>
                    </div>
                  </div>
                </div>
              </div>

              <div className="flex justify-end space-x-3">
                <button type="button" onClick={() => setShowUserModal(false)}
                  className="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">Cancel</button>
                <button type="submit"
                  className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                  {modalMode === 'create' ? 'Create User' : 'Update User'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ── Reset Password Modal ── */}
      {showPasswordModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-md w-full">
            <div className="flex justify-between items-center p-6 border-b">
              <h2 className="text-2xl font-bold text-gray-800">Reset Password</h2>
              <button onClick={() => setShowPasswordModal(false)} className="text-gray-500 hover:text-gray-700">
                <FaTimes size={24} />
              </button>
            </div>
            <form onSubmit={handleSubmitPassword} className="p-6">
              <p className="text-gray-600 mb-4">Reset password for: <strong>{selectedUser?.username}</strong></p>
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">New Password *</label>
                  <input type="password" value={passwordData.new_password}
                    onChange={(e) => setPasswordData(prev => ({ ...prev, new_password: e.target.value }))}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" required />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Confirm Password *</label>
                  <input type="password" value={passwordData.confirm_password}
                    onChange={(e) => setPasswordData(prev => ({ ...prev, confirm_password: e.target.value }))}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" required />
                </div>
              </div>
              <div className="mt-6 flex justify-end space-x-3">
                <button type="button" onClick={() => setShowPasswordModal(false)}
                  className="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">Cancel</button>
                <button type="submit" className="px-4 py-2 bg-orange-600 text-white rounded-lg hover:bg-orange-700">
                  Reset Password
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ── Bulk Delete Confirmation ── */}
      {showBulkDeleteConfirm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-md w-full">
            <div className="flex justify-between items-center p-6 border-b">
              <h2 className="text-xl font-bold text-gray-800">Confirm Bulk Delete</h2>
              <button onClick={() => setShowBulkDeleteConfirm(false)} className="text-gray-500 hover:text-gray-700">
                <FaTimes size={20} />
              </button>
            </div>
            <div className="p-6">
              <p className="text-gray-600 mb-2">Delete <strong>{selectedUsers.length}</strong> selected user(s)?</p>
              <p className="text-sm text-red-600">This action cannot be undone.</p>
            </div>
            <div className="flex justify-end space-x-3 p-6 border-t">
              <button onClick={() => setShowBulkDeleteConfirm(false)}
                className="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">Cancel</button>
              <button onClick={handleBulkDelete}
                className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">Delete Selected</button>
            </div>
          </div>
        </div>
      )}

      {toast && <Toast message={toast.message} type={toast.type} onClose={() => setToast(null)} />}
    </div>
  );
};

export default UserManagement;
