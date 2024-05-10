import React from "react";
import "../../styles/utilities.css";
import "../../styles/index.css";
import SideBar from "../../components/sidebar";
import Header from "../../components/header";

const Home = () => {
  return (
    <div className="page d-flex">
      <SideBar />
      <div className="content  w-full">
        <Header />
        <h1 className="p-relative">Dashboard</h1>
        <div className="dasboard-page d-grid gap-20 m-20">
          <div className="box  bg-white rad-6 p-relative">
            <h2>Number of classes</h2>
            <p>20</p>
          </div>
          <div className="box  bg-white rad-6 p-relative">
            <h2>Number of classes</h2>
            <p>20</p>
          </div>
          <div className="box  bg-white rad-6 p-relative">
            <h2>Number of classes</h2>
            <p>20</p>
          </div>
          <div className="box  bg-white rad-6 p-relative">
            <h2>Number of classes</h2>
            <p>20</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Home;
