import { faEnvelope, faKey } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import React from 'react'

const SignUp = () => {
  return (
    <div>
      <div className="signup-container">
        <div className="signup-logo">
          <img src="../src/assets/Studify-logo.png" alt="Logo" />
        </div>
        <h2>Sign In to your account</h2>
        <form className="signup-form">
          <div>
            <input type="email" placeholder="Enter your email" required />
            <FontAwesomeIcon icon={faEnvelope} className="input-icon" />
          </div>
          <div>
            <input type="password" placeholder="Password" required />
            <FontAwesomeIcon icon={faKey} className="input-icon" />
          </div>
          <button type="submit">Sign In</button>
        </form>
        <div className="signin-link">
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
}

export default SignUp