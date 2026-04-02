import React from 'react';

/**
 * StatCard - Displays a metric with icon
 * @param {string} title - The metric title (e.g., "Exams Uploaded")
 * @param {number|string} value - The metric value (e.g., 45)
 * @param {ReactNode} icon - Icon component to display
 * @param {string} color - Tailwind color class (e.g., "blue", "green", "purple")
 * @param {string} trend - Optional trend indicator (e.g., "+5 this week")
 */
const StatCard = ({ title, value, icon, color = 'blue', trend }) => {
  const colorClasses = {
    blue: 'text-blue-600 bg-blue-50',
    green: 'text-green-600 bg-green-50',
    purple: 'text-purple-600 bg-purple-50',
    indigo: 'text-indigo-600 bg-indigo-50',
    cyan: 'text-cyan-600 bg-cyan-50',
    orange: 'text-orange-600 bg-orange-50',
    pink: 'text-pink-600 bg-pink-50',
    teal: 'text-teal-600 bg-teal-50',
  };

  const iconColorClass = colorClasses[color] || colorClasses.blue;

  return (
    <div className="bg-white rounded-xl shadow-sm hover:shadow-md transition-all duration-300 p-6 border border-gray-100">
      <div className="flex items-start justify-between">
        <div className="flex-1">
          <p className="text-sm font-medium text-gray-600 mb-1">{title}</p>
          <div className="flex items-baseline gap-2">
            <p className="text-3xl font-bold text-gray-900">{value}</p>
            {trend && (
              <span className="text-xs text-gray-500 font-medium">{trend}</span>
            )}
          </div>
        </div>
        <div className={`p-3 rounded-lg ${iconColorClass}`}>
          <div className="text-2xl">
            {icon}
          </div>
        </div>
      </div>
    </div>
  );
};

export default StatCard;
