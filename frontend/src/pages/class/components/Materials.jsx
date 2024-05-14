import React from "react";
import "../../../styles/utilities.css";
import { useParams } from "react-router-dom";
import "../../../styles/index.css";
import SideBar from "../../../components/sidebar";
import Header from "../../../components/header";
const Materials = () => {
  const { id } = useParams();
  console.log(typeof id);
  return (
    <div className="page d-flex">
      <SideBar />
      <div className="content w-full">
        <Header />
      </div>
    </div>
  );
};

export default Materials;
