import React from "react";
const SideBar = () => {
  return (
    <div className="sidebar bg-white p-20 p-relative">
      <h3 className="p-relative txt-c mt-0">Ali</h3>
      <ul className="list-none p-0">
        <li>
          <a
            className="active d-flex align-center fs-14 c-black rad-6 p-10"
            href="index.html"
          >
            <i className="fa-solid fa-chart-simple fa-fw"></i>
            <span className="hide-mobile">Dashboard</span>
          </a>
        </li>
        <li>
          <a
            className=" d-flex align-center fs-14 c-black rad-6 p-10"
            href="settings.html"
          >
            <i className="fa-solid fa-gear fa-fw"></i>
            <span className="hide-mobile">Settings</span>
          </a>
        </li>
        <li>
          <a
            className="d-flex align-center fs-14 c-black rad-6 p-10"
            href="profile.html"
          >
            <i className="fa-solid fa-user fa-fw"></i>
            <span className="hide-mobile">Profile</span>
          </a>
        </li>
        <li>
          <a
            className=" d-flex align-center fs-14 c-black rad-6 p-10"
            href="projects.html"
          >
            <i className="fa-solid fa-diagram-project fa-fw"></i>
            <span className="hide-mobile">Project</span>
          </a>
        </li>
        <li>
          <a
            className=" d-flex align-center fs-14 c-black rad-6 p-10"
            href="courses.html"
          >
            <i className="fa-solid fa-book-open fa-fw"></i>
            <span className="hide-mobile">Courses</span>
          </a>
        </li>
        <li>
          <a
            className=" d-flex align-center fs-14 c-black rad-6 p-10"
            href="freinds.html"
          >
            <i className="fa-solid fa-user-group fa-fw"></i>
            <span className="hide-mobile">Freinds</span>
          </a>
        </li>
        <li>
          <a
            className=" d-flex align-center fs-14 c-black rad-6 p-10"
            href="files.html"
          >
            <i className="fa-solid fa-file fa-fw"></i>
            <span className="hide-mobile">Files</span>
          </a>
        </li>
        <li>
          <a
            className=" d-flex align-center fs-14 c-black rad-6 p-10"
            href="plans.html"
          >
            <i className="fa-solid fa-layer-group fa-fw"></i>
            <span className="hide-mobile">Plans</span>
          </a>
        </li>
      </ul>
    </div>
  );
};

export default SideBar;
