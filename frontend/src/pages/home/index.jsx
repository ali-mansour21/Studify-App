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
import { BeatLoader } from "react-spinners";

const Home = () => {
  const [homeData, setHomeData] = useState({
    nbOfClasses: 0,
    nbOfStudents: 0,
    submissionRate: 0,
  });
  const [loading, setLoading] = useState(true);
  const [enrolledStudentData, setEnrolledStudentData] = useState({
    labels: [],
    datasets: [],
  });
  const [classRequestData, setClassRequestData] = useState({
    labels: [],
    datasets: [],
  });
  const [sharedMaterialData, setSharedMaterialData] = useState({
    labels: [],
    datasets: [],
  });

  const getHomeData = async () => {
    sendAuthRequest(requestMethods.GET, "home/state").then((response) => {
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
        const enrolledStudentChartData = {
          labels: Object.keys(response?.data.data.nbStudentPerMonth),
          datasets: [
            {
              label: "Total Enrolled Students",
              data: Object.values(response?.data.data.nbStudentPerMonth),
              backgroundColor: "rgba(54, 162, 235, 0.2)",
              borderColor: "rgba(54, 162, 235, 1)",
              borderWidth: 1,
            },
          ],
        };

        const statusColors = {
          pending: "rgba(255, 206, 86, 0.2)", // Yellow
          approved: "rgba(75, 192, 192, 0.2)", // Green
          rejected: "rgba(255, 99, 132, 0.2)", // Red
        };

        const borderColors = {
          pending: "rgba(255, 206, 86, 1)", // Yellow
          approved: "rgba(75, 192, 192, 1)", // Green
          rejected: "rgba(255, 99, 132, 1)", // Red
        };

        // Prepare the chart data
        const classRequestChartData = {
          labels: Object.keys(response?.data.data.classRequestsPerStatus),
          datasets: [
            {
              label: "Class Requests by Status",
              data: Object.values(response?.data.data.classRequestsPerStatus),
              backgroundColor: Object.keys(
                response?.data.data.classRequestsPerStatus
              )?.map((status) => statusColors[status] || "rgba(0, 0, 0, 0.1)"),
              borderColor: Object.keys(
                response?.data.data.classRequestsPerStatus
              )?.map((status) => borderColors[status] || "rgba(0, 0, 0, 1)"),
              borderWidth: 1,
            },
          ],
        };

        const materialSharedChartData = {
          labels: Object.keys(response?.data.data.materialsPerMonth),
          datasets: [
            {
              label: "Materials Shared per Month",
              data: Object.values(response?.data.data.materialsPerMonth),
              backgroundColor: "rgba(75, 192, 192, 0.2)",
              borderColor: "rgba(75, 192, 192, 1)",
              borderWidth: 1,
            },
          ],
        };

        console.log(response?.data.data.classRequestsPerStatus);
        setEnrolledStudentData(enrolledStudentChartData);
        setClassRequestData(classRequestChartData);
        setSharedMaterialData(materialSharedChartData);
        setLoading(false);
      }
    });
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
        {loading ? (
          <BeatLoader
            className="loader"
            color={"#3786a8"}
            loading={loading}
            size={50}
          />
        ) : (
          <>
            <div className="dashboard-page d-grid gap-20 m-20">
              <div className="box bg-white rad-6 p-relative">
                <h2>Total Number of classes</h2>
                <p>{homeData?.nbOfClasses}</p>
              </div>
              <div className="box bg-white rad-6 p-relative">
                <h2>Total Number of students</h2>
                <p>{homeData?.nbOfStudents}</p>
              </div>
              <div className="box bg-white rad-6 p-relative">
                <h2>Total Assignment submission rate</h2>
                <p>{homeData?.submissionRate}</p>
              </div>
            </div>
            <div className="content-flex-container m-20">
              <div className="content-main">
                <EnrolledStudentsChart data={enrolledStudentData} />
              </div>
              <div className="content-sub-container">
                <div className="content-sub">
                  <ClassRequestsChart data={classRequestData} />
                </div>
                <div className="content-sub">
                  <MaterialSharedChart data={sharedMaterialData} />
                </div>
              </div>
            </div>
          </>
        )}
      </div>
    </div>
  );
};

export default Home;
