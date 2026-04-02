import api from './api';

const circularService = {
  // Get all circulars (filtered for students, all for admins)
  getCirculars: async () => {
    try {
      const response = await api.get('/circulars/');
      return response.data;
    } catch (error) {
      console.error('Error fetching circulars:', error);
      throw error;
    }
  },

  // Get single circular by ID
  getCircular: async (id) => {
    try {
      const response = await api.get(`/circulars/${id}/`);
      return response.data;
    } catch (error) {
      console.error(`Error fetching circular ${id}:`, error);
      throw error;
    }
  },

  // Create new circular (admin only)
  createCircular: async (formData) => {
    try {
      const response = await api.post('/circulars/', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });
      return response.data;
    } catch (error) {
      console.error('Error creating circular:', error);
      throw error;
    }
  },

  // Update circular (admin only)
  updateCircular: async (id, formData) => {
    try {
      const response = await api.put(`/circulars/${id}/`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });
      return response.data;
    } catch (error) {
      console.error(`Error updating circular ${id}:`, error);
      throw error;
    }
  },

  // Delete circular (admin only)
  deleteCircular: async (id) => {
    try {
      const response = await api.delete(`/circulars/${id}/`);
      return response.data;
    } catch (error) {
      console.error(`Error deleting circular ${id}:`, error);
      throw error;
    }
  },

  // Download circular attachment
  downloadCircularAttachment: async (circularId, filename) => {
    try {
      const response = await api.get(`/circulars/${circularId}/download/`, {
        responseType: 'blob', // Important for file download
      });
      
      // Create a blob URL and trigger download
      const blob = new Blob([response.data]);
      const url = window.URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = filename || 'circular_attachment.pdf';
      document.body.appendChild(link);
      link.click();
      
      // Cleanup
      document.body.removeChild(link);
      window.URL.revokeObjectURL(url);
      
      return { success: true };
    } catch (error) {
      console.error(`Error downloading circular ${circularId}:`, error);
      throw error;
    }
  },
};

export default circularService;
