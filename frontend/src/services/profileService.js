import api from './api';

export const profileService = {
  getProfile: async () => {
    const response = await api.get('/profile/');
    return response.data;
  },

  updateProfile: async (profileData) => {
    const response = await api.put('/profile/', profileData);
    return response.data;
  },

  uploadPhoto: async (photoFile, consentGiven = true) => {
    const formData = new FormData();
    formData.append('photo', photoFile);
    formData.append('consent_given', consentGiven.toString());
    const response = await api.post('/hall-tickets/photo/upload/', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return response.data;
  },

  getPhoto: async () => {
    const response = await api.get('/hall-tickets/photo/');
    return response.data;
  },
};
