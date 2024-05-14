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
import sendAuthRequest from "../../../core/tools/authRequest";
import { requestMethods } from "../../../core/requests/requestMethods";
import { toast } from "react-toastify";

const Unit = () => {
  const { id } = useParams();
  const dispatch = useDispatch();
  const [showPopup, setShowPopup] = useState(false);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState("topics");
  const [moduleData, setModuleData] = useState({
    material_id: parseInt(id),
    title: "",
    content: "",
    attachment: null,
    type: 0,
  });
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
  const handleCreateModule = () => {
    const formData = new FormData();
    formData.append("material_id", moduleData.material_id);
    formData.append("title", moduleData.title);
    formData.append("content", moduleData.content);
    if (moduleData.attachment) {
      formData.append("attachment", moduleData.attachment);
    }
    formData.append("type", moduleData.type);
    sendAuthRequest(requestMethods.POST, "classes/material/addUnit", formData)
      .then((response) => {
        if (response.status === 200) {
          toast.success(response.data.message);
          closePopup();
          fetchAndLoadClasses();
        }
      })
      .catch((e) => {
        console.log(e);
        toast.error("Failed to create new module");
      });
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
              {activeTab === "topic"
                ? material?.map((topic, i) => <UnitCard key={i} data={topic} />)
                : material?.map((assignment, i) => (
                    <UnitCard key={i} data={assignment} />
                  ))}
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
            <label htmlFor="title">Title</label>
            <input
              type="text"
              onChange={(e) => {
                setModuleData({
                  ...moduleData,
                  title: e.target.value,
                });
              }}
              id="title"
              name="title"
            />
          </div>
          <div>
            <label htmlFor="content">Content</label>
            <textarea
              name="content"
              onChange={(e) => {
                setModuleData({
                  ...moduleData,
                  content: e.target.value,
                });
              }}
              id="content"
            ></textarea>
          </div>
          <div>
            <label htmlFor="attachment">Attachment (Optional)</label>
            <input
              type="file"
              onChange={(e) => {
                setModuleData({
                  ...moduleData,
                  attachment: e.target.files[0],
                });
              }}
              id="attachment"
              name="attachment"
            />
          </div>
          <div>
            <label htmlFor="type">Type</label>
            <select
              onChange={(e) => {
                setModuleData({
                  ...moduleData,
                  type: parseInt(e.target.value),
                });
              }}
              name="type"
              id="type"
            >
              <option value="0">Topic</option>
              <option value="1">Assignment</option>
            </select>
          </div>
        </PopUp>
      )}
    </div>
  );
};

export default Unit;
