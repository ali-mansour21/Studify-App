import React from "react";
import "../../styles/utilities.css";
import "./styles/index.css";
import SideBar from "./components/sidebar";

const Home = () => {
  return (
    <div className="page d-flex">
      <SideBar />
    </div>
  );
};

export default Home;
