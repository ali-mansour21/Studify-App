import React from "react";
import { Doughnut } from "react-chartjs-2";
const ClassRequestsChart = ({ data }) => {
  return (
    <Doughnut
      data={data}
      options={{
        responsive: true,
        maintainAspectRatio: false,
        cutoutPercentage: 50,
        title: {
          display: true,
          text: "Materials Shared by Month",
        },
      }}
    />
  );
};

export default ClassRequestsChart;
