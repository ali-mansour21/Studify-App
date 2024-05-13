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
      console.log(response.data.data);
      if (response.status === 200) {
        setHomeData({
          nbOfClasses: response.data.data.nbOfClasses,
          nbOfStudents: response.data.data.nbOfStudents,
          submissionRate: response.data.data.submissionRate,
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
      <div className="content w-full">
        <Header />
        <h1 className="p-relative">Dashboard</h1>
        <div className="dashboard-page d-grid gap-20 m-20">
          <div className="box bg-white rad-6 p-relative">
            <h2>Number of classes</h2>
            <p>{homeData?.nbOfClasses}</p>
          </div>
          <div className="box bg-white rad-6 p-relative">
            <h2>Number of students</h2>
            <p>{homeData?.nbOfStudents}</p>
          </div>
          <div className="box bg-white rad-6 p-relative">
            <h2>Assignment submission rate</h2>
            <p>{homeData?.submissionRate}</p>
          </div>
        </div>
        <div className="content-flex-container m-20">
          <div className="content-main">
            <div>content</div>
          </div>
          <div className="content-sub-container">
            <div className="content-sub">content</div>
            <div className="content-sub">content</div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Home;
