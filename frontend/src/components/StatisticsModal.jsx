import React, { useState, useEffect } from 'react';
import { BarChart, Bar, LineChart, Line, PieChart, Pie, Cell, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

const StatisticsModal = ({ statistics, onClose }) => {
  const [activeTab, setActiveTab] = useState('college'); // college or branch
  const [selectedBranch, setSelectedBranch] = useState('');
  const [resultTypeFilter, setResultTypeFilter] = useState('all'); // all, regular, supplementary

  
  // ESC key handler
  useEffect(() => {
    const handleEscKey = (event) => {
      if (event.key === 'Escape') {
        onClose();
      }
    };
    
    document.addEventListener('keydown', handleEscKey);
    
    return () => {
      document.removeEventListener('keydown', handleEscKey);
    };
  }, [onClose]);

  if (!statistics) return null;

  const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042', '#8884D8', '#82CA9D', '#FFC658', '#FF6B6B', '#4ECDC4', '#45B7D1'];

  // College Level Data
  const { college_level, branch_level } = statistics;
  const { summary, regular_stats, supplementary_stats, branch_wise } = college_level;

  // Prepare branch chart data
  const branchChartData = branch_wise.map(branch => ({
    name: branch.branch,
    total: branch.total,
    pass: branch.pass,
    fail: branch.fail,
    passRate: branch.pass_percentage
  }));

  // Prepare branch comparison data (Regular vs Supplementary)
  const branchComparisonData = branch_wise.map(branch => ({
    name: branch.branch,
    regularPass: branch.regular.pass_percentage,
    suppPass: branch.supplementary.pass_percentage
  }));

  // Subject-wise data for selected branch
  const getBranchSubjects = (branch) => {
    return branch_level.subject_wise[branch] || [];
  };

  const allBranches = Object.keys(branch_level.subject_wise);

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg shadow-xl w-full max-w-7xl max-h-[95vh] overflow-y-auto">
        {/* Header */}
        <div className="p-6 border-b border-gray-200 flex justify-between items-center sticky top-0 bg-white z-10">
          <div>
            <h2 className="text-2xl font-bold text-gray-900">📊 Comprehensive Statistics Report</h2>
            {statistics.examName && (
              <p className="text-sm text-gray-600 mt-1">Exam: <span className="font-semibold">{statistics.examName}</span></p>
            )}
            <p className="text-xs text-gray-500 mt-1">Press ESC to close</p>
          </div>
          <button 
            onClick={onClose} 
            className="text-gray-500 hover:text-gray-700 text-3xl font-bold leading-none hover:bg-gray-100 rounded-full w-10 h-10 flex items-center justify-center"
            title="Close (ESC)"
          >
            ×
          </button>
        </div>

        {/* Tabs */}
        <div className="border-b border-gray-200 sticky top-[73px] bg-white z-10">
          <div className="flex px-6">
            <button
              onClick={() => setActiveTab('college')}
              className={`py-3 px-6 font-semibold border-b-2 transition-colors ${
                activeTab === 'college' 
                  ? 'border-blue-600 text-blue-600' 
                  : 'border-transparent text-gray-500 hover:text-gray-700'
              }`}
            >
              🏫 College Level
            </button>
            <button
              onClick={() => setActiveTab('branch')}
              className={`py-3 px-6 font-semibold border-b-2 transition-colors ${
                activeTab === 'branch' 
                  ? 'border-blue-600 text-blue-600' 
                  : 'border-transparent text-gray-500 hover:text-gray-700'
              }`}
            >
              🎓 Branch Level (Subject-wise)
            </button>
          </div>
        </div>

        <div className="p-6 space-y-8">
          {/* COLLEGE LEVEL TAB */}
          {activeTab === 'college' && (
            <>
              {/* Overall Summary Cards */}
              <div>
                <h3 className="text-xl font-bold mb-4">📈 Overall Summary</h3>
                <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
                  <div className="bg-indigo-50 p-4 rounded-lg border border-indigo-300">
                    <p className="text-sm text-gray-600">Total Students</p>
                    <p className="text-3xl font-bold text-indigo-600">{summary.total_students}</p>
                  </div>
                  <div className="bg-purple-50 p-4 rounded-lg border border-purple-200">
                    <p className="text-sm text-gray-600">Total Results</p>
                    <p className="text-3xl font-bold text-purple-600">{summary.total_results}</p>
                  </div>
                  <div className="bg-green-50 p-4 rounded-lg border border-green-200">
                    <p className="text-sm text-gray-600">Pass Count</p>
                    <p className="text-3xl font-bold text-green-600">{summary.pass_count}</p>
                  </div>
                  <div className="bg-red-50 p-4 rounded-lg border border-red-200">
                    <p className="text-sm text-gray-600">Fail Count</p>
                    <p className="text-3xl font-bold text-red-600">{summary.fail_count}</p>
                  </div>
                  <div className="bg-yellow-50 p-4 rounded-lg border border-yellow-200">
                    <p className="text-sm text-gray-600">Pass Rate</p>
                    <p className="text-3xl font-bold text-yellow-600">{summary.pass_percentage}%</p>
                  </div>
                </div>
              </div>

              {/* Regular vs Supplementary */}
              <div>
                <h3 className="text-xl font-bold mb-4">📋 Regular vs Supplementary Breakdown</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  {/* Regular Stats */}
                  <div className="bg-gradient-to-br from-emerald-50 to-emerald-100 p-6 rounded-lg border border-emerald-300">
                    <h4 className="text-lg font-semibold text-emerald-800 mb-4">Regular Exams</h4>
                    <div className="space-y-3">
                      <div className="flex justify-between">
                        <span className="text-gray-700">Total Students:</span>
                        <span className="font-bold text-emerald-900">{regular_stats.total}</span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-gray-700">Passed:</span>
                        <span className="font-bold text-green-600">{regular_stats.pass}</span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-gray-700">Failed:</span>
                        <span className="font-bold text-red-600">{regular_stats.fail}</span>
                      </div>
                      <div className="pt-3 border-t border-blue-300">
                        <div className="flex justify-between items-center">
                          <span className="text-gray-700 font-semibold">Pass Percentage:</span>
                          <span className="text-2xl font-bold text-emerald-600">{regular_stats.pass_percentage}%</span>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Supplementary Stats */}
                  <div className="bg-gradient-to-br from-purple-50 to-purple-100 p-6 rounded-lg border border-purple-300">
                    <h4 className="text-lg font-semibold text-purple-800 mb-4">Supplementary Exams</h4>
                    <div className="space-y-3">
                      <div className="flex justify-between">
                        <span className="text-gray-700">Total Students:</span>
                        <span className="font-bold text-purple-900">{supplementary_stats.total}</span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-gray-700">Passed:</span>
                        <span className="font-bold text-green-600">{supplementary_stats.pass}</span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-gray-700">Failed:</span>
                        <span className="font-bold text-red-600">{supplementary_stats.fail}</span>
                      </div>
                      <div className="pt-3 border-t border-orange-300">
                        <div className="flex justify-between items-center">
                          <span className="text-gray-700 font-semibold">Pass Percentage:</span>
                          <span className="text-2xl font-bold text-purple-600">{supplementary_stats.pass_percentage}%</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              {/* Branch-wise Bar Chart */}
              <div>
                <h3 className="text-xl font-bold mb-4">🎯 Branch-wise Performance</h3>
                <div className="bg-gray-50 p-4 rounded-lg">
                  <ResponsiveContainer width="100%" height={400}>
                    <BarChart data={branchChartData}>
                      <CartesianGrid strokeDasharray="3 3" />
                      <XAxis dataKey="name" />
                      <YAxis />
                      <Tooltip />
                      <Legend />
                      <Bar dataKey="pass" fill="#10B981" name="Pass" />
                      <Bar dataKey="fail" fill="#EF4444" name="Fail" />
                    </BarChart>
                  </ResponsiveContainer>
                </div>
              </div>

              {/* Branch-wise Pass Percentage Comparison */}
              <div>
                <h3 className="text-xl font-bold mb-4">📊 Branch-wise Pass Percentage (Regular vs Supplementary)</h3>
                <div className="bg-gray-50 p-4 rounded-lg">
                  <ResponsiveContainer width="100%" height={400}>
                    <BarChart data={branchComparisonData}>
                      <CartesianGrid strokeDasharray="3 3" />
                      <XAxis dataKey="name" />
                      <YAxis domain={[0, 100]} label={{ value: 'Pass %', angle: -90, position: 'insideLeft' }} />
                      <Tooltip formatter={(value) => `${value}%`} />
                      <Legend />
                      <Bar dataKey="regularPass" fill="#3B82F6" name="Regular" />
                      <Bar dataKey="suppPass" fill="#F59E0B" name="Supplementary" />
                    </BarChart>
                  </ResponsiveContainer>
                </div>
              </div>

              {/* Branch-wise Table - Regular Exams */}
              <div>
                <h3 className="text-xl font-bold mb-4">📋 Branch-wise Detailed Statistics - Regular Exams</h3>
                <div className="overflow-x-auto bg-white border-2 border-emerald-300 rounded-lg">
                  <table className="min-w-full divide-y divide-gray-200">
                    <thead className="bg-emerald-50">
                      <tr>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Branch</th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Total</th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Pass</th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Fail</th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Pass %</th>
                      </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                      {branch_wise.map((branch, idx) => (
                        <tr key={`reg-${idx}`} className="hover:bg-emerald-50">
                          <td className="px-6 py-4 whitespace-nowrap font-semibold text-gray-900">{branch.branch}</td>
                          <td className="px-6 py-4 whitespace-nowrap text-gray-700">{branch.regular.total}</td>
                          <td className="px-6 py-4 whitespace-nowrap text-green-600 font-semibold">{branch.regular.pass}</td>
                          <td className="px-6 py-4 whitespace-nowrap text-red-600 font-semibold">{branch.regular.total - branch.regular.pass}</td>
                          <td className="px-6 py-4 whitespace-nowrap">
                            <span className="px-2 py-1 bg-emerald-100 text-emerald-800 rounded font-semibold">
                              {branch.regular.pass_percentage}%
                            </span>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>

              {/* Branch-wise Table - Supplementary Exams */}
              <div>
                <h3 className="text-xl font-bold mb-4">📋 Branch-wise Detailed Statistics - Supplementary Exams</h3>
                <div className="overflow-x-auto bg-white border-2 border-purple-300 rounded-lg">
                  <table className="min-w-full divide-y divide-gray-200">
                    <thead className="bg-purple-50">
                      <tr>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Branch</th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Total</th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Pass</th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Fail</th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Pass %</th>
                      </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                      {branch_wise.map((branch, idx) => (
                        <tr key={`supp-${idx}`} className="hover:bg-purple-50">
                          <td className="px-6 py-4 whitespace-nowrap font-semibold text-gray-900">{branch.branch}</td>
                          <td className="px-6 py-4 whitespace-nowrap text-gray-700">{branch.supplementary.total}</td>
                          <td className="px-6 py-4 whitespace-nowrap text-green-600 font-semibold">{branch.supplementary.pass}</td>
                          <td className="px-6 py-4 whitespace-nowrap text-red-600 font-semibold">{branch.supplementary.total - branch.supplementary.pass}</td>
                          <td className="px-6 py-4 whitespace-nowrap">
                            <span className="px-2 py-1 bg-purple-100 text-purple-800 rounded font-semibold">
                              {branch.supplementary.pass_percentage}%
                            </span>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </>
          )}

          {/* BRANCH LEVEL TAB */}
          {activeTab === 'branch' && (
            <>
              {/* Branch Selector */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Select Branch:</label>
                <select
                  value={selectedBranch}
                  onChange={(e) => setSelectedBranch(e.target.value)}
                  className="w-full md:w-64 px-4 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                >
                  <option value="">-- Select Branch --</option>
                  {allBranches.map(branch => (
                    <option key={branch} value={branch}>{branch}</option>
                  ))}
                </select>
              </div>

              {selectedBranch && getBranchSubjects(selectedBranch).length > 0 ? (
                <>
                  {/* Subject-wise Pass Rate Chart */}
                  <div>
                    <h3 className="text-xl font-bold mb-4">📚 Subject-wise Pass Percentage - {selectedBranch}</h3>
                    <div className="bg-gray-50 p-4 rounded-lg">
                      <ResponsiveContainer width="100%" height={400}>
                        <BarChart data={getBranchSubjects(selectedBranch)}>
                          <CartesianGrid strokeDasharray="3 3" />
                          <XAxis dataKey="name" angle={0} height={80} tick={{fontSize: 11}} interval={0} />
                          <YAxis domain={[0, 100]} label={{ value: 'Pass %', angle: -90, position: 'insideLeft' }} />
                          <Tooltip formatter={(value) => `${value}%`} />
                          <Legend />
                          <Bar dataKey="pass_percentage" fill="#10B981" name="Overall Pass %" />
                          <Bar dataKey="regular_pass_percentage" fill="#3B82F6" name="Regular Pass %" />
                          <Bar dataKey="supplementary_pass_percentage" fill="#F59E0B" name="Supp Pass %" />
                        </BarChart>
                      </ResponsiveContainer>
                    </div>
                  </div>

                  {/* Subject-wise Table - Regular Exams */}
                  <div>
                    <h3 className="text-xl font-bold mb-4">📋 Subject-wise Detailed Statistics - Regular Exams - {selectedBranch}</h3>
                    <div className="overflow-x-auto bg-white border-2 border-emerald-300 rounded-lg">
                      <table className="min-w-full divide-y divide-gray-200">
                        <thead className="bg-emerald-50">
                          <tr>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Code</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Subject Name</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Total</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Pass</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Fail</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Pass %</th>
                          </tr>
                        </thead>
                        <tbody className="bg-white divide-y divide-gray-200">
                          {getBranchSubjects(selectedBranch).map((subject, idx) => (
                            <tr key={`reg-${idx}`} className="hover:bg-emerald-50">
                              <td className="px-6 py-4 whitespace-nowrap font-semibold text-gray-900">{subject.code}</td>
                              <td className="px-6 py-4 text-gray-700">{subject.name}</td>
                              <td className="px-6 py-4 whitespace-nowrap text-gray-700">{subject.regular_total}</td>
                              <td className="px-6 py-4 whitespace-nowrap text-green-600 font-semibold">{subject.regular_pass}</td>
                              <td className="px-6 py-4 whitespace-nowrap text-red-600 font-semibold">{subject.regular_fail}</td>
                              <td className="px-6 py-4 whitespace-nowrap">
                                <span className="px-2 py-1 bg-emerald-100 text-emerald-800 rounded font-semibold">
                                  {subject.regular_pass_percentage}%
                                </span>
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  </div>

                  {/* Subject-wise Table - Supplementary Exams */}
                  <div>
                    <h3 className="text-xl font-bold mb-4">📋 Subject-wise Detailed Statistics - Supplementary Exams - {selectedBranch}</h3>
                    <div className="overflow-x-auto bg-white border-2 border-purple-300 rounded-lg">
                      <table className="min-w-full divide-y divide-gray-200">
                        <thead className="bg-purple-50">
                          <tr>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Code</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Subject Name</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Total</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Pass</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Fail</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider">Pass %</th>
                          </tr>
                        </thead>
                        <tbody className="bg-white divide-y divide-gray-200">
                          {getBranchSubjects(selectedBranch).map((subject, idx) => (
                            <tr key={`supp-${idx}`} className="hover:bg-purple-50">
                              <td className="px-6 py-4 whitespace-nowrap font-semibold text-gray-900">{subject.code}</td>
                              <td className="px-6 py-4 text-gray-700">{subject.name}</td>
                              <td className="px-6 py-4 whitespace-nowrap text-gray-700">{subject.supplementary_total}</td>
                              <td className="px-6 py-4 whitespace-nowrap text-green-600 font-semibold">{subject.supplementary_pass}</td>
                              <td className="px-6 py-4 whitespace-nowrap text-red-600 font-semibold">{subject.supplementary_fail}</td>
                              <td className="px-6 py-4 whitespace-nowrap">
                                <span className="px-2 py-1 bg-purple-100 text-purple-800 rounded font-semibold">
                                  {subject.supplementary_pass_percentage}%
                                </span>
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  </div>
                </>
              ) : (
                <div className="text-center py-12 text-gray-500">
                  <p>No subject data available for this branch</p>
                </div>
              )}
            </>
          )}
        </div>

        {/* Footer */}
        <div className="p-6 border-t border-gray-200 bg-gray-50">
          <div className="flex justify-end">
            <button
              onClick={onClose}
              className="px-6 py-2 bg-gray-600 text-white rounded-md hover:bg-gray-700 transition-colors"
            >
              Close
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default StatisticsModal;
