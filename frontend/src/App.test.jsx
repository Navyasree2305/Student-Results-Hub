import React from "react";

function AppTest() {
  return (
    <div style={{
      minHeight: "100vh",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
      backgroundColor: "#f0f9ff",
      flexDirection: "column",
      gap: "20px"
    }}>
      <h1 style={{ fontSize: "3rem", color: "#0284c7" }}>SPMVV SOET Exam Results</h1>
      <p style={{ fontSize: "1.5rem", color: "#075985" }}>Application is loading successfully!</p>
      <div style={{
        padding: "20px",
        backgroundColor: "white",
        borderRadius: "10px",
        boxShadow: "0 4px 6px rgba(0,0,0,0.1)"
      }}>
        <p style={{ color: "#059669" }}>✓ React is rendering correctly</p>
        <p style={{ color: "#059669" }}>✓ CSS is loading properly</p>
        <p style={{ color: "#059669" }}>✓ Frontend container is running</p>
      </div>
    </div>
  );
}

export default AppTest;
