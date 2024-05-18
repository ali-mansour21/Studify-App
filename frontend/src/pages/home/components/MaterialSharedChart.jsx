import React from "react";
import { Line } from "react-chartjs-2";
import { Chart as ChartJS } from "chart.js/auto";

const MaterialSharedChart = ({ data }) => {
  return (
    <Line
      className="chart-line"
      data={data}
      options={{
        responsive: true,
        plugins: {
          title: {
            display: true,
            text: "Total Monthly Materials Overview",
            fontSize: 20,
          },
          legend: {
            display: false,
            position: "right",
            labels: {
              boxWidth: 20,
              fontSize: 15,
            },
          },
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
