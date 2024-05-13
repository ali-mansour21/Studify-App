import React from "react";
import { Line } from "react-chartjs-2";
const MaterialSharedChart = ({ data }) => {
  return (
    <Line
    className="chart-line"
      data={data}
      options={{
        responsive: true,
        title: {
          display: true,
          text: "Monthly Materials Overview",
          fontSize: 20,
        },
        tooltips: {
          mode: "index",
          intersect: false,
        },
        hover: {
          mode: "nearest",
          intersect: true,
        },
        scales: {
          xAxes: [
            {
              display: true,
              scaleLabel: {
                display: true,
                labelString: "Month",
              },
            },
          ],
          yAxes: [
            {
              display: true,
              scaleLabel: {
                display: true,
                labelString: "Value",
              },
            },
          ],
        },
      }}
    />
  );
};

export default MaterialSharedChart;
