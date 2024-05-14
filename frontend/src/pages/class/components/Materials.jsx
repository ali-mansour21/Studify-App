import React, { useEffect, useState } from "react";
import "../../../styles/utilities.css";
import { useParams } from "react-router-dom";
import "../../../styles/index.css";
import SideBar from "../../../components/sidebar";
import Header from "../../../components/header";
import { useDispatch, useSelector } from "react-redux";
import { fetchClasses } from "../../../core/data/remote";
import { loadClasses } from "../../../redux/boarderSlice";
const Materials = () => {
  const dispatch = useDispatch();
  const { id } = useParams();
  const [loading, setLoading] = useState(true);
  const classes = useSelector((state) => state.classes?.classes);
  useEffect(() => {
    const fetchAndLoadClasses = async () => {
      const classData = await fetchClasses();
      dispatch(loadClasses(classData));
      setLoading(false);
    };

    fetchAndLoadClasses();
  }, [dispatch]);
  const classItem = classes?.find((classItem) => classItem.id === parseInt(id));
  console.log(classItem);
  return (
    <div className="page d-flex">
      <SideBar />
      <div className="content w-full">
        <Header />
        <h2>{classItem?.name}</h2>
      </div>
    </div>
  );
};

export default Materials;
