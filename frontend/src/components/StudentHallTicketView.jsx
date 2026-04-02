import React, { useState, useEffect } from 'react';
import { FaTicketAlt, FaCalendar, FaClock, FaMapMarkerAlt, FaExclamationCircle } from 'react-icons/fa';
import * as hallTicketService from '../services/hallTicketService';

const StudentHallTicketView = () => {
  const [hallTickets, setHallTickets] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchHallTickets();
  }, []);

  const fetchHallTickets = async () => {
    setLoading(true);
    try {
      const data = await hallTicketService.getMyHallTickets();
      setHallTickets(data);
    } catch (error) {
      setError('No hall tickets found. Please upload your photo and wait for hall tickets to be generated.');
      console.error('Error fetching hall tickets:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Loading hall tickets...</p>
        </div>
      </div>
    );
  }

  if (error || hallTickets.length === 0) {
    return (
      <div className="bg-white rounded-lg shadow-lg p-8">
        <div className="text-center">
          <FaExclamationCircle className="text-6xl text-yellow-500 mx-auto mb-4" />
          <h2 className="text-2xl font-bold text-gray-800 mb-2">No Hall Tickets Available</h2>
          <p className="text-gray-600 mb-6">
            {error || 'Hall tickets have not been generated yet. Please check back later.'}
          </p>
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 text-left max-w-md mx-auto">
            <h3 className="font-semibold text-blue-800 mb-2">Steps to get your hall ticket:</h3>
            <ol className="text-sm text-blue-700 space-y-1 list-decimal list-inside">
              <li>Upload your photo with consent</li>
              <li>Wait for the admin to generate hall tickets</li>
              <li>Your hall ticket will appear here once generated</li>
            </ol>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Important Notice */}
      <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
        <div className="flex items-start gap-3">
          <FaExclamationCircle className="text-yellow-600 text-xl mt-1" />
          <div>
            <h3 className="font-semibold text-yellow-800 mb-1">Important Notice</h3>
            <p className="text-sm text-yellow-700">
              Hall ticket download is restricted to administrators only. You can view your hall ticket details here.
              Please contact your examination office for the printed hall ticket.
            </p>
          </div>
        </div>
      </div>

      {/* Hall Tickets List */}
      {hallTickets.map((ticket) => (
        <div key={ticket.id} className="bg-white rounded-lg shadow-lg overflow-hidden">
          {/* Header */}
          <div className="bg-gradient-to-r from-blue-600 to-blue-800 text-white p-6">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="text-2xl font-bold mb-1">Hall Ticket</h2>
                <p className="text-blue-100">{ticket.exam_details?.exam_name}</p>
              </div>
              <FaTicketAlt className="text-5xl opacity-50" />
            </div>
          </div>

          {/* Content */}
          <div className="p-6">
            {/* Hall Ticket Number */}
            <div className="bg-blue-50 border-2 border-blue-200 rounded-lg p-4 mb-6">
              <p className="text-sm text-blue-600 font-medium mb-1">Hall Ticket Number</p>
              <p className="text-3xl font-bold text-blue-900">{ticket.hall_ticket_number}</p>
            </div>

            {/* Student Details */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
              <div>
                <h3 className="text-lg font-semibold text-gray-800 mb-3">Student Details</h3>
                <div className="space-y-2">
                  <div>
                    <p className="text-sm text-gray-600">Name</p>
                    <p className="font-semibold text-gray-800">{ticket.student_name}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-600">Roll Number</p>
                    <p className="font-semibold text-gray-800">{ticket.roll_number}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-600">Course</p>
                    <p className="font-semibold text-gray-800">
                      {ticket.exam_details?.course_display} - {ticket.exam_details?.branch_display}
                    </p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-600">Year / Semester</p>
                    <p className="font-semibold text-gray-800">
                      Year {ticket.exam_details?.year} - Semester {ticket.exam_details?.semester}
                    </p>
                  </div>
                </div>
              </div>

              <div>
                <h3 className="text-lg font-semibold text-gray-800 mb-3">Exam Details</h3>
                <div className="space-y-2">
                  <div className="flex items-start gap-2">
                    <FaMapMarkerAlt className="text-red-500 mt-1" />
                    <div>
                      <p className="text-sm text-gray-600">Exam Center</p>
                      <p className="font-semibold text-gray-800">{ticket.exam_details?.exam_center}</p>
                    </div>
                  </div>
                  <div className="flex items-start gap-2">
                    <FaClock className="text-blue-500 mt-1" />
                    <div>
                      <p className="text-sm text-gray-600">Reporting Time</p>
                      <p className="font-semibold text-gray-800">{ticket.exam_details?.reporting_time}</p>
                    </div>
                  </div>
                  <div>
                    <p className="text-sm text-gray-600">Status</p>
                    <span className={`inline-block px-3 py-1 rounded-full text-sm font-semibold ${
                      ticket.status === 'generated' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'
                    }`}>
                      {ticket.status.charAt(0).toUpperCase() + ticket.status.slice(1)}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            {/* Exam Schedule */}
            {ticket.exam_details?.subjects && ticket.exam_details.subjects.length > 0 && (
              <div className="mb-6">
                <h3 className="text-lg font-semibold text-gray-800 mb-3 flex items-center gap-2">
                  <FaCalendar className="text-blue-600" />
                  Examination Schedule
                </h3>
                <div className="border rounded-lg overflow-hidden">
                  <table className="w-full">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-4 py-3 text-left text-sm font-semibold text-gray-700">Date</th>
                        <th className="px-4 py-3 text-left text-sm font-semibold text-gray-700">Time</th>
                        <th className="px-4 py-3 text-left text-sm font-semibold text-gray-700">Subject Code</th>
                        <th className="px-4 py-3 text-left text-sm font-semibold text-gray-700">Subject Name</th>
                      </tr>
                    </thead>
                    <tbody>
                      {ticket.exam_details.subjects.map((subject, index) => (
                        <tr key={index} className={index % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                          <td className="px-4 py-3 text-sm text-gray-800">
                            {new Date(subject.exam_date).toLocaleDateString('en-GB', {
                              day: '2-digit',
                              month: 'short',
                              year: 'numeric'
                            })}
                          </td>
                          <td className="px-4 py-3 text-sm text-gray-800">{subject.exam_time}</td>
                          <td className="px-4 py-3 text-sm font-semibold text-gray-800">{subject.subject_code}</td>
                          <td className="px-4 py-3 text-sm text-gray-800">{subject.subject_name}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            )}

            {/* Instructions */}
            {ticket.exam_details?.instructions && (
              <div className="bg-amber-50 border border-amber-200 rounded-lg p-4">
                <h3 className="text-lg font-semibold text-amber-900 mb-2">Instructions</h3>
                <p className="text-sm text-amber-800 whitespace-pre-line">
                  {ticket.exam_details.instructions}
                </p>
              </div>
            )}

            {/* Generated Info */}
            <div className="mt-6 pt-4 border-t text-sm text-gray-500">
              <p>Generated on: {new Date(ticket.generated_at).toLocaleDateString('en-GB', {
                day: '2-digit',
                month: 'long',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
              })}</p>
            </div>
          </div>
        </div>
      ))}

      {/* Additional Instructions */}
      <div className="bg-white rounded-lg shadow p-6">
        <h3 className="text-lg font-semibold text-gray-800 mb-3">General Instructions for Examination</h3>
        <ul className="space-y-2 text-sm text-gray-700">
          <li className="flex items-start gap-2">
            <span className="text-blue-600 font-bold">•</span>
            <span>Candidates must report to the examination center at least 30 minutes before the scheduled time.</span>
          </li>
          <li className="flex items-start gap-2">
            <span className="text-blue-600 font-bold">•</span>
            <span>Bring your original hall ticket (printed copy) and valid photo ID to the examination center.</span>
          </li>
          <li className="flex items-start gap-2">
            <span className="text-blue-600 font-bold">•</span>
            <span>Electronic devices including mobile phones, calculators (unless specified), and smart watches are strictly prohibited.</span>
          </li>
          <li className="flex items-start gap-2">
            <span className="text-blue-600 font-bold">•</span>
            <span>Read all instructions on the question paper carefully before attempting.</span>
          </li>
          <li className="flex items-start gap-2">
            <span className="text-blue-600 font-bold">•</span>
            <span>Use only blue or black ball-point pen for writing answers.</span>
          </li>
          <li className="flex items-start gap-2">
            <span className="text-blue-600 font-bold">•</span>
            <span>Any form of malpractice or use of unfair means will result in cancellation of the examination.</span>
          </li>
        </ul>
      </div>
    </div>
  );
};

export default StudentHallTicketView;
