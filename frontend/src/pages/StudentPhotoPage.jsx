import React from 'react';
import Navbar from '../components/Navbar';
import PhotoUpload from '../components/PhotoUpload';
import StudentHallTicketView from '../components/StudentHallTicketView';

const StudentPhotoPage = () => {
  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h1 className="text-3xl font-bold text-gray-800 mb-8">Hall Ticket Portal</h1>
        
        {/* Photo Upload Section */}
        <div className="mb-8">
          <PhotoUpload />
        </div>

        {/* Hall Tickets View Section */}
        <div>
          <h2 className="text-2xl font-bold text-gray-800 mb-4">My Hall Tickets</h2>
          <StudentHallTicketView />
        </div>
      </div>
    </div>
  );
};

export default StudentPhotoPage;
