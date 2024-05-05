import React from "react";
import SideBar from "../../components/sidebar";
import "../../styles/utilities.css";
import "../../styles/index.css";
import Header from "../../components/header";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faPlus, faUser } from "@fortawesome/free-solid-svg-icons";

const Home = () => {
  return (
    <div className="page d-flex">
      <SideBar />
      <div className="content w-full">
        <Header />
        <div className="d-flex spacebetween h-50">
          <h1 className="p-relative">Classes</h1>
          <div className="actions d-flex gap-10">
            <button>
              <FontAwesomeIcon icon={faPlus} />
            </button>
            <p>Add</p>
          </div>
        </div>
        <div className="classes-page d-grid gap-20 m-20">
          <div className="class  bg-white rad-6 p-relative">
            <img className="cover" src="./Images/course.jpeg" alt="" />
            <div className="p-20">
              <h4 className="m-0">Mastering Web Design</h4>
              <p className="description c-gray mt-15 fs-14">
                Master the Art Of Web Designing And Mocking, Prototying And
                Creating Web Design Architecture
              </p>
            </div>
            <div className="info p-15 p-relative between-flex">
              <span className="c-gray d-flex align-center gap-10">
                <FontAwesomeIcon icon={faUser} />
                950
              </span>
              <span className="title bg-blue c-white btn-shape">
                Course Info
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Home;
