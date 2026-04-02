import React, { useState, useEffect, useCallback } from 'react';
import { FaTimes, FaSearch, FaExclamationTriangle, FaUserSlash, FaDownload } from 'react-icons/fa';
import { detainedService } from '../services/resultsService';

const OPERATORS = [
  { value: 'lt',  label: '< Less than' },
  { value: 'lte', label: '<= Less than or equal' },
  { value: 'eq',  label: '= Equal to' },
  { value: 'gte', label: '>= Greater than or equal' },
  { value: 'gt',  label: '> Greater than' },
];

const YEARS     = ['1', '2', '3', '4'];
const SEMESTERS = ['1', '2'];

const MONTHS = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

export default function DetainedStudentsModal({ isOpen, onClose }) {
  const [filters, setFilters] = useState({
    year: '',
    semester: '',
    credits: '',
    operator: 'lt',
    exam_month: '',
    exam_year: '',
  });
  const [results, setResults] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError]     = useState('');

  // Close on ESC
  useEffect(() => {
    const handler = (e) => { if (e.key === 'Escape') onClose(); };
    window.addEventListener('keydown', handler);
    return () => window.removeEventListener('keydown', handler);
  }, [onClose]);

  const handleChange = useCallback((e) => {
    const { name, value } = e.target;
    setFilters((prev) => ({ ...prev, [name]: value }));
    setError('');
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!filters.credits || isNaN(Number(filters.credits))) {
      setError('Please enter a valid numeric credits threshold.');
      return;
    }
    // Both month and year must be provided together, or neither
    const hasMonth = filters.exam_month.trim() !== '';
    const hasYear  = filters.exam_year.trim() !== '';
    if (hasMonth !== hasYear) {
      setError('Please provide both Exam Month and Exam Year, or leave both blank.');
      return;
    }
    if (hasYear && (isNaN(Number(filters.exam_year)) || filters.exam_year.trim().length !== 4)) {
      setError('Exam Year must be a 4-digit number (e.g. 2025).');
      return;
    }

    setLoading(true);
    setError('');
    setResults(null);
    try {
      const params = {
        credits:  filters.credits,
        operator: filters.operator,
      };
      if (filters.year)     params.year     = filters.year;
      if (filters.semester) params.semester = filters.semester;
      if (hasMonth && hasYear) {
        params.exam_month_year = `${filters.exam_month} ${filters.exam_year.trim()}`;
      }

      const data = await detainedService.getDetainedStudents(params);
      setResults(data);
    } catch (err) {
      setError(err?.response?.data?.error || err?.message || 'An error occurred.');
    } finally {
      setLoading(false);
    }
  };

  const handleReset = () => {
    setFilters({ year: '', semester: '', credits: '', operator: 'lt', exam_month: '', exam_year: '' });
    setResults(null);
    setError('');
  };

  const students = results?.detained_students ?? [];

  const downloadCSV = () => {
    if (!students.length) return;
    const header = [
      '#', 'Roll No', 'Name', 'Course',
      'Cumulative Earned Credits', 'Cumulative Total Credits',
      'Failed Subjects Count', 'Failed Subjects',
    ];
    const rows = students.map((s, i) => [
      i + 1,
      s.roll_number,
      `"${s.student_name}"`,
      s.course?.toUpperCase(),
      s.cumulative_earned_credits,
      s.cumulative_total_credits,
      s.failed_subjects_count,
      `"${(s.failed_subjects || []).map(f => f.subject_name).join('; ')}"`,
    ]);
    const csv  = [header, ...rows].map((r) => r.join(',')).join('\n');
    const blob = new Blob([csv], { type: 'text/csv' });
    const url  = URL.createObjectURL(blob);
    const a    = document.createElement('a');
    a.href     = url;
    a.download = 'detained_students.csv';
    a.click();
    URL.revokeObjectURL(url);
  };

  if (!isOpen) return null;

  const upToLabel = results?.filters?.up_to_label ?? '';

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm"
      onClick={(e) => { if (e.target === e.currentTarget) onClose(); }}
    >
      <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-5xl mx-4 max-h-[90vh] flex flex-col">

        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-gray-200 bg-red-50 rounded-t-2xl">
          <div className="flex items-center gap-3">
            <FaUserSlash className="text-red-600 text-xl" />
            <div>
              <h2 className="text-lg font-semibold text-gray-800">Detained Students</h2>
              <p className="text-xs text-gray-500 mt-0.5">
                Only students who appeared in the selected year &amp; semester are shown.
                Credits are cumulative up to that point.
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-600 transition-colors p-1 rounded-lg hover:bg-gray-100"
            aria-label="Close"
          >
            <FaTimes className="text-lg" />
          </button>
        </div>

        {/* Filter Form */}
        <form onSubmit={handleSubmit} className="px-6 py-4 border-b border-gray-100 bg-gray-50">
          <p className="text-xs text-gray-500 mb-3">
            Select <strong>Year</strong> and <strong>Semester</strong> — only students who appeared
            in that semester are considered. Optionally pick an <strong>Exam Month</strong> and enter
            an <strong>Exam Year</strong> to exclude supplementary or other sittings from the credit calculation.
          </p>
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">

            {/* Year */}
            <div>
              <label className="block text-xs font-medium text-gray-600 mb-1">Year</label>
              <select name="year" value={filters.year} onChange={handleChange}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-400">
                <option value="">All Years</option>
                {YEARS.map((y) => <option key={y} value={y}>Year {y}</option>)}
              </select>
            </div>

            {/* Semester */}
            <div>
              <label className="block text-xs font-medium text-gray-600 mb-1">Semester</label>
              <select name="semester" value={filters.semester} onChange={handleChange}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-400">
                <option value="">All Semesters</option>
                {SEMESTERS.map((s) => <option key={s} value={s}>Semester {s}</option>)}
              </select>
            </div>

            {/* Exam Month */}
            <div>
              <label className="block text-xs font-medium text-gray-600 mb-1">Exam Month</label>
              <select name="exam_month" value={filters.exam_month} onChange={handleChange}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-400">
                <option value="">Any Month</option>
                {MONTHS.map((m) => <option key={m} value={m}>{m}</option>)}
              </select>
            </div>

            {/* Exam Year */}
            <div>
              <label className="block text-xs font-medium text-gray-600 mb-1">Exam Year</label>
              <input
                type="number"
                name="exam_year"
                value={filters.exam_year}
                onChange={handleChange}
                placeholder="e.g. 2025"
                min="2000"
                max="2099"
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-400"
              />
            </div>

            {/* Operator */}
            <div>
              <label className="block text-xs font-medium text-gray-600 mb-1">Operator</label>
              <select name="operator" value={filters.operator} onChange={handleChange}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-400">
                {OPERATORS.map((op) => <option key={op.value} value={op.value}>{op.label}</option>)}
              </select>
            </div>

            {/* Credits */}
            <div>
              <label className="block text-xs font-medium text-gray-600 mb-1">Credits Threshold</label>
              <input type="number" name="credits" value={filters.credits} onChange={handleChange}
                placeholder="e.g. 60" min="0"
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-400" />
            </div>
          </div>

          {error && (
            <div className="mt-3 flex items-center gap-2 text-sm text-red-600 bg-red-50 px-3 py-2 rounded-lg">
              <FaExclamationTriangle /> {error}
            </div>
          )}

          <div className="mt-4 flex gap-3">
            <button type="submit" disabled={loading}
              className="flex items-center gap-2 bg-red-600 text-white px-6 py-2.5 rounded-lg hover:bg-red-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors font-medium">
              <FaSearch />
              {loading ? 'Searching...' : 'Find Detained Students'}
            </button>
            <button type="button" onClick={handleReset}
              className="px-6 py-2.5 rounded-lg border border-gray-300 text-gray-600 hover:bg-gray-100 transition-colors font-medium">
              Reset
            </button>
          </div>
        </form>

        {/* Results */}
        <div className="flex-1 overflow-y-auto px-6 py-4">

          {loading && (
            <div className="flex items-center justify-center py-12 text-gray-500">
              <svg className="animate-spin h-6 w-6 mr-3 text-red-500" viewBox="0 0 24 24" fill="none">
                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z" />
              </svg>
              Searching...
            </div>
          )}

          {!loading && results && (
            <>
              {/* Summary bar */}
              <div className="flex items-center justify-between mb-3">
                <div>
                  <p className="text-sm text-gray-600">
                    Found{' '}
                    <span className="font-semibold text-red-600">{results.count}</span>{' '}
                    student{results.count !== 1 ? 's' : ''} with cumulative earned credits{' '}
                    <span className="font-medium text-gray-800">
                      {results.filters?.operator} {results.filters?.credits_threshold}
                    </span>
                  </p>
                  {upToLabel && (
                    <p className="text-xs text-gray-400 mt-0.5">
                      Boundary: <span className="font-medium text-gray-600">{upToLabel}</span>
                      {results.filters?.exam_month_year && results.filters.exam_month_year !== 'all' && (
                        <> &nbsp;&bull;&nbsp; Exam: <span className="font-medium text-gray-600">{results.filters.exam_month_year}</span></>
                      )}
                    </p>
                  )}
                </div>
                {students.length > 0 && (
                  <button onClick={downloadCSV}
                    className="flex items-center gap-2 text-sm text-red-600 border border-red-300 px-3 py-1.5 rounded-lg hover:bg-red-50 transition-colors">
                    <FaDownload /> Export CSV
                  </button>
                )}
              </div>

              {students.length === 0 ? (
                <div className="text-center py-12 text-gray-400">
                  <FaUserSlash className="text-4xl mx-auto mb-3 opacity-30" />
                  <p>No students found matching the criteria.</p>
                </div>
              ) : (
                <div className="overflow-x-auto rounded-xl border border-gray-200">
                  <table className="w-full text-sm">
                    <thead className="bg-gray-50 text-gray-500 uppercase text-xs tracking-wider">
                      <tr>
                        <th className="px-3 py-3 text-left">#</th>
                        <th className="px-3 py-3 text-left">Roll No</th>
                        <th className="px-3 py-3 text-left">Name</th>
                        <th className="px-3 py-3 text-center">Earned Cr.</th>
                        <th className="px-3 py-3 text-center">Total Cr.</th>
                        <th className="px-3 py-3 text-center">Failed Subjs</th>
                        <th className="px-3 py-3 text-left">Failed Subject Names</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                      {students.map((s, idx) => (
                        <tr key={s.roll_number + '-' + idx} className="hover:bg-red-50/40 transition-colors">
                          <td className="px-3 py-3 text-gray-400">{idx + 1}</td>
                          <td className="px-3 py-3 font-mono font-medium text-gray-800">{s.roll_number}</td>
                          <td className="px-3 py-3 text-gray-700 whitespace-nowrap">{s.student_name}</td>
                          <td className="px-3 py-3 text-center">
                            <span className="inline-block bg-red-100 text-red-700 font-semibold px-2 py-0.5 rounded-full">
                              {s.cumulative_earned_credits}
                            </span>
                          </td>
                          <td className="px-3 py-3 text-center text-gray-600">{s.cumulative_total_credits}</td>
                          <td className="px-3 py-3 text-center">
                            {s.failed_subjects_count > 0
                              ? <span className="inline-block bg-orange-100 text-orange-700 font-semibold px-2 py-0.5 rounded-full">{s.failed_subjects_count}</span>
                              : <span className="text-gray-300">—</span>}
                          </td>
                          <td className="px-3 py-3 text-gray-500 text-xs">
                            {s.failed_subjects?.length > 0
                              ? s.failed_subjects.map(f => `${f.subject_name} (Y${f.year}S${f.semester})`).join(', ')
                              : <span className="text-gray-300">—</span>}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </>
          )}

          {!loading && !results && (
            <div className="text-center py-12 text-gray-400">
              <FaUserSlash className="text-5xl mx-auto mb-4 opacity-20" />
              <p className="text-base">Set your filters and click <strong>Find Detained Students</strong>.</p>
              <p className="text-xs mt-2 text-gray-300">
                Only students who appeared in the selected semester will be included.
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
