import { faBell } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React, { useEffect, useState } from "react";
import { IMAGE_URL } from "../../utilities/config";
import sendAuthRequest from "../core/tools/authRequest";
import { requestMethods } from "../core/requests/requestMethods";

const Header = () => {
  const [notifications, setNotifications] = useState([]);
  const name = localStorage.getItem("name");
  const [isOpen, setIsOpen] = useState(false);
  const profile = localStorage.getItem("profile_image");
  const toggleMenu = () => {
    setIsOpen(!isOpen);
  };
  const getInstructerNotifications = () => {
    sendAuthRequest(requestMethods.GET, "home/notifications").then(
      (response) => {
        if (response.status === 200) {
          console.log(response.data.data);
          setNotifications(response.data.data);
        }
      }
    );
  };
  useEffect(() => {
    getInstructerNotifications();
  }, []);
  return (
    <div className="head bg-white p-15 between-flex">
      <div className="welcome-widget">Hello {name}</div>
      <div className="icons d-flex align-center">
        <span
          onClick={(e) => {
            e.preventDefault();
            toggleMenu();
          }}
          className={`notification ${
            notifications?.length > 0 ? "active" : ""
          } p-relative`}
        >
          <FontAwesomeIcon icon={faBell} />
          {notifications?.length > 0 && <span className="red-dot"></span>}
        </span>
        <img srcSet={`${IMAGE_URL}${profile}`} alt="" />
      </div>
      {isOpen && (
        <div className="notification-list">
          {notifications.length > 0 ? (
            notifications.map((notification, index) => (
              <div key={index} className="notification-item">
                {notification.content}
              </div>
            ))
          ) : (
            <div className="no-notifications">No notifications</div>
          )}
        </div>
      )}
    </div>
  );
};

export default Header;
