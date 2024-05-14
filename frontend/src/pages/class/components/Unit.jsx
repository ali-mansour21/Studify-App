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

const Unit = () => {
  const { id } = useParams();
  const dispatch = useDispatch();
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
            <h1 className="p-relative">{material?.name}</h1>
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
    </div>
  );
};

export default Unit;
