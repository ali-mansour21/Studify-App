import React from 'react'
import "../../styles/utilities.css";
import "../../styles/index.css";
import SideBar from '../../../components/sidebar';
import Header from '../../../components/header';
const Materials = () => {
  return (
    <div className="page d-flex">
      <SideBar />
      <div className="content w-full">
        <Header />
      </div>
    </div>
  );
}

export default Materials