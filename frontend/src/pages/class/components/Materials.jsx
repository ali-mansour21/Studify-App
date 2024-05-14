import React, { useEffect, useState } from "react";
import "../../../styles/utilities.css";
import { useParams } from "react-router-dom";
import "../../../styles/index.css";
import SideBar from "../../../components/sidebar";
import Header from "../../../components/header";
import { useDispatch, useSelector } from "react-redux";
import { fetchClasses } from "../../../core/data/remote";
import { loadClasses } from "../../../redux/boarderSlice";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faPlug, faPlus } from "@fortawesome/free-solid-svg-icons";
import Material from "./Material";
import { BeatLoader } from "react-spinners";
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
  const openPopup = () => {};
  const handleCardClick = (id) => {};
  return (
    <div className="page d-flex">
      <SideBar />
      <div className="content w-full">
        <Header />
        {loading ? (
          <BeatLoader
            className="loader"
            color={"#3786a8"}
            loading={loading}
            size={50}
          />
        ) : (
          <>
            <div className="d-flex spacebetween h-50">
              <h1 className="p-relative">{classItem?.name}</h1>
              <div className="actions d-flex gap-10">
                <button
                  onClick={(e) => {
                    e.preventDefault();
                    openPopup();
                  }}
                >
                  <FontAwesomeIcon icon={faPlus} />
                </button>
                <p>Add</p>
              </div>
            </div>
            <div className="materials-page d-grid gap-20 m-20">
              {classItem?.materials?.map((material) => (
                <Material key={material.id} material={material} />
              ))}
            </div>
          </>
        )}
      </div>
    </div>
  );
};

export default Materials;
