import "./App.css";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Login from "../src/pages/auth/login.jsx";
import SignUp from "../src/pages/auth/signup.jsx";
import Home from "./pages/home/index.jsx";
import ClassHome from "./pages/class/index.jsx";
import { useEffect } from "react";
import { generateToken } from "../src/firebase.js";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import Materials from "./pages/class/components/Materials.jsx";
import Unit from "./pages/class/components/Unit.jsx";
function App() {
  const token = localStorage.getItem("token");
  useEffect(() => {
    generateToken();
  }, []);
  return (
    <>
      <ToastContainer />
      <Router>
        <Routes>
          <Route path="/" element={<Login />} />
          <Route path="/register" element={<SignUp />} />
        </Routes>
        {token && (
          <Routes>
            <Route path="/home" element={<Home />} />
            <Route path="/classes" element={<ClassHome />} />
            <Route path="/materials/:id" element={<Materials />} />
            <Route path="/materials/data/:id" element={<Unit />} />
          </Routes>
        )}
      </Router>
    </>
  );
}

export default App;
