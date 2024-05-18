import React from "react";
import { Doughnut } from "react-chartjs-2";
import { Chart as ChartJS } from "chart.js/auto";

const ClassRequestsChart = ({ data }) => {
  return (
    <Doughnut
      data={data}
      options={{
        responsive: true,
        maintainAspectRatio: false,
        cutoutPercentage: 50,
        plugins: {
          title: {
            display: true,
            text: "Total Materials Shared by Month",
          },
          legend: {
            display: false,
            position: "right",
          },
        },
      }}
    />
  );
};

export default ClassRequestsChart;
