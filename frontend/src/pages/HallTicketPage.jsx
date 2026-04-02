import React from 'react';
import Navbar from '../components/Navbar';
import HallTicketManagement from '../components/HallTicketManagement';

const HallTicketPage = () => {
  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <HallTicketManagement />
      </div>
    </div>
  );
};

export default HallTicketPage;
