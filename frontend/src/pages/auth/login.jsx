import React from "react";
import { useNavigate } from "react-router-dom";
import "./styles/login.css";
const Login = () => {
  const navigator = useNavigate();
  return (
    <div>
      <div className="signin-container">
        <div className="signin-logo">
          <img src="../src/assets/Studify-logo.png" alt="Logo" />
        </div>
        <h2>Sign In to your account</h2>
        <form className="signin-form">
          <input type="email" placeholder="Enter your email" required />
          <input type="password" placeholder="Password" required />
          <button type="submit">Sign In</button>
        </form>
        <div className="signup-link">
          New user?{" "}
          <a
            onClick={() => {
              navigator("/register");
            }}
          >
            Sign Up
          </a>
        </div>
      </div>
    </div>
  );
};

export default Login;
