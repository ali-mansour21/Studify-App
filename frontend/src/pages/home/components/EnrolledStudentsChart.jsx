import React from "react";
import { Bar } from "react-chartjs-2";
import { Chart as ChartJS } from "chart.js/auto";

const EnrolledStudentsChart = ({ data }) => {
  return (
    <Bar
      data={data}
      options={{
        plugins: {
          title: {
            display: true,
            text: "Total Enrolled Students by Month",
            fontSize: 20,
          },
          legend: {
            display: false,
            position: "right",
            labels: {
              generateLabels: (chart) => {
                return chart.data.datasets.map((dataset, i) => ({
                  text: "Total Enrolled Students", // Updated text
                  fillStyle: dataset.backgroundColor,
                  hidden: !chart.isDatasetVisible(i),
                  lineCap: dataset.borderCapStyle,
                  lineDash: dataset.borderDash,
                  lineDashOffset: dataset.borderDashOffset,
                  lineJoin: dataset.borderJoinStyle,
                  lineWidth: dataset.borderWidth,
                  strokeStyle: dataset.borderColor,
                  pointStyle: dataset.pointStyle,
                  datasetIndex: i,
                }));
              },
            },
          },
        },
      }}
    />
  );
};

export default EnrolledStudentsChart;
