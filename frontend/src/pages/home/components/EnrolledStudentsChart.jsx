import React from 'react'
import { Bar } from "react-chartjs-2";
import { Chart as Chart } from "chart.js/auto";
const EnrolledStudentsChart = ({data}) => {
  return (
        <Bar
            data={data}
            options={{
                title:{
                    display: true,
                    text: 'Number of Materials by Month',
                    fontSize: 20
                },
                legend:{
                    display: true,
                    position: 'right'
                }
            }}
        />
    );
}

export default EnrolledStudentsChart