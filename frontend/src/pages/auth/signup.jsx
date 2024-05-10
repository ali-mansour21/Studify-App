import {
  faEnvelope,
  faImage,
  faKey,
  faUser,
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import sendRequest from "../../core/tools/userRequest.js";

import "./styles/signup.css";
import { requestMethods } from "../../core/requests/requestMethods.js";
import { generateToken } from "../../firebase.js";
const SignUp = () => {
  const navigator = useNavigate();
  const [userData, setUserData] = useState({
    name: "",
    email: "",
    password: "",
    profile_image: null,
  });
  const uploadImage = async (e) => {
    const file = e.target.files[0];
    const base64 = await convertBase64(file);
    setUserData({ ...userData, profile_image: base64 });
  };
  const convertBase64 = (file) => {
    return new Promise((resolve, reject) => {
      const fileReader = new FileReader();
      fileReader.readAsDataURL(file);

      fileReader.onload = () => {
        resolve(fileReader.result);
      };

      fileReader.onerror = (error) => {
        reject(error);
      };
    });
  };
  const handleSubmit = async () => {
    const firebaseToken = await generateToken();
    const userDatawithToken = { ...userData, firebase_token: firebaseToken };
    sendRequest(
      requestMethods.POST,
      "instructor_register",
      userDatawithToken
    ).then((response) => {
      console.log(response);
    });
  };
  return (
    <div>
      <div className="signup-container">
        <div className="signup-logo">
          <img src="../src/assets/Studify-logo.png" alt="Logo" />
        </div>
        <h2>Create new account</h2>
        <form
          className="signup-form"
          onSubmit={(e) => {
            e.preventDefault();
            handleSubmit();
          }}
        >
          <div>
            <input
              type="text"
              onChange={(e) => {
                setUserData({ ...userData, name: e.target.value });
              }}
              placeholder="John Doe"
              required
            />
            <FontAwesomeIcon icon={faUser} className="input-icon" />
          </div>
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
            <input type="file" onChange={(e) => uploadImage(e)} required />
            <FontAwesomeIcon icon={faImage} className="input-icon" />
          </div>
          <div>
            <input
              type="password"
              onChange={(e) => {
                setUserData({ ...userData, password: e.target.value });
              }}
              placeholder="Password"
              required
            />
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
