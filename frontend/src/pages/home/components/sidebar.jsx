import { faArrowRightFromBracket, faGaugeHigh, faUsersRectangle } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React from "react";
const SideBar = () => {
  return (
    <div className="sidebar bg-white p-20 p-relative">
      <h3 className="p-relative txt-c mt-0">Studify</h3>
      <ul className="list-none p-0">
        <li>
          <a
            className="active d-flex align-center fs-14 c-black rad-6 p-10"
            href="index.html"
          >
            <FontAwesomeIcon icon={faGaugeHigh} />
            <span className="hide-mobile">Dashboard</span>
          </a>
        </li>
        <li>
          <a
            className=" d-flex align-center fs-14 c-black rad-6 p-10"
            href="settings.html"
          >
            <FontAwesomeIcon icon={faUsersRectangle} />
            <span className="hide-mobile">Classes</span>
          </a>
        </li>
        <li>
          <a
            className="d-flex align-center fs-14 c-black rad-6 p-10"
            href="profile.html"
          >
            <FontAwesomeIcon icon={faArrowRightFromBracket} />
            <span className="hide-mobile">Logout</span>
          </a>
        </li>
      </ul>
    </div>
  );
};

export default SideBar;
