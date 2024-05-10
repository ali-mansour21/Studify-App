import "./App.css";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Login from "../src/pages/auth/login.jsx";
import SignUp from "../src/pages/auth/signup.jsx";
import Home from "./pages/home/index.jsx";
import ClassHome from "./pages/class/index.jsx";
import { useEffect } from "react";
import { generateToken } from "../src/firebase.js";
function App() {
  useEffect(() => {
    generateToken();
  }, []);
  return (
    <>
      <Router>
        <Routes>
          <Route path="/" element={<Login />} />
          <Route path="/register" element={<SignUp />} />
          <Route path="/home" element={<Home />} />
          <Route path="/classes" element={<ClassHome />} />
        </Routes>
      </Router>
    </>
  );
}

export default App;
