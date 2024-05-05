import React from "react";
import SideBar from "../../components/sidebar";
import "../../styles/utilities.css";
import "../../styles/index.css";
import Header from "../../components/header";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faPlus, faUser } from "@fortawesome/free-solid-svg-icons";
import Class from "./components/class";

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
          <Class />
        </div>
      </div>
    </div>
  );
};

export default Home;
