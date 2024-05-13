import React, { useEffect, useState } from "react";
import "../../styles/utilities.css";
import "../../styles/index.css";
import SideBar from "../../components/sidebar";
import Header from "../../components/header";
import sendAuthRequest from "../../core/tools/authRequest";
import { requestMethods } from "../../core/requests/requestMethods";

const Home = () => {
  const [homeData, setHomeData] = useState({
    nbOfClasses: 0,
    nbOfStudents: 0,
    submissionRate: 0,
  });
  const getHomeData = async () => {
    sendAuthRequest(requestMethods.GET, "home/state").then((response) => {
      console.log(response);
      if (response.status === 200) {
        setHomeData({
          nbOfClasses: response.data.nbOfClasses,
          nbOfStudents: response.data.nbOfStudents,
          submissionRate: response.data.submissionRate,
        });
      }
    });
  };
  useEffect(() => {
    getHomeData();
  }, []);
  return (
    <div className="page d-flex">
      <SideBar />
      <div className="content  w-full">
        <Header />
        <h1 className="p-relative">Dashboard</h1>
        <div className="dasboard-page d-grid gap-20 m-20">
          <div className="box  bg-white rad-6 p-relative">
            <h2>Number of classes</h2>
            <p>20</p>
          </div>
          <div className="box  bg-white rad-6 p-relative">
            <h2>Number of classes</h2>
            <p>20</p>
          </div>
          <div className="box  bg-white rad-6 p-relative">
            <h2>Number of classes</h2>
            <p>20</p>
          </div>
          <div className="box  bg-white rad-6 p-relative">
            <h2>Number of classes</h2>
            <p>20</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Home;
