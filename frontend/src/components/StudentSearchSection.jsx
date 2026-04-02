import React, { useState } from "react";
import { studentService } from "../services/resultsService";
import { FaSearch, FaUser } from "react-icons/fa";

const StudentSearchSection = ({ onStudentSelect }) => {
  const [searchQuery, setSearchQuery] = useState("");
  const [searchResults, setSearchResults] = useState([]);
  const [searching, setSearching] = useState(false);
  const [error, setError] = useState("");

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
  };

  return (
    <div className="card">
      <h2 className="text-xl font-bold mb-4 flex items-center">
        <FaSearch className="mr-2" />
        Search Student Results
      </h2>
      
      <form onSubmit={handleSearch} className="mb-4">
        <div className="flex gap-2">
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Enter Roll Number (e.g., TEST123)"
            className="flex-1 px-4 py-2 border border-gray-300 rounded-md focus:ring-primary-500 focus:border-primary-500"
          />
          <button
            type="submit"
            disabled={searching}
            className="bg-primary-600 text-white px-6 py-2 rounded-md hover:bg-primary-700 disabled:bg-gray-400 disabled:cursor-not-allowed flex items-center"
          >
            <FaSearch className="mr-2" />
            {searching ? "Searching..." : "Search"}
          </button>
        </div>
      </form>

      {error && (
        <div className="mb-4 p-3 bg-red-100 text-red-800 rounded-md">
          {error}
        </div>
      )}

      {searchResults.length > 0 && (
        <div className="bg-white rounded-lg border border-gray-200">
          <div className="p-3 bg-gray-50 border-b border-gray-200">
            <h3 className="font-semibold text-gray-700">Search Results ({searchResults.length})</h3>
          </div>
          <div className="divide-y divide-gray-200">
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
  );
};

export default StudentSearchSection;

