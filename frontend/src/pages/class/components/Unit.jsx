import { useEffect, useState } from "react";
import SideBar from "../../../components/sidebar";
import Header from "../../../components/header";
import "../../../styles/utilities.css";
import "../../../styles/index.css";

import { useParams } from "react-router-dom";
import { fetchClasses } from "../../../core/data/remote";
import { useDispatch, useSelector } from "react-redux";
import { loadClasses } from "../../../redux/boarderSlice";
import { BeatLoader } from "react-spinners";
import UnitCard from "./UnitCard";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faPlus } from "@fortawesome/free-solid-svg-icons";
import PopUp from "../../components/PopUp";

const Unit = () => {
  const { id } = useParams();
  const dispatch = useDispatch();
  const [showPopup, setShowPopup] = useState(false);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState("topics");
  const classes = useSelector((state) => state.classes?.classes);
  const fetchAndLoadClasses = async () => {
    const classData = await fetchClasses();
    dispatch(loadClasses(classData));
    setLoading(false);
  };
  useEffect(() => {
    fetchAndLoadClasses();
  }, [dispatch]);

  const findMaterialInClasses = (classes, materialId) => {
    for (const classItem of classes) {
      const foundMaterial = classItem.materials.find(
        (material) => material.id === materialId
      );
      if (foundMaterial) {
        return foundMaterial;
      }
    }
    return null;
  };
  const openPopup = () => {
    setShowPopup(true);
  };
  const closePopup = () => {
    setShowPopup(false);
  };
  const handleCreateModule = () => {};
  const material = findMaterialInClasses(classes, parseInt(id));
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
              <h1 className="p-relative">{material?.name}</h1>
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
            <div className="tabs">
              <div
                className={`tab topic ${
                  activeTab === "topics" ? "active" : ""
                }`}
                onClick={() => setActiveTab("topics")}
              >
                Topics
              </div>
              <div
                className={`tab assignment ${
                  activeTab === "assignments" ? "active" : ""
                }`}
                onClick={() => setActiveTab("assignments")}
              >
                Assignments
              </div>
            </div>
            <div className="unit-wrapper">
              <UnitCard />
              <UnitCard />
              <UnitCard />
            </div>
          </>
        )}
      </div>
      {showPopup && (
        <PopUp
          formTitle={"Add New Module"}
          buttonText={"Add"}
          isOpen={showPopup}
          closePopUp={closePopup}
          handleSubmit={(e) => {
            e.preventDefault();
            handleCreateModule();
          }}
        >
          <div>
            <label htmlFor="name">Name</label>
            <input type="text" id="name" name="name" />
          </div>
        </PopUp>
      )}
    </div>
  );
};

export default Unit;
