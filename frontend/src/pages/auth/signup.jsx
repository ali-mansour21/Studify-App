import { faEnvelope, faKey, faUser } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React from "react";
import { useNavigate } from "react-router-dom";
import "./styles/signup.css";
const SignUp = () => {
  const navigator = useNavigate();

  return (
    <div>
      <div className="signup-container">
        <div className="signup-logo">
          <img src="../src/assets/Studify-logo.png" alt="Logo" />
        </div>
        <h2>Create new account</h2>
        <form className="signup-form">
          <div>
            <input type="text" placeholder="John Doe" required />
            <FontAwesomeIcon icon={faUser} className="input-icon" />
          </div>
          <div>
            <input type="email" placeholder="john@gmail.com" required />
            <FontAwesomeIcon icon={faEnvelope} className="input-icon" />
          </div>
          <div>
            <input type="password" placeholder="password" required />
            <FontAwesomeIcon icon={faKey} className="input-icon" />
          </div>
          <button type="submit">Sign Up</button>
        </form>
        <div className="signin-link">
          Have an account?{" "}
          <a
            onClick={() => {
              navigator("/");
            }}
          >
            Sign In
          </a>
        </div>
      </div>
    </div>
  );
};

export default SignUp;
