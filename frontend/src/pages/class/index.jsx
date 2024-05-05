import React from "react";
import SideBar from "../../components/sidebar";
import "../../styles/utilities.css";
import Header from "../../components/header";

const Home = () => {
  return (
    <div className="page d-flex">
      <SideBar />
      <div className="content w-full">
        <Header />
      </div>
    </div>
  );
};

export default Home;
