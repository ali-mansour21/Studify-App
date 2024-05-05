import React from "react";
import "../../styles/utilities.css";
import "./styles/index.css";
import SideBar from "./components/sidebar";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faBell } from "@fortawesome/free-solid-svg-icons";

const Home = () => {
  return (
    <div className="page d-flex">
      <SideBar />
      <div className="content  w-full">
        <div className="head bg-white p-15 between-flex">
          <div className="welcome-widget">Hello Ali</div>
          <div className="icons d-flex align-center">
            <span className=" notification  p-relative ">
              <FontAwesomeIcon icon={faBell} />
            </span>
            <img src="profile_image" alt="" />
          </div>
        </div>
      </div>
    </div>
  );
};

export default Home;
