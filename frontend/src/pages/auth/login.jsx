import React from "react";
import { useNavigate } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faEnvelope, faKey } from "@fortawesome/free-solid-svg-icons";
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
          <div>
            <input type="email" placeholder="john@gmail.com" required />
            <FontAwesomeIcon icon={faEnvelope} className="input-icon" />
          </div>
          <div>
            <input type="password" placeholder="password" required />
            <FontAwesomeIcon icon={faKey} className="input-icon" />
          </div>
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
