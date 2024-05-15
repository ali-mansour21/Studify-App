import {
  faArrowRightFromBracket,
  faGaugeHigh,
  faUsersRectangle,
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React from "react";
import { useNavigate, useLocation } from "react-router-dom";
import { requestMethods } from "../core/requests/requestMethods.js";
import sendAuthRequest from "../core/tools/authRequest.js";
const SideBar = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const pathname = location.pathname;
  const routeName = pathname.substring(1);
  const handleLogout = () => {
    sendAuthRequest(requestMethods.POST, "instructor_logout").then(
      (response) => {
        if (response.status === 200) {
          localStorage.removeItem("token");
          localStorage.removeItem("name");
          localStorage.removeItem("profile_image");
          navigate("/");
        }
      }
    );
  };
  return (
    <div className="sidebar bg-white p-20 p-relative">
      <h3 className="p-relative txt-c mt-0">Studify</h3>
      <ul className="list-none p-0">
        <li>
          <a
            className={`${
              routeName === "home" ? "active" : ""
            } d-flex align-center fs-14 c-black rad-6 p-10 `}
            onClick={() => {
              navigate("/home");
            }}
          >
            <FontAwesomeIcon icon={faGaugeHigh} />
            <span className="hide-mobile">Dashboard</span>
          </a>
        </li>
        <li>
          <a
            className={`${
              pathname === "/classes" || pathname.startsWith("/materials/")
                ? "active"
                : ""
            } d-flex align-center fs-14 c-black rad-6 p-10`}
            onClick={() => {
              navigate("/classes");
            }}
          >
            <FontAwesomeIcon icon={faUsersRectangle} />
            <span className="hide-mobile">Classes</span>
          </a>
        </li>
        <li>
          <a
            className="d-flex align-center fs-14 c-black rad-6 p-10"
            onClick={(e) => {
              e.preventDefault();
              handleLogout();
            }}
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
