import { useState, useEffect, useCallback, useRef } from 'react';

const IDLE_TIMEOUT = 60 * 60 * 1000; // 1 hour in milliseconds
const WARNING_TIME = 55 * 60 * 1000; // Show warning at 55 minutes

export const useIdleTimeout = (onIdle, onWarning) => {
  const [isIdle, setIsIdle] = useState(false);
  const [showWarning, setShowWarning] = useState(false);
  const [remainingTime, setRemainingTime] = useState(IDLE_TIMEOUT);
  
  const idleTimerRef = useRef(null);
  const warningTimerRef = useRef(null);
  const countdownIntervalRef = useRef(null);
  const lastActivityRef = useRef(Date.now());

  const resetTimer = useCallback(() => {
    // Clear existing timers
    if (idleTimerRef.current) clearTimeout(idleTimerRef.current);
    if (warningTimerRef.current) clearTimeout(warningTimerRef.current);
    if (countdownIntervalRef.current) clearInterval(countdownIntervalRef.current);

    // Reset state
    setIsIdle(false);
    setShowWarning(false);
    setRemainingTime(IDLE_TIMEOUT);
    lastActivityRef.current = Date.now();

    // Set warning timer (55 minutes)
    warningTimerRef.current = setTimeout(() => {
      setShowWarning(true);
      if (onWarning) onWarning();

      // Start countdown
      countdownIntervalRef.current = setInterval(() => {
        const elapsed = Date.now() - lastActivityRef.current;
        const remaining = IDLE_TIMEOUT - elapsed;
        
        if (remaining <= 0) {
          clearInterval(countdownIntervalRef.current);
        } else {
          setRemainingTime(remaining);
        }
      }, 1000);
    }, WARNING_TIME);

    // Set idle timer (60 minutes)
    idleTimerRef.current = setTimeout(() => {
      setIsIdle(true);
      setShowWarning(false);
      if (onIdle) onIdle();
    }, IDLE_TIMEOUT);
  }, [onIdle, onWarning]);

  const stayActive = useCallback(() => {
    resetTimer();
  }, [resetTimer]);

  useEffect(() => {
    const events = [
      'mousedown',
      'mousemove',
      'keypress',
      'scroll',
      'touchstart',
      'click'
    ];

    const handleActivity = () => {
      if (!showWarning) {
        resetTimer();
      }
    };

    // Add event listeners
    events.forEach(event => {
      document.addEventListener(event, handleActivity);
    });

    // Initial timer setup
    resetTimer();

    // Cleanup
    return () => {
      events.forEach(event => {
        document.removeEventListener(event, handleActivity);
      });
      
      if (idleTimerRef.current) clearTimeout(idleTimerRef.current);
      if (warningTimerRef.current) clearTimeout(warningTimerRef.current);
      if (countdownIntervalRef.current) clearInterval(countdownIntervalRef.current);
    };
  }, [resetTimer, showWarning]);

  return {
    isIdle,
    showWarning,
    remainingTime: Math.ceil(remainingTime / 1000), // Return in seconds
    stayActive,
    resetTimer
  };
};
