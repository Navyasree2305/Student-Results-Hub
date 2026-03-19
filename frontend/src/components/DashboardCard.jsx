import React from 'react';
import { FaChevronRight } from 'react-icons/fa';

/**
 * DashboardCard - Clickable action card for admin dashboard
 * @param {string} title - Card title
 * @param {string} description - Brief description of the action
 * @param {ReactNode} icon - Icon component to display
 * @param {function} onClick - Click handler
 * @param {string} color - Tailwind color class (e.g., "blue", "indigo", "purple")
 * @param {ReactNode} footer - Optional footer content (e.g., "Download Template" link)
 * @param {string} badge - Optional badge text (e.g., "12 active")
 */
const DashboardCard = ({ 
  title, 
  description, 
  icon, 
  onClick, 
  color = 'blue', 
  footer,
  badge 
}) => {
  const colorClasses = {
    blue: {
      icon: 'from-blue-500 to-blue-600',
      hover: 'hover:border-blue-200 hover:shadow-blue-100',
      badge: 'bg-blue-100 text-blue-700'
    },
    indigo: {
      icon: 'from-indigo-500 to-indigo-600',
      hover: 'hover:border-indigo-200 hover:shadow-indigo-100',
      badge: 'bg-indigo-100 text-indigo-700'
    },
    purple: {
      icon: 'from-purple-500 to-purple-600',
      hover: 'hover:border-purple-200 hover:shadow-purple-100',
      badge: 'bg-purple-100 text-purple-700'
    },
    cyan: {
      icon: 'from-cyan-500 to-cyan-600',
      hover: 'hover:border-cyan-200 hover:shadow-cyan-100',
      badge: 'bg-cyan-100 text-cyan-700'
    },
    teal: {
      icon: 'from-teal-500 to-teal-600',
      hover: 'hover:border-teal-200 hover:shadow-teal-100',
      badge: 'bg-teal-100 text-teal-700'
    },
    green: {
      icon: 'from-green-500 to-green-600',
      hover: 'hover:border-green-200 hover:shadow-green-100',
      badge: 'bg-green-100 text-green-700'
    },
  };

  const colors = colorClasses[color] || colorClasses.blue;

  return (
    <div
      onClick={onClick}
      className={`
        bg-white rounded-xl shadow-sm border border-gray-200 
        ${colors.hover}
        transition-all duration-300 cursor-pointer 
        hover:shadow-lg hover:-translate-y-1
        p-6 flex flex-col h-full
      `}
    >
      {/* Header with Icon and Badge */}
      <div className="flex items-start justify-between mb-4">
        <div className={`p-3 rounded-lg bg-gradient-to-br ${colors.icon} text-white shadow-md`}>
          <div className="text-2xl">
            {icon}
          </div>
        </div>
        {badge && (
          <span className={`px-3 py-1 rounded-full text-xs font-semibold ${colors.badge}`}>
            {badge}
          </span>
        )}
      </div>

      {/* Content */}
      <div className="flex-1">
        <h3 className="text-lg font-bold text-gray-900 mb-2 flex items-center justify-between">
          {title}
          <FaChevronRight className="text-gray-400 text-sm" />
        </h3>
        <p className="text-sm text-gray-600 leading-relaxed">
          {description}
        </p>
      </div>

      {/* Footer */}
      {footer && (
        <div className="mt-4 pt-4 border-t border-gray-100">
          {footer}
        </div>
      )}
    </div>
  );
};

export default DashboardCard;
