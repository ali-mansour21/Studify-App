import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useDispatch } from "react-redux";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faEnvelope, faKey } from "@fortawesome/free-solid-svg-icons";
import sendRequest from "../../core/tools/userRequest.js";
import { requestMethods } from "../../core/requests/requestMethods.js";
import { setUser } from "../../redux/boarderSlice.js";
import "./styles/login.css";
const Login = () => {
  const dispatch = useDispatch();
  const navigator = useNavigate();
  const [userData, setUserData] = useState({
    email: "",
    password: "",
  });
  const handleLogin = () => {
    sendRequest(requestMethods.POST, "instructor_login", userData).then(
      (response) => {
        if (response.status === 200) {
          console.log(response);
          dispatch(setUser(response.data.user));
          localStorage.setItem("token", response.data.authorization.token);
          navigator("/home");
        }
      }
    );
  };
  return (
    <div>
      <div className="signin-container">
        <div className="signin-logo">
          <img src="../src/assets/Studify-logo.png" alt="Logo" />
        </div>
        <h2>Sign In to your account</h2>
        <form
          className="signin-form"
          onSubmit={(e) => {
            e.preventDefault();
            handleLogin();
          }}
        >
          <div>
            <input
              type="email"
              onChange={(e) => {
                setUserData({ ...userData, email: e.target.value });
              }}
              placeholder="john@gmail.com"
              required
            />
            <FontAwesomeIcon icon={faEnvelope} className="input-icon" />
          </div>
          <div>
            <input
              type="password"
              onChange={(e) => {
                setUserData({ ...userData, password: e.target.value });
              }}
              placeholder="password"
              required
            />
            <FontAwesomeIcon icon={faKey} className="input-icon" />
          </div>
          <button type="submit">Login</button>
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
