import { faBell } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React from "react";

const Header = () => {
  const name = localStorage.getItem("name");
  const profile = localStorage.getItem("profile_image");
  return (
    <div className="head bg-white p-15 between-flex">
      <div className="welcome-widget">Hello {name}</div>
      <div className="icons d-flex align-center">
        <span className=" notification  p-relative ">
          <FontAwesomeIcon icon={faBell} />
        </span>
        <img srcSet={`http://192.168.0.104:8001/storage/${profile}`} alt="" />
      </div>
    </div>
  );
};

export default Header;
