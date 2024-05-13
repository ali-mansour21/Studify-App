import React, { useEffect, useState } from "react";
import "../../styles/utilities.css";
import "../../styles/index.css";
import SideBar from "../../components/sidebar";
import Header from "../../components/header";
import sendAuthRequest from "../../core/tools/authRequest";
import { requestMethods } from "../../core/requests/requestMethods";
import EnrolledStudentsChart from "./components/EnrolledStudentsChart";
import ClassRequestsChart from "./components/ClassRequestsChart";
import MaterialSharedChart from "./components/MaterialSharedChart";

const Home = () => {
  const [homeData, setHomeData] = useState({
    nbOfClasses: 0,
    nbOfStudents: 0,
    submissionRate: 0,
  });
  const [enrolledStudentData, setEnrolledStudentData] = useState({});
  const [classRequestData, setClassRequestData] = useState({});
  const [sharedMaterialData, setSharedMaterialData] = useState({});
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
  const getChartData = async () => {
    sendAuthRequest(requestMethods.GET, "home/data").then((response) => {
      if (response.status === 200) {
        console.log(response.data.data);
        setEnrolledStudentData(response.data.data.nbStudentPerMonth);
        setClassRequestData(response.data.data.classRequestsPerStatus);
        setSharedMaterialData(response.data.data.materialsPerMonth);
      }
    });
  };
  const data = {
    labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
    datasets: [
      {
        label: "Materials Shared",
        data: [12, 19, 3, 5, 2, 3],
        backgroundColor: ["rgba(255, 99, 132, 0.2)"],
        borderColor: ["rgba(255, 99, 132, 1)"],
        borderWidth: 1,
      },
    ],
  };
  useEffect(() => {
    getHomeData();
    getChartData();
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
            <EnrolledStudentsChart data={data} />
          </div>
          <div className="content-sub-container">
            <div className="content-sub">
              <ClassRequestsChart data={data} />
            </div>
            <div className="content-sub">
              <MaterialSharedChart data={data} />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Home;
