import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import Navbar from '../components/Navbar';
import { resultsService } from '../services/resultsService';
import {
  FaShieldAlt, FaSearch, FaFilter, FaSync, FaTimes,
  FaSignInAlt, FaSignOutAlt, FaCheckCircle, FaTimesCircle,
  FaInfoCircle, FaUser, FaList, FaNetworkWired, FaClock
} from 'react-icons/fa';

// ─── helpers ────────────────────────────────────────────────────────────────

const ACTION_META = {
  login:                { label: 'Login',                color: 'bg-green-100 text-green-700',  dot: 'bg-green-500',  icon: FaSignInAlt },
  logout:               { label: 'Logout',               color: 'bg-red-100 text-red-600',      dot: 'bg-red-500',    icon: FaSignOutAlt },
  password_change:      { label: 'Password Change',      color: 'bg-yellow-100 text-yellow-700',dot: 'bg-yellow-500', icon: FaShieldAlt },
  result_upload:        { label: 'Result Upload',        color: 'bg-blue-100 text-blue-700',    dot: 'bg-blue-500',   icon: FaCheckCircle },
  result_view:          { label: 'Result View',          color: 'bg-indigo-100 text-indigo-700',dot: 'bg-indigo-400', icon: FaInfoCircle },
  result_edit:          { label: 'Result Edit',          color: 'bg-orange-100 text-orange-700',dot: 'bg-orange-500', icon: FaInfoCircle },
  result_delete:        { label: 'Result Delete',        color: 'bg-red-100 text-red-700',      dot: 'bg-red-600',    icon: FaTimesCircle },
  result_delete_exam:   { label: 'Delete Exam',          color: 'bg-red-100 text-red-800',      dot: 'bg-red-700',    icon: FaTimesCircle },
  user_registration:    { label: 'User Registration',    color: 'bg-purple-100 text-purple-700',dot: 'bg-purple-500', icon: FaUser },
  circular_created:     { label: 'Circular Created',     color: 'bg-teal-100 text-teal-700',    dot: 'bg-teal-500',   icon: FaList },
  circular_updated:     { label: 'Circular Updated',     color: 'bg-teal-100 text-teal-600',    dot: 'bg-teal-400',   icon: FaList },
  circular_deleted:     { label: 'Circular Deleted',     color: 'bg-red-100 text-red-600',      dot: 'bg-red-400',    icon: FaTimesCircle },
  profile_updated:      { label: 'Profile Updated',      color: 'bg-gray-100 text-gray-700',    dot: 'bg-gray-500',   icon: FaUser },
  hall_tickets_generated:{ label: 'Hall Tickets Generated', color: 'bg-cyan-100 text-cyan-700', dot: 'bg-cyan-500',   icon: FaCheckCircle },
  hall_ticket_downloaded:{ label: 'Hall Ticket Downloaded', color: 'bg-cyan-100 text-cyan-600', dot: 'bg-cyan-400',   icon: FaCheckCircle },
};

const ROLE_BADGE = {
  admin:           'bg-red-100 text-red-700',
  student:         'bg-blue-100 text-blue-700',
  faculty:         'bg-green-100 text-green-700',
  hod:             'bg-yellow-100 text-yellow-700',
  principal:       'bg-purple-100 text-purple-700',
  vice_principal:  'bg-indigo-100 text-indigo-700',
  dean:            'bg-pink-100 text-pink-700',
  staff:           'bg-gray-100 text-gray-700',
};

const ACTION_CHOICES = [
  { value: '', label: 'All Actions' },
  { value: 'login', label: 'Login' },
  { value: 'logout', label: 'Logout' },
  { value: 'password_change', label: 'Password Change' },
  { value: 'result_upload', label: 'Result Upload' },
  { value: 'result_view', label: 'Result View' },
  { value: 'result_edit', label: 'Result Edit' },
  { value: 'result_delete_exam', label: 'Delete Exam' },
  { value: 'user_registration', label: 'User Registration' },
  { value: 'circular_created', label: 'Circular Created' },
  { value: 'circular_updated', label: 'Circular Updated' },
  { value: 'circular_deleted', label: 'Circular Deleted' },
  { value: 'profile_updated', label: 'Profile Updated' },
  { value: 'hall_tickets_generated', label: 'Hall Tickets Generated' },
  { value: 'hall_ticket_downloaded', label: 'Hall Ticket Downloaded' },
];

function formatTime(iso) {
  if (!iso) return '—';
  try {
    return new Date(iso).toLocaleString('en-IN', {
      day: '2-digit', month: 'short', year: 'numeric',
      hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true,
    });
  } catch {
    return iso;
  }
}

// Flatten sessions → individual rows for the table
function flattenSessions(sessions) {
  const rows = [];
  for (const s of sessions) {
    for (const act of s.activities || []) {
      rows.push({
        id: act.id,
        timestamp: act.timestamp,
        user: s.user,
        user_role: s.user_role,
        action: act.action,
        action_display: act.action_display,
        details: act.details,
        ip_address: act.ip_address || s.ip_address,
        session_id: s.session_id,
      });
    }
  }
  // Sort newest first
  rows.sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));
  return rows;
}

// ─── AuditLogs page ───────────────────────────────────────────────────────────

const PAGE_SIZE = 50;

export default function AuditLogs() {
  const navigate = useNavigate();
  const { user } = useAuth();

  const [sessions, setSessions] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  // Filters
  const [filterUser, setFilterUser] = useState('');
  const [filterUserInput, setFilterUserInput] = useState('');
  const [filterAction, setFilterAction] = useState('');

  // Pagination
  const [page, setPage] = useState(1);

  const fetchLogs = useCallback(async () => {
    setLoading(true);
    setError('');
    try {
      const data = await resultsService.getAuditLogs({
        user: filterUser || undefined,
        action: filterAction || undefined,
      });
      setSessions(data.sessions || []);
      setPage(1);
    } catch (err) {
      setError(
        (err && err.response && err.response.data && err.response.data.error)
        || 'Failed to load audit logs'
      );
    } finally {
      setLoading(false);
    }
  }, [filterUser, filterAction]);

  useEffect(() => {
    if (user && user.role !== 'admin') {
      navigate('/admin/dashboard');
      return;
    }
    fetchLogs();
  }, [fetchLogs, user, navigate]);

  const handleUserSearch = (e) => {
    e.preventDefault();
    setFilterUser(filterUserInput.trim());
  };

  const clearFilters = () => {
    setFilterUser('');
    setFilterUserInput('');
    setFilterAction('');
  };

  const rows = flattenSessions(sessions);
  const totalPages = Math.max(1, Math.ceil(rows.length / PAGE_SIZE));
  const pageRows = rows.slice((page - 1) * PAGE_SIZE, page * PAGE_SIZE);

  const totalSessions = sessions.length;

  return (
    <div className="min-h-screen bg-gray-100">
      <Navbar />

      <div className="max-w-7xl mx-auto px-4 py-8">

        {/* Page header */}
        <div className="flex items-center justify-between mb-6">
          <div>
            <h1 className="text-2xl font-bold text-gray-800 flex items-center gap-2">
              <FaShieldAlt className="text-indigo-600" />
              Audit Logs
            </h1>
            <p className="text-sm text-gray-500 mt-1">
              Last 5 days &nbsp;·&nbsp;
              <span className="font-medium text-gray-700">{totalSessions}</span> sessions &nbsp;·&nbsp;
              <span className="font-medium text-gray-700">{rows.length}</span> activities
            </p>
          </div>
          <button
            onClick={fetchLogs}
            disabled={loading}
            className="flex items-center gap-2 px-4 py-2 bg-indigo-600 text-white rounded-lg text-sm hover:bg-indigo-700 disabled:opacity-50 transition-colors"
          >
            <FaSync className={loading ? 'animate-spin' : ''} />
            Refresh
          </button>
        </div>

        {/* Filters */}
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-4 mb-4">
          <div className="flex flex-wrap gap-3 items-end">
            {/* User search */}
            <form onSubmit={handleUserSearch} className="flex gap-2 flex-1 min-w-48">
              <div className="relative flex-1">
                <FaSearch className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-sm" />
                <input
                  type="text"
                  placeholder="Filter by username..."
                  value={filterUserInput}
                  onChange={e => setFilterUserInput(e.target.value)}
                  className="w-full pl-9 pr-3 py-2 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400"
                />
              </div>
              <button
                type="submit"
                className="px-3 py-2 bg-gray-100 text-gray-600 rounded-lg text-sm hover:bg-gray-200 transition-colors"
              >
                Search
              </button>
            </form>

            {/* Action filter */}
            <div className="flex items-center gap-2">
              <FaFilter className="text-gray-400 text-sm" />
              <select
                value={filterAction}
                onChange={e => { setFilterAction(e.target.value); setPage(1); }}
                className="border border-gray-300 rounded-lg text-sm px-3 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-400"
              >
                {ACTION_CHOICES.map(c => (
                  <option key={c.value} value={c.value}>{c.label}</option>
                ))}
              </select>
            </div>

            {(filterUser || filterAction) && (
              <button
                onClick={clearFilters}
                className="flex items-center gap-1.5 px-3 py-2 text-sm text-red-500 hover:text-red-700 border border-red-200 rounded-lg transition-colors"
              >
                <FaTimes className="text-xs" /> Clear filters
              </button>
            )}
          </div>
        </div>

        {/* Loading */}
        {loading && (
          <div className="flex justify-center py-16">
            <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-indigo-600" />
          </div>
        )}

        {/* Error */}
        {error && !loading && (
          <div className="bg-red-50 border border-red-200 text-red-700 rounded-xl p-4 text-sm">
            {error}
          </div>
        )}

        {/* Empty */}
        {!loading && !error && rows.length === 0 && (
          <div className="text-center py-16 text-gray-400">
            <FaShieldAlt className="mx-auto text-4xl mb-3 opacity-30" />
            <p className="text-lg font-medium">No audit logs found</p>
            <p className="text-sm mt-1">No activity in the last 5 days matching your filters.</p>
          </div>
        )}

        {/* Table */}
        {!loading && !error && rows.length > 0 && (
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="bg-gray-50 border-b border-gray-200 text-xs text-gray-500 uppercase tracking-wide">
                    <th className="px-4 py-3 text-left font-semibold whitespace-nowrap">
                      <span className="flex items-center gap-1.5"><FaClock className="text-gray-400" /> Timestamp</span>
                    </th>
                    <th className="px-4 py-3 text-left font-semibold whitespace-nowrap">
                      <span className="flex items-center gap-1.5"><FaUser className="text-gray-400" /> User</span>
                    </th>
                    <th className="px-4 py-3 text-left font-semibold">Role</th>
                    <th className="px-4 py-3 text-left font-semibold">Action</th>
                    <th className="px-4 py-3 text-left font-semibold">Details</th>
                    <th className="px-4 py-3 text-left font-semibold whitespace-nowrap">
                      <span className="flex items-center gap-1.5"><FaNetworkWired className="text-gray-400" /> IP Address</span>
                    </th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {pageRows.map((row, idx) => {
                    const meta = ACTION_META[row.action] || {
                      label: row.action_display || row.action,
                      color: 'bg-gray-100 text-gray-600',
                      dot: 'bg-gray-400',
                      icon: FaList,
                    };
                    const Icon = meta.icon;
                    const roleCls = ROLE_BADGE[row.user_role] || 'bg-gray-100 text-gray-700';

                    return (
                      <tr
                        key={row.id || idx}
                        className="hover:bg-indigo-50/40 transition-colors"
                      >
                        {/* Timestamp */}
                        <td className="px-4 py-3 text-gray-500 whitespace-nowrap text-xs font-mono">
                          {formatTime(row.timestamp)}
                        </td>

                        {/* User */}
                        <td className="px-4 py-3 font-medium text-gray-800 whitespace-nowrap">
                          {row.user}
                        </td>

                        {/* Role */}
                        <td className="px-4 py-3">
                          <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${roleCls}`}>
                            {row.user_role || '—'}
                          </span>
                        </td>

                        {/* Action badge */}
                        <td className="px-4 py-3 whitespace-nowrap">
                          <span className={`inline-flex items-center gap-1.5 text-xs px-2.5 py-1 rounded-full font-medium ${meta.color}`}>
                            <Icon className="text-xs" />
                            {meta.label || row.action_display || row.action}
                          </span>
                        </td>

                        {/* Details */}
                        <td className="px-4 py-3 text-gray-500 max-w-xs">
                          <span className="block truncate" title={row.details || ''}>
                            {row.details || <span className="text-gray-300 italic">—</span>}
                          </span>
                        </td>

                        {/* IP */}
                        <td className="px-4 py-3 text-gray-500 whitespace-nowrap font-mono text-xs">
                          {row.ip_address || '—'}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>

            {/* Pagination */}
            {totalPages > 1 && (
              <div className="flex items-center justify-between px-4 py-3 border-t border-gray-100 bg-gray-50 text-sm text-gray-600">
                <span>
                  Showing {(page - 1) * PAGE_SIZE + 1}–{Math.min(page * PAGE_SIZE, rows.length)} of {rows.length} entries
                </span>
                <div className="flex items-center gap-2">
                  <button
                    onClick={() => setPage(p => Math.max(1, p - 1))}
                    disabled={page === 1}
                    className="px-3 py-1.5 rounded-lg border border-gray-200 bg-white hover:bg-gray-100 disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
                  >
                    Previous
                  </button>
                  <span className="px-2 font-medium">{page} / {totalPages}</span>
                  <button
                    onClick={() => setPage(p => Math.min(totalPages, p + 1))}
                    disabled={page === totalPages}
                    className="px-3 py-1.5 rounded-lg border border-gray-200 bg-white hover:bg-gray-100 disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
                  >
                    Next
                  </button>
                </div>
              </div>
            )}
          </div>
        )}

      </div>
    </div>
  );
}
