import React, { useState, useEffect } from "react";
import { studentService } from "../services/resultsService";
import { FaSearch, FaUser, FaTimes } from "react-icons/fa";

const SearchStudentModal = ({ isOpen, onClose, onStudentSelect }) => {
  const [searchQuery, setSearchQuery] = useState("");
  const [searchResults, setSearchResults] = useState([]);
  const [searching, setSearching] = useState(false);
  const [error, setError] = useState("");

  // ESC key handler
  useEffect(() => {
    const handleEscKey = (event) => {
      if (event.key === 'Escape') {
        onClose();
      }
    };
    
    if (isOpen) {
      document.addEventListener('keydown', handleEscKey);
    }
    
    return () => {
      document.removeEventListener('keydown', handleEscKey);
    };
  }, [isOpen, onClose]);

  if (!isOpen) return null;

  const handleSearch = async (e) => {
    e.preventDefault();
    if (!searchQuery.trim()) {
      setError("Please enter a roll number to search");
      return;
    }

    setSearching(true);
    setError("");
    try {
      const data = await studentService.searchStudent(searchQuery);
      setSearchResults(data.students || []);
      if (data.students.length === 0) {
        setError("No students found with this roll number");
      }
    } catch (err) {
      setError(err.response?.data?.error || "Failed to search students");
      setSearchResults([]);
    } finally {
      setSearching(false);
    }
  };

  const handleSelectStudent = (student) => {
    onStudentSelect(student);
    setSearchQuery("");
    setSearchResults([]);
    onClose();
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg shadow-xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="p-6 border-b border-gray-200 flex justify-between items-center sticky top-0 bg-white z-10">
          <div>
            <h2 className="text-2xl font-bold text-gray-900 flex items-center">
              <FaSearch className="mr-2 text-primary-600" />
              Search Student Results
            </h2>
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

        {/* Search Form */}
        <div className="p-6">
          <form onSubmit={handleSearch} className="mb-4">
            <div className="flex gap-2">
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Enter Roll Number (e.g., TEST123)"
                className="flex-1 px-4 py-3 border border-gray-300 rounded-md focus:ring-primary-500 focus:border-primary-500"
                autoFocus
              />
              <button
                type="submit"
                disabled={searching}
                className="bg-primary-600 text-white px-6 py-3 rounded-md hover:bg-primary-700 disabled:bg-gray-400 disabled:cursor-not-allowed flex items-center"
              >
                <FaSearch className="mr-2" />
                {searching ? "Searching..." : "Search"}
              </button>
            </div>
          </form>

          {error && (
            <div className="mb-4 p-3 bg-red-100 text-red-800 rounded-md flex items-center justify-between">
              <span>{error}</span>
              <button onClick={() => setError("")} className="text-red-600 hover:text-red-800">
                <FaTimes />
              </button>
            </div>
          )}

          {searchResults.length > 0 && (
            <div className="bg-white rounded-lg border border-gray-200">
              <div className="p-3 bg-gray-50 border-b border-gray-200">
                <h3 className="font-semibold text-gray-700">Search Results ({searchResults.length})</h3>
              </div>
              <div className="divide-y divide-gray-200 max-h-96 overflow-y-auto">
                {searchResults.map((student, index) => (
                  <div
                    key={index}
                    onClick={() => handleSelectStudent(student)}
                    className="p-4 hover:bg-blue-50 cursor-pointer transition-colors flex items-center justify-between"
                  >
                    <div className="flex items-center">
                      <FaUser className="text-gray-400 mr-3" />
                      <div>
                        <div className="font-semibold text-gray-900">{student.roll_number}</div>
                        <div className="text-sm text-gray-600">{student.student_name}</div>
                        <div className="text-xs text-gray-500">{student.course} - {student.branch}</div>
                      </div>
                    </div>
                    <div className="text-primary-600 text-sm font-medium">
                      View Results →
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="p-6 border-t border-gray-200 bg-gray-50">
          <button
            onClick={onClose}
            className="w-full px-6 py-2 bg-gray-600 text-white rounded-md hover:bg-gray-700 transition-colors"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  );
};

export default SearchStudentModal;
