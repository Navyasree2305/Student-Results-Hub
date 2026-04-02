import React, { useState, useEffect, useMemo } from 'react';
import {
  BarChart, Bar, PieChart, Pie, Cell, XAxis, YAxis,
  CartesianGrid, Tooltip, Legend, ResponsiveContainer,
  RadarChart, Radar, PolarGrid, PolarAngleAxis, PolarRadiusAxis,
  ScatterChart, Scatter, ZAxis,
} from 'recharts';
import api from '../services/api';
import { FaBrain, FaTimes, FaFlask, FaBook, FaArrowUp, FaArrowDown, FaFilter, FaChartBar } from 'react-icons/fa';

const DIFFICULTY_COLORS = {
  'Very Hard': '#DC2626',
  'Hard': '#F97316',
  'Moderate': '#EAB308',
  'Easy': '#22C55E',
  'Very Easy': '#06B6D4',
};

const GRADE_COLORS = {
  'O': '#06B6D4',
  'A': '#22C55E',
  'B': '#84CC16',
  'C': '#EAB308',
  'D': '#F97316',
  'F': '#DC2626',
};

const SubjectDifficultyAnalyzer = ({ onClose }) => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [activeTab, setActiveTab] = useState('overview');
  const [selectedSubject, setSelectedSubject] = useState(null);
  const [sortBy, setSortBy] = useState('difficulty_score');
  const [sortOrder, setSortOrder] = useState('desc');

  // Filters
  const [branch, setBranch] = useState('all');
  const [year, setYear] = useState('all');
  const [semester, setSemester] = useState('all');
  const [course, setCourse] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');

  useEffect(() => {
    const handleEsc = (e) => { if (e.key === 'Escape') onClose(); };
    document.addEventListener('keydown', handleEsc);
    return () => document.removeEventListener('keydown', handleEsc);
  }, [onClose]);

  const fetchAnalysis = async () => {
    setLoading(true);
    setError('');
    try {
      const params = new URLSearchParams();
      if (branch !== 'all') params.append('branch', branch);
      if (year !== 'all') params.append('year', year);
      if (semester !== 'all') params.append('semester', semester);
      if (course !== 'all') params.append('course', course);
      const res = await api.get(`/subject-difficulty/?${params.toString()}`);
      setData(res.data);
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to fetch analysis');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchAnalysis(); }, [branch, year, semester, course]);

  const filteredSubjects = useMemo(() => {
    if (!data?.subjects) return [];
    let subjects = [...data.subjects];
    if (searchQuery) {
      const q = searchQuery.toLowerCase();
      subjects = subjects.filter(
        s => s.subject_code.toLowerCase().includes(q) || s.subject_name.toLowerCase().includes(q)
      );
    }
    subjects.sort((a, b) => {
      const aVal = a[sortBy] ?? 0;
      const bVal = b[sortBy] ?? 0;
      return sortOrder === 'desc' ? bVal - aVal : aVal - bVal;
    });
    return subjects;
  }, [data, searchQuery, sortBy, sortOrder]);

  const handleSort = (field) => {
    if (sortBy === field) {
      setSortOrder(prev => prev === 'desc' ? 'asc' : 'desc');
    } else {
      setSortBy(field);
      setSortOrder('desc');
    }
  };

  const SortIcon = ({ field }) => {
    if (sortBy !== field) return <span className="text-gray-300 ml-1">&#8597;</span>;
    return sortOrder === 'desc'
      ? <FaArrowDown className="inline ml-1 text-blue-500 text-xs" />
      : <FaArrowUp className="inline ml-1 text-blue-500 text-xs" />;
  };

  const getDifficultyBadge = (level) => {
    const color = DIFFICULTY_COLORS[level] || '#6B7280';
    return (
      <span
        className="px-2 py-1 rounded-full text-xs font-bold text-white"
        style={{ backgroundColor: color }}
      >
        {level}
      </span>
    );
  };

  // Prepare chart data
  const difficultyDistData = data?.summary?.difficulty_distribution
    ? Object.entries(data.summary.difficulty_distribution).map(([name, value]) => ({
        name, value, fill: DIFFICULTY_COLORS[name] || '#6B7280',
      }))
    : [];

  const theoryVsLabData = data?.summary?.theory_vs_lab
    ? [
        { name: 'Theory', difficulty: data.summary.theory_vs_lab.theory.avg_difficulty, passRate: data.summary.theory_vs_lab.theory.avg_pass_rate, count: data.summary.theory_vs_lab.theory.count },
        { name: 'Lab', difficulty: data.summary.theory_vs_lab.lab.avg_difficulty, passRate: data.summary.theory_vs_lab.lab.avg_pass_rate, count: data.summary.theory_vs_lab.lab.count },
      ]
    : [];

  const featureImpData = data?.feature_importances
    ? Object.entries(data.feature_importances).map(([name, value]) => ({
        name: name.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase()),
        value,
        fullMark: 50,
      }))
    : [];

  const scatterData = data?.subjects
    ? data.subjects.map(s => ({
        x: s.fail_rate,
        y: s.avg_grade_point,
        z: s.total_students,
        name: s.subject_code,
        difficulty: s.difficulty_score,
      }))
    : [];

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg shadow-xl w-full max-w-7xl max-h-[95vh] overflow-y-auto">
        {/* Header */}
        <div className="p-6 border-b border-gray-200 flex justify-between items-center sticky top-0 bg-white z-10">
          <div>
            <h2 className="text-2xl font-bold text-gray-900 flex items-center gap-2">
              <FaBrain className="text-orange-500" />
              ML Subject Difficulty Analyzer
            </h2>
            <p className="text-sm text-gray-500 mt-1">
              {data?.ml_enabled
                ? 'Powered by Random Forest ML model'
                : 'Statistical analysis mode (install scikit-learn for ML predictions)'}
              {data?.total_subjects_analyzed && ` | ${data.total_subjects_analyzed} subjects analyzed`}
            </p>
          </div>
          <button onClick={onClose} className="text-gray-500 hover:text-gray-700 text-3xl font-bold w-10 h-10 flex items-center justify-center hover:bg-gray-100 rounded-full" title="Close (ESC)">
            <FaTimes />
          </button>
        </div>

        {/* Filters */}
        <div className="p-4 bg-gray-50 border-b border-gray-200 flex flex-wrap gap-3 items-center sticky top-[89px] z-10">
          <FaFilter className="text-gray-400" />
          <select value={branch} onChange={e => setBranch(e.target.value)} className="border rounded-lg px-3 py-2 text-sm bg-white">
            <option value="all">All Branches</option>
            <option value="cse">CSE</option>
            <option value="ece">ECE</option>
            <option value="eee">EEE</option>
            <option value="mech">Mechanical</option>
            <option value="civil">Civil</option>
            <option value="it">IT</option>
          </select>
          <select value={year} onChange={e => setYear(e.target.value)} className="border rounded-lg px-3 py-2 text-sm bg-white">
            <option value="all">All Years</option>
            <option value="1">I Year</option>
            <option value="2">II Year</option>
            <option value="3">III Year</option>
            <option value="4">IV Year</option>
          </select>
          <select value={semester} onChange={e => setSemester(e.target.value)} className="border rounded-lg px-3 py-2 text-sm bg-white">
            <option value="all">All Semesters</option>
            <option value="1">Semester 1</option>
            <option value="2">Semester 2</option>
          </select>
          <select value={course} onChange={e => setCourse(e.target.value)} className="border rounded-lg px-3 py-2 text-sm bg-white">
            <option value="all">All Courses</option>
            <option value="btech">B.Tech</option>
            <option value="mtech">M.Tech</option>
          </select>
          <input
            type="text"
            placeholder="Search subject code or name..."
            value={searchQuery}
            onChange={e => setSearchQuery(e.target.value)}
            className="border rounded-lg px-3 py-2 text-sm bg-white flex-1 min-w-[200px]"
          />
        </div>

        {/* Content */}
        <div className="p-6">
          {loading ? (
            <div className="text-center py-20">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-orange-500 mx-auto" />
              <p className="text-gray-500 mt-4">Running ML analysis...</p>
            </div>
          ) : error ? (
            <div className="text-center py-20">
              <p className="text-red-500 text-lg">{error}</p>
              <button onClick={fetchAnalysis} className="mt-4 px-4 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600">
                Retry
              </button>
            </div>
          ) : data?.status === 'no_data' || data?.status === 'insufficient_data' ? (
            <div className="text-center py-20">
              <FaChartBar className="text-6xl text-gray-300 mx-auto mb-4" />
              <p className="text-gray-500 text-lg">{data.message}</p>
            </div>
          ) : (
            <>
              {/* Tabs */}
              <div className="flex gap-2 mb-6 border-b">
                {[
                  { id: 'overview', label: 'Overview' },
                  { id: 'rankings', label: 'Rankings Table' },
                  { id: 'charts', label: 'Charts & Insights' },
                  ...(data?.ml_enabled ? [{ id: 'ml', label: 'ML Insights' }] : []),
                ].map(tab => (
                  <button
                    key={tab.id}
                    onClick={() => setActiveTab(tab.id)}
                    className={`px-4 py-2 text-sm font-medium border-b-2 transition-colors ${
                      activeTab === tab.id
                        ? 'border-orange-500 text-orange-600'
                        : 'border-transparent text-gray-500 hover:text-gray-700'
                    }`}
                  >
                    {tab.label}
                  </button>
                ))}
              </div>

              {/* Overview Tab */}
              {activeTab === 'overview' && (
                <div>
                  {/* Summary Cards */}
                  <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
                    <div className="bg-gradient-to-br from-orange-50 to-orange-100 rounded-xl p-4 border border-orange-200">
                      <p className="text-xs text-orange-600 font-medium">Subjects Analyzed</p>
                      <p className="text-3xl font-bold text-orange-700">{data.total_subjects_analyzed}</p>
                    </div>
                    <div className="bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl p-4 border border-blue-200">
                      <p className="text-xs text-blue-600 font-medium">Student Records</p>
                      <p className="text-3xl font-bold text-blue-700">{data.total_student_records?.toLocaleString()}</p>
                    </div>
                    <div className="bg-gradient-to-br from-red-50 to-red-100 rounded-xl p-4 border border-red-200">
                      <p className="text-xs text-red-600 font-medium">Avg Difficulty Score</p>
                      <p className="text-3xl font-bold text-red-700">{data.summary.avg_difficulty_score}</p>
                    </div>
                    <div className="bg-gradient-to-br from-green-50 to-green-100 rounded-xl p-4 border border-green-200">
                      <p className="text-xs text-green-600 font-medium">ML Model</p>
                      <p className="text-3xl font-bold text-green-700">{data.ml_enabled ? 'Active' : 'Off'}</p>
                    </div>
                  </div>

                  {/* Top 5 Hardest & Easiest */}
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div className="bg-red-50 rounded-xl p-5 border border-red-200">
                      <h3 className="font-bold text-red-700 mb-3 flex items-center gap-2">
                        <FaArrowUp className="text-red-500" /> Top 5 Hardest Subjects
                      </h3>
                      <div className="space-y-2">
                        {data.summary.top_5_hardest?.map((s, i) => (
                          <div key={i} className="flex items-center justify-between bg-white rounded-lg p-3 shadow-sm">
                            <div className="flex items-center gap-3">
                              <span className="text-lg font-bold text-red-500">#{s.rank}</span>
                              <div>
                                <p className="font-semibold text-sm text-gray-800">{s.code}</p>
                                <p className="text-xs text-gray-500 truncate max-w-[180px]">{s.name}</p>
                              </div>
                            </div>
                            <div className="text-right">
                              <p className="text-sm font-bold text-red-600">{s.fail_rate}% fail</p>
                              <p className="text-xs text-gray-400">Score: {s.difficulty_score}</p>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>
                    <div className="bg-green-50 rounded-xl p-5 border border-green-200">
                      <h3 className="font-bold text-green-700 mb-3 flex items-center gap-2">
                        <FaArrowDown className="text-green-500" /> Top 5 Easiest Subjects
                      </h3>
                      <div className="space-y-2">
                        {data.summary.top_5_easiest?.map((s, i) => (
                          <div key={i} className="flex items-center justify-between bg-white rounded-lg p-3 shadow-sm">
                            <div className="flex items-center gap-3">
                              <span className="text-lg font-bold text-green-500">#{s.rank}</span>
                              <div>
                                <p className="font-semibold text-sm text-gray-800">{s.code}</p>
                                <p className="text-xs text-gray-500 truncate max-w-[180px]">{s.name}</p>
                              </div>
                            </div>
                            <div className="text-right">
                              <p className="text-sm font-bold text-green-600">{s.pass_rate}% pass</p>
                              <p className="text-xs text-gray-400">Score: {s.difficulty_score}</p>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>

                  {/* Difficulty Distribution Pie + Theory vs Lab */}
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div className="bg-white rounded-xl p-5 border border-gray-200 shadow-sm">
                      <h3 className="font-bold text-gray-800 mb-3">Difficulty Distribution</h3>
                      <ResponsiveContainer width="100%" height={250}>
                        <PieChart>
                          <Pie data={difficultyDistData} dataKey="value" nameKey="name" cx="50%" cy="50%" outerRadius={90} label={({ name, value }) => `${name} (${value})`}>
                            {difficultyDistData.map((entry, i) => (
                              <Cell key={i} fill={entry.fill} />
                            ))}
                          </Pie>
                          <Tooltip />
                        </PieChart>
                      </ResponsiveContainer>
                    </div>
                    <div className="bg-white rounded-xl p-5 border border-gray-200 shadow-sm">
                      <h3 className="font-bold text-gray-800 mb-3 flex items-center gap-2">
                        <FaBook className="text-blue-500" /> Theory vs <FaFlask className="text-green-500" /> Lab
                      </h3>
                      <ResponsiveContainer width="100%" height={250}>
                        <BarChart data={theoryVsLabData}>
                          <CartesianGrid strokeDasharray="3 3" />
                          <XAxis dataKey="name" />
                          <YAxis />
                          <Tooltip />
                          <Legend />
                          <Bar dataKey="difficulty" name="Avg Difficulty" fill="#F97316" radius={[4,4,0,0]} />
                          <Bar dataKey="passRate" name="Avg Pass Rate %" fill="#22C55E" radius={[4,4,0,0]} />
                        </BarChart>
                      </ResponsiveContainer>
                    </div>
                  </div>
                </div>
              )}

              {/* Rankings Tab */}
              {activeTab === 'rankings' && (
                <div className="overflow-x-auto">
                  <table className="w-full text-sm">
                    <thead>
                      <tr className="bg-gray-50 text-left">
                        <th className="px-3 py-3 font-semibold text-gray-600 cursor-pointer" onClick={() => handleSort('rank')}>Rank <SortIcon field="rank" /></th>
                        <th className="px-3 py-3 font-semibold text-gray-600">Subject</th>
                        <th className="px-3 py-3 font-semibold text-gray-600">Type</th>
                        <th className="px-3 py-3 font-semibold text-gray-600 cursor-pointer" onClick={() => handleSort('difficulty_score')}>Difficulty <SortIcon field="difficulty_score" /></th>
                        <th className="px-3 py-3 font-semibold text-gray-600 cursor-pointer" onClick={() => handleSort('pass_rate')}>Pass Rate <SortIcon field="pass_rate" /></th>
                        <th className="px-3 py-3 font-semibold text-gray-600 cursor-pointer" onClick={() => handleSort('fail_rate')}>Fail Rate <SortIcon field="fail_rate" /></th>
                        <th className="px-3 py-3 font-semibold text-gray-600 cursor-pointer" onClick={() => handleSort('avg_grade_point')}>Avg GP <SortIcon field="avg_grade_point" /></th>
                        <th className="px-3 py-3 font-semibold text-gray-600 cursor-pointer" onClick={() => handleSort('total_students')}>Students <SortIcon field="total_students" /></th>
                        <th className="px-3 py-3 font-semibold text-gray-600 cursor-pointer" onClick={() => handleSort('avg_attempts')}>Avg Attempts <SortIcon field="avg_attempts" /></th>
                        {data?.ml_enabled && <th className="px-3 py-3 font-semibold text-gray-600">ML Predicted</th>}
                        <th className="px-3 py-3 font-semibold text-gray-600">Level</th>
                      </tr>
                    </thead>
                    <tbody>
                      {filteredSubjects.map((s, i) => (
                        <tr
                          key={i}
                          className="border-b border-gray-100 hover:bg-orange-50 cursor-pointer transition-colors"
                          onClick={() => setSelectedSubject(selectedSubject?.subject_code === s.subject_code ? null : s)}
                        >
                          <td className="px-3 py-3 font-bold text-gray-700">{s.rank}</td>
                          <td className="px-3 py-3">
                            <p className="font-semibold text-gray-800">{s.subject_code}</p>
                            <p className="text-xs text-gray-500 truncate max-w-[200px]">{s.subject_name}</p>
                          </td>
                          <td className="px-3 py-3">
                            <span className={`px-2 py-1 rounded text-xs font-medium ${s.is_lab ? 'bg-green-100 text-green-700' : 'bg-blue-100 text-blue-700'}`}>
                              {s.is_lab ? 'Lab' : 'Theory'}
                            </span>
                          </td>
                          <td className="px-3 py-3">
                            <div className="flex items-center gap-2">
                              <div className="w-16 bg-gray-200 rounded-full h-2">
                                <div
                                  className="h-2 rounded-full"
                                  style={{
                                    width: `${Math.min(s.difficulty_score, 100)}%`,
                                    backgroundColor: DIFFICULTY_COLORS[s.difficulty_level] || '#6B7280',
                                  }}
                                />
                              </div>
                              <span className="text-xs font-mono">{s.difficulty_score}</span>
                            </div>
                          </td>
                          <td className="px-3 py-3 font-medium text-green-600">{s.pass_rate}%</td>
                          <td className="px-3 py-3 font-medium text-red-600">{s.fail_rate}%</td>
                          <td className="px-3 py-3">{s.avg_grade_point}</td>
                          <td className="px-3 py-3">{s.total_students}</td>
                          <td className="px-3 py-3">{s.avg_attempts}</td>
                          {data?.ml_enabled && (
                            <td className="px-3 py-3">
                              <span className="font-medium">{s.predicted_pass_rate}%</span>
                              {s.prediction_confidence && (
                                <span className={`ml-1 text-xs px-1 rounded ${
                                  s.prediction_confidence === 'High' ? 'bg-green-100 text-green-700' :
                                  s.prediction_confidence === 'Medium' ? 'bg-yellow-100 text-yellow-700' :
                                  'bg-red-100 text-red-700'
                                }`}>{s.prediction_confidence}</span>
                              )}
                            </td>
                          )}
                          <td className="px-3 py-3">{getDifficultyBadge(s.difficulty_level)}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                  {filteredSubjects.length === 0 && (
                    <p className="text-center text-gray-400 py-8">No subjects match your search.</p>
                  )}

                  {/* Expanded Subject Detail */}
                  {selectedSubject && (
                    <div className="mt-4 bg-orange-50 rounded-xl p-5 border border-orange-200">
                      <div className="flex justify-between items-start mb-4">
                        <div>
                          <h3 className="font-bold text-lg text-gray-800">{selectedSubject.subject_code} - {selectedSubject.subject_name}</h3>
                          <p className="text-sm text-gray-500">
                            {selectedSubject.is_lab ? 'Lab' : 'Theory'} | {selectedSubject.total_students} students |
                            Branches: {selectedSubject.branches?.join(', ').toUpperCase()}
                          </p>
                        </div>
                        {getDifficultyBadge(selectedSubject.difficulty_level)}
                      </div>
                      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-4">
                        <div className="bg-white rounded-lg p-3 text-center">
                          <p className="text-xs text-gray-500">Avg Internal</p>
                          <p className="text-xl font-bold text-blue-600">{selectedSubject.avg_internal_marks}</p>
                        </div>
                        <div className="bg-white rounded-lg p-3 text-center">
                          <p className="text-xs text-gray-500">Avg External</p>
                          <p className="text-xl font-bold text-purple-600">{selectedSubject.avg_external_marks}</p>
                        </div>
                        <div className="bg-white rounded-lg p-3 text-center">
                          <p className="text-xs text-gray-500">Avg Total</p>
                          <p className="text-xl font-bold text-teal-600">{selectedSubject.avg_total_marks}</p>
                        </div>
                        <div className="bg-white rounded-lg p-3 text-center">
                          <p className="text-xs text-gray-500">Grade Std Dev</p>
                          <p className="text-xl font-bold text-orange-600">{selectedSubject.grade_std_dev}</p>
                        </div>
                      </div>
                      {/* Grade Distribution Bar */}
                      {selectedSubject.grade_distribution && Object.keys(selectedSubject.grade_distribution).length > 0 && (
                        <div>
                          <h4 className="font-semibold text-gray-700 mb-2">Grade Distribution</h4>
                          <ResponsiveContainer width="100%" height={180}>
                            <BarChart data={Object.entries(selectedSubject.grade_distribution).map(([g, c]) => ({ grade: g, count: c })).sort((a,b) => {
                              const order = ['O','A','B','C','D','F'];
                              return order.indexOf(a.grade) - order.indexOf(b.grade);
                            })}>
                              <CartesianGrid strokeDasharray="3 3" />
                              <XAxis dataKey="grade" />
                              <YAxis />
                              <Tooltip />
                              <Bar dataKey="count" name="Students" radius={[4,4,0,0]}>
                                {Object.entries(selectedSubject.grade_distribution).map(([g], i) => (
                                  <Cell key={i} fill={GRADE_COLORS[g] || '#6B7280'} />
                                ))}
                              </Bar>
                            </BarChart>
                          </ResponsiveContainer>
                        </div>
                      )}
                    </div>
                  )}
                </div>
              )}

              {/* Charts Tab */}
              {activeTab === 'charts' && (
                <div className="space-y-6">
                  {/* Difficulty Score Bar Chart */}
                  <div className="bg-white rounded-xl p-5 border border-gray-200 shadow-sm">
                    <h3 className="font-bold text-gray-800 mb-3">All Subjects - Difficulty Score (Higher = Harder)</h3>
                    <ResponsiveContainer width="100%" height={Math.max(300, filteredSubjects.length * 28)}>
                      <BarChart data={filteredSubjects} layout="vertical" margin={{ left: 80 }}>
                        <CartesianGrid strokeDasharray="3 3" />
                        <XAxis type="number" domain={[0, 100]} />
                        <YAxis type="category" dataKey="subject_code" tick={{ fontSize: 11 }} width={80} />
                        <Tooltip
                          content={({ active, payload }) => {
                            if (active && payload?.[0]) {
                              const d = payload[0].payload;
                              return (
                                <div className="bg-white shadow-lg rounded-lg p-3 border text-sm">
                                  <p className="font-bold">{d.subject_code}</p>
                                  <p className="text-gray-500">{d.subject_name}</p>
                                  <p>Difficulty: <span className="font-semibold">{d.difficulty_score}</span></p>
                                  <p>Pass Rate: <span className="text-green-600">{d.pass_rate}%</span></p>
                                  <p>Fail Rate: <span className="text-red-600">{d.fail_rate}%</span></p>
                                </div>
                              );
                            }
                            return null;
                          }}
                        />
                        <Bar dataKey="difficulty_score" radius={[0,4,4,0]}>
                          {filteredSubjects.map((s, i) => (
                            <Cell key={i} fill={DIFFICULTY_COLORS[s.difficulty_level] || '#6B7280'} />
                          ))}
                        </Bar>
                      </BarChart>
                    </ResponsiveContainer>
                  </div>

                  {/* Scatter: Fail Rate vs Avg Grade Point */}
                  <div className="bg-white rounded-xl p-5 border border-gray-200 shadow-sm">
                    <h3 className="font-bold text-gray-800 mb-3">Fail Rate vs Avg Grade Point (bubble size = student count)</h3>
                    <ResponsiveContainer width="100%" height={350}>
                      <ScatterChart margin={{ top: 20, right: 20, bottom: 20, left: 20 }}>
                        <CartesianGrid strokeDasharray="3 3" />
                        <XAxis type="number" dataKey="x" name="Fail Rate %" domain={[0, 100]} />
                        <YAxis type="number" dataKey="y" name="Avg Grade Point" domain={[0, 10]} />
                        <ZAxis type="number" dataKey="z" range={[40, 400]} name="Students" />
                        <Tooltip
                          content={({ active, payload }) => {
                            if (active && payload?.[0]) {
                              const d = payload[0].payload;
                              return (
                                <div className="bg-white shadow-lg rounded-lg p-3 border text-sm">
                                  <p className="font-bold">{d.name}</p>
                                  <p>Fail Rate: {d.x}%</p>
                                  <p>Avg GP: {d.y}</p>
                                  <p>Students: {d.z}</p>
                                  <p>Difficulty: {d.difficulty}</p>
                                </div>
                              );
                            }
                            return null;
                          }}
                        />
                        <Scatter data={scatterData} fill="#F97316" fillOpacity={0.6} />
                      </ScatterChart>
                    </ResponsiveContainer>
                  </div>

                  {/* Pass Rate Comparison Bar */}
                  <div className="bg-white rounded-xl p-5 border border-gray-200 shadow-sm">
                    <h3 className="font-bold text-gray-800 mb-3">Pass Rate by Subject</h3>
                    <ResponsiveContainer width="100%" height={Math.max(300, filteredSubjects.length * 28)}>
                      <BarChart data={filteredSubjects} layout="vertical" margin={{ left: 80 }}>
                        <CartesianGrid strokeDasharray="3 3" />
                        <XAxis type="number" domain={[0, 100]} />
                        <YAxis type="category" dataKey="subject_code" tick={{ fontSize: 11 }} width={80} />
                        <Tooltip />
                        <Bar dataKey="pass_rate" name="Pass Rate %" fill="#22C55E" radius={[0,4,4,0]} />
                      </BarChart>
                    </ResponsiveContainer>
                  </div>
                </div>
              )}

              {/* ML Insights Tab */}
              {activeTab === 'ml' && data?.ml_enabled && (
                <div className="space-y-6">
                  {/* Feature Importances Radar */}
                  <div className="bg-white rounded-xl p-5 border border-gray-200 shadow-sm">
                    <h3 className="font-bold text-gray-800 mb-1">Feature Importances (What drives difficulty?)</h3>
                    <p className="text-xs text-gray-500 mb-3">The Random Forest model learned which factors matter most for predicting pass rates.</p>
                    {featureImpData.length > 0 && (
                      <ResponsiveContainer width="100%" height={350}>
                        <RadarChart data={featureImpData}>
                          <PolarGrid />
                          <PolarAngleAxis dataKey="name" tick={{ fontSize: 11 }} />
                          <PolarRadiusAxis angle={30} domain={[0, 50]} />
                          <Radar name="Importance %" dataKey="value" stroke="#F97316" fill="#F97316" fillOpacity={0.3} />
                          <Tooltip />
                        </RadarChart>
                      </ResponsiveContainer>
                    )}
                  </div>

                  {/* Actual vs Predicted */}
                  <div className="bg-white rounded-xl p-5 border border-gray-200 shadow-sm">
                    <h3 className="font-bold text-gray-800 mb-3">Actual vs ML Predicted Pass Rate</h3>
                    <ResponsiveContainer width="100%" height={350}>
                      <ScatterChart margin={{ top: 20, right: 20, bottom: 20, left: 20 }}>
                        <CartesianGrid strokeDasharray="3 3" />
                        <XAxis type="number" dataKey="actual" name="Actual Pass Rate %" domain={[0, 100]} label={{ value: 'Actual %', position: 'insideBottom', offset: -5 }} />
                        <YAxis type="number" dataKey="predicted" name="Predicted Pass Rate %" domain={[0, 100]} label={{ value: 'Predicted %', angle: -90, position: 'insideLeft' }} />
                        <Tooltip
                          content={({ active, payload }) => {
                            if (active && payload?.[0]) {
                              const d = payload[0].payload;
                              return (
                                <div className="bg-white shadow-lg rounded-lg p-3 border text-sm">
                                  <p className="font-bold">{d.code}</p>
                                  <p>Actual: {d.actual}%</p>
                                  <p>Predicted: {d.predicted}%</p>
                                  <p>Confidence: {d.confidence}</p>
                                </div>
                              );
                            }
                            return null;
                          }}
                        />
                        <Scatter
                          data={data.subjects
                            .filter(s => s.predicted_pass_rate != null)
                            .map(s => ({
                              actual: s.pass_rate,
                              predicted: s.predicted_pass_rate,
                              code: s.subject_code,
                              confidence: s.prediction_confidence,
                            }))}
                          fill="#3B82F6"
                          fillOpacity={0.7}
                        />
                        {/* Perfect prediction line would be diagonal */}
                      </ScatterChart>
                    </ResponsiveContainer>
                    <p className="text-xs text-gray-400 text-center mt-2">Points close to the diagonal indicate accurate predictions.</p>
                  </div>

                  {/* Feature importance table */}
                  <div className="bg-white rounded-xl p-5 border border-gray-200 shadow-sm">
                    <h3 className="font-bold text-gray-800 mb-3">Feature Importance Breakdown</h3>
                    <div className="space-y-2">
                      {featureImpData.sort((a, b) => b.value - a.value).map((f, i) => (
                        <div key={i} className="flex items-center gap-3">
                          <span className="w-48 text-sm text-gray-700 font-medium">{f.name}</span>
                          <div className="flex-1 bg-gray-200 rounded-full h-4">
                            <div
                              className="h-4 rounded-full bg-gradient-to-r from-orange-400 to-orange-600"
                              style={{ width: `${f.value * 2}%` }}
                            />
                          </div>
                          <span className="text-sm font-mono text-gray-600 w-12 text-right">{f.value}%</span>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              )}
            </>
          )}
        </div>
      </div>
    </div>
  );
};

export default SubjectDifficultyAnalyzer;
