import React from "react";
import SideBar from "../../../components/sidebar";
import Header from "../../../components/header";

const Unit = () => {
  return (
    <div className="page d-flex">
      <SideBar />
       <div className="content w-full">
        <Header />
        </div>
    </div>
  );
};

export default Unit;
