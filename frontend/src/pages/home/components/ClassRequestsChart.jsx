import React from "react";
import { Doughnut } from "react-chartjs-2";
const ClassRequestsChart = ({ data }) => {
  return (
    <Doughnut
      data={data}
      options={{
        responsive: true,
        maintainAspectRatio: false,
        cutoutPercentage: 50, // This defines the thickness of the donut ring
        legend: {
          position: "top",
        },
        title: {
          display: true,
          text: "Materials Shared by Month",
        },
      }}
    />
  );
};

export default ClassRequestsChart;
