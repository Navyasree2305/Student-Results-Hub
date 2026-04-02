import { useEffect } from 'react';

/**
 * Hook to handle ESC key press
 * @param {Function} onEscape - Callback function to execute when ESC is pressed
 * @param {boolean} isActive - Whether the hook should be active (e.g., modal is open)
 */
const useEscapeKey = (onEscape, isActive = true) => {
  useEffect(() => {
    if (!isActive) return;

    const handleEscape = (event) => {
      if (event.key === 'Escape' || event.keyCode === 27) {
        onEscape();
      }
    };

    document.addEventListener('keydown', handleEscape);

    return () => {
      document.removeEventListener('keydown', handleEscape);
    };
  }, [onEscape, isActive]);
};

export default useEscapeKey;
