import React, { useState } from 'react';
import { studentService } from '../services/resultsService';
import Toast from './Toast';

const SemesterSummaryTable = ({ studentInfo, semesterSummary, onRefresh }) => {
  const [expandedGroup, setExpandedGroup] = useState(null);
  const [expandedExam, setExpandedExam] = useState(null);
  const [subjectDetails, setSubjectDetails] = useState({});
  const [loading, setLoading] = useState({});
  const [toast, setToast] = useState(null);

  // Group and calculate summary data
  const groupedData = React.useMemo(() => {
    if (!semesterSummary || semesterSummary.length === 0) return [];
    
    const groups = {};
    semesterSummary.forEach(item => {
      const key = `${item.year}-${item.semester}`;
      if (!groups[key]) {
        groups[key] = {
          year: item.year,
          semester: item.semester,
          attempts: [],
          latestAttempt: null
        };
      }
      groups[key].attempts.push(item);
    });
    
    // Sort attempts chronologically (oldest first: January before February)
    Object.values(groups).forEach(group => {
      group.attempts.sort((a, b) => new Date(a.uploaded_at) - new Date(b.uploaded_at));
      group.latestAttempt = group.attempts[group.attempts.length - 1]; // Most recent
    });
    
    return Object.values(groups).sort((a, b) => {
      if (a.year !== b.year) return a.year - b.year;
      return a.semester - b.semester;
    });
  }, [semesterSummary]);

  const toggleGroup = (groupKey) => {
    if (expandedGroup === groupKey) {
      setExpandedGroup(null);
      setExpandedExam(null);
    } else {
      setExpandedGroup(groupKey);
      setExpandedExam(null);
    }
  };

  const toggleExam = async (resultId) => {
    if (expandedExam === resultId) {
      setExpandedExam(null);
      return;
    }

    setExpandedExam(resultId);

    if (!subjectDetails[resultId]) {
      setLoading({ ...loading, [resultId]: true });
      try {
        const data = await studentService.getSemesterSubjects(resultId);
        setSubjectDetails({ ...subjectDetails, [resultId]: data.subjects });
      } catch (error) {
        console.error('Error fetching subject details:', error);
        setToast({ message: 'Failed to load subject details', type: 'error' });
      } finally {
        setLoading({ ...loading, [resultId]: false });
      }
    }
  };

  return (
    <div className="card shadow-sm" style={{ border: 'none', borderRadius: '10px' }}>
      {/* Header */}
      <div className="card-header text-white p-3" style={{ 
        background: 'linear-gradient(135deg, #1e3c72 0%, #2a5298 100%)',
        borderTopLeftRadius: '10px',
        borderTopRightRadius: '10px'
      }}>
        <h5 className="mb-2" style={{ fontWeight: '600' }}>
          STUDENT RESULTS HISTORY
        </h5>
        {studentInfo && (
          <div style={{ fontSize: '0.95rem', opacity: '0.95' }}>
            <strong>{studentInfo.roll_number}</strong> | {studentInfo.student_name} | {studentInfo.course} - {studentInfo.branch}
          </div>
        )}
      </div>

      <div className="card-body p-0">
        {groupedData && groupedData.length > 0 ? (
          <div className="table-responsive">
            <table className="table table-bordered mb-0" style={{ width: '100%' }}>
              {/* Main Table Header */}
              <thead style={{ 
                background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
                color: 'white'
              }}>
                <tr>
                  <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>YEAR</th>
                  <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>SEMESTER</th>
                                    <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>TOTAL MARKS</th>
                  <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>SGPA</th>
                  <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>RESULT</th>
                  <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>PENDING</th>
                                    <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>ACTION</th>
                </tr>
              </thead>
              <tbody>
                {groupedData.map((group, groupIdx) => {
                  const groupKey = `${group.year}-${group.semester}`;
                  const isExpanded = expandedGroup === groupKey;
                  const latest = group.latestAttempt;
                  
                  return (
                    <React.Fragment key={groupKey}>
                      {/* Main Row */}
                      <tr 
                        style={{ 
                          cursor: 'pointer',
                          backgroundColor: isExpanded ? '#e3f2fd' : (groupIdx % 2 === 0 ? '#f8f9fa' : 'white'),
                          transition: 'all 0.2s ease'
                        }}
                        onClick={() => toggleGroup(groupKey)}
                        onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#e3f2fd'}
                        onMouseLeave={(e) => e.currentTarget.style.backgroundColor = isExpanded ? '#e3f2fd' : (groupIdx % 2 === 0 ? '#f8f9fa' : 'white')}
                      >
                        <td className="text-center align-middle py-3" style={{ fontWeight: '600' }}>
                          {group.year}
                        </td>
                        <td className="text-center align-middle py-3" style={{ fontWeight: '600' }}>
                          {group.semester}
                        </td>
                                                <td className="text-center align-middle py-3">
                          <strong style={{ color: '#1976d2' }}>
                            {latest.total_marks || 'N/A'}
                          </strong>
                        </td>
                        <td className="text-center align-middle py-3">
                          <strong style={{ color: '#1976d2' }}>
                            {latest.sgpa ? latest.sgpa.toFixed(2) : 'N/A'}
                          </strong>
                        </td>
                        <td className="text-center align-middle py-3">
                          <span className={`badge ${latest.overall_result === 'Pass' ? 'bg-success' : 'bg-danger'}`}>
                            {latest.overall_result}
                          </span>
                        </td>
                        <td className="text-center align-middle py-3">
                          <span className={`badge ${latest.pending_subjects > 0 ? 'bg-warning text-dark' : 'bg-success'}`}>
                            {latest.pending_subjects}
                          </span>
                        </td>
                                                <td className="text-center align-middle py-3">
                          <button className="btn btn-sm btn-primary" style={{ fontWeight: '500' }}>
                            {isExpanded ? '▲ HIDE' : '▼ VIEW'}
                          </button>
                        </td>
                      </tr>

                      {/* Expanded Attempts Section */}
                      {isExpanded && (
                        <tr>
                          <td colSpan="7" className="p-0" style={{ backgroundColor: '#f0f4f8' }}>
                            <div className="p-3">
                              <h6 className="mb-3" style={{ 
                                color: '#1e3c72', 
                                fontWeight: '600',
                                textTransform: 'uppercase'
                              }}>
                                Exam Attempts - Year {group.year} Semester {group.semester}
                              </h6>
                              
                              {/* Attempts Table */}
                              <div className="table-responsive">
                                <table className="table table-bordered mb-0 bg-white" style={{ width: '100%' }}>
                                  <thead style={{ 
                                    background: 'linear-gradient(135deg, #4a90e2 0%, #357abd 100%)',
                                    color: 'white'
                                  }}>
                                    <tr>
                                      <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>ATTEMPT</th>
                                      <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>EXAM NAME</th>
                                                                            <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>TOTAL MARKS</th>
                                      <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>SGPA</th>
                                      <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>RESULT</th>
                                      <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>PENDING</th>
                                      <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>DATE</th>
                                      <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>ACTION</th>
                                    </tr>
                                  </thead>
                                  <tbody>
                                    {group.attempts.map((attempt, index) => (
                                      <React.Fragment key={attempt.result_id}>
                                        <tr style={{ backgroundColor: index % 2 === 0 ? '#f8f9fa' : 'white' }}>
                                          <td className="text-center align-middle py-3">
                                            <span className="badge bg-dark">#{index + 1}</span>
                                          </td>
                                          <td className="text-center align-middle py-3" style={{ fontWeight: '500', whiteSpace: 'normal', wordWrap: 'break-word', maxWidth: '300px' }}>
                                            {attempt.exam_name}
                                          </td>
                                          <td className="text-center align-middle py-3">
                                            <strong style={{ color: '#1976d2' }}>
                                              {attempt.total_marks || 'N/A'}
                                            </strong>
                                          </td>
                                          <td className="text-center align-middle py-3">
                                            <strong style={{ color: '#1976d2' }}>
                                              {attempt.sgpa ? attempt.sgpa.toFixed(2) : 'N/A'}
                                            </strong>
                                          </td>
                                          <td className="text-center align-middle py-3">
                                            <span className={`badge ${attempt.overall_result === 'Pass' ? 'bg-success' : 'bg-danger'}`}>
                                              {attempt.overall_result}
                                            </span>
                                          </td>
                                          <td className="text-center align-middle py-3">
                                            <span className={`badge ${attempt.pending_subjects > 0 ? 'bg-warning text-dark' : 'bg-success'}`}>
                                              {attempt.pending_subjects}
                                            </span>
                                          </td>
                                          <td className="text-center align-middle py-3">
                                            {new Date(attempt.uploaded_at).toLocaleDateString('en-IN', { 
                                              day: '2-digit',
                                              month: 'short',
                                              year: 'numeric'
                                            })}
                                          </td>
                                          <td className="text-center align-middle py-3">
                                            <button
                                              className="btn btn-sm btn-info"
                                              onClick={(e) => {
                                                e.stopPropagation();
                                                toggleExam(attempt.result_id);
                                              }}
                                              style={{ fontWeight: '500' }}
                                            >
                                              {expandedExam === attempt.result_id ? 'HIDE' : 'VIEW'}
                                            </button>
                                          </td>
                                        </tr>

                                        {/* Subject Details */}
                                        {expandedExam === attempt.result_id && (
                                          <tr>
                                            <td colSpan="8" className="p-3" style={{ backgroundColor: '#ffffff' }}>
                                              {loading[attempt.result_id] ? (
                                                <div className="text-center py-3">
                                                  <div className="spinner-border text-primary" role="status">
                                                    <span className="visually-hidden">Loading...</span>
                                                  </div>
                                                  <p className="mt-3 text-muted">Loading subject details...</p>
                                                </div>
                                              ) : subjectDetails[attempt.result_id] ? (
                                                <div>
                                                  <h6 className="mb-3" style={{ 
                                                    color: '#1e3c72', 
                                                    fontWeight: '600',
                                                    textTransform: 'uppercase'
                                                  }}>
                                                    Subject-wise Performance - {attempt.exam_name}
                                                  </h6>
                                                  <div className="table-responsive">
                                                    <table className="table table-bordered mb-0" style={{ width: '100%' }}>
                                                      <thead style={{ 
                                                        background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
                                                        color: 'white'
                                                      }}>
                                                        <tr>
                                                          <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>SUBJECT CODE</th>
                                                          <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>SUBJECT NAME</th>
                                                          <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>CREDITS</th>
                                                          <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>TOTAL MARKS</th>
                                                          <th className="text-center align-middle py-3" style={{ fontWeight: '600' }}>GRADE</th>
                                                          </tr>
                                                      </thead>
                                                      <tbody>
                                                        {subjectDetails[attempt.result_id].map((subject, idx) => (
                                                          <tr key={subject.id} style={{ 
                                                            backgroundColor: idx % 2 === 0 ? '#f8f9fa' : 'white'
                                                          }}>
                                                            <td className="text-center align-middle py-3">
                                                              <strong>{subject.subject_code}</strong>
                                                            </td>
                                                            <td className="text-center align-middle py-3" style={{ fontWeight: '500' }}>
                                                              {subject.subject_name}
                                                            </td>
                                                            <td className="text-center align-middle py-3">
                                                              <strong style={{ color: '#28a745' }}>
                                                                {subject.credits ?? '-'}
                                                              </strong>
                                                            </td>
                                                            <td className="text-center align-middle py-3">
                                                              <strong style={{ color: '#1976d2' }}>
                                                                {subject.total_marks ?? '-'}
                                                              </strong>
                                                            </td>
                                                            <td className="text-center align-middle py-3">
                                                              <strong>{subject.grade || '-'}</strong>
                                                            </td>
                                                                                                                      </tr>
                                                        ))}
                                                      </tbody>
                                                    </table>
                                                  </div>
                                                </div>
                                              ) : (
                                                <div className="alert alert-warning mb-0">
                                                  No subject details available
                                                </div>
                                              )}
                                            </td>
                                          </tr>
                                        )}
                                      </React.Fragment>
                                    ))}
                                  </tbody>
                                </table>
                              </div>
                            </div>
                          </td>
                        </tr>
                      )}
                    </React.Fragment>
                  );
                })}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="text-center py-5 text-muted">
            <div style={{ fontSize: '3rem', opacity: '0.3' }}>📋</div>
            <p className="mt-3">No semester data available</p>
          </div>
        )}
      </div>
      
      {toast && (
        <Toast
          message={toast.message}
          type={toast.type}
          onClose={() => setToast(null)}
        />
      )}
    </div>
  );
};

export default SemesterSummaryTable;
