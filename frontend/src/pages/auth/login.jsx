import React from "react";
import "../../styles/utilities.css";
const Login = () => {
  return (
    <div>
      <div className="signin-container">
        <h2>Sign In</h2>
        <div className="signin-logo">
          <img src="" alt="Logo" />
        </div>
        <form className="signin-form">
          <input type="email" placeholder="Enter your email" required />
          <input type="password" placeholder="Password" required />
          <button type="submit">Sign In</button>
        </form>
        <div className="signup-link">
          New user? <a href="/signup">Sign Up</a>
        </div>
      </div>
    </div>
  );
};

export default Login;
