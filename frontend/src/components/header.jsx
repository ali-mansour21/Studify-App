import { faBell } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React from "react";

const Header = () => {
  return (
    <div className="head bg-white p-15 between-flex">
      <div className="welcome-widget">Hello Ali</div>
      <div className="icons d-flex align-center">
        <span className=" notification  p-relative ">
          <FontAwesomeIcon icon={faBell} />
        </span>
        <img src="profile_image" alt="" />
      </div>
    </div>
  );
};

export default Header;
