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
import { faPlus, faRobot } from "@fortawesome/free-solid-svg-icons";
import PopUp from "../../components/PopUp";
import sendAuthRequest from "../../../core/tools/authRequest";
import { requestMethods } from "../../../core/requests/requestMethods";
import { toast } from "react-toastify";

const Unit = () => {
  const { id } = useParams();
  const dispatch = useDispatch();
  const [showPopup, setShowPopup] = useState(false);
  const [showQAPopUp, setShowQAPopUp] = useState(false);
  const [showAssignmentGradingPopUp, setAssignmentGradingPopUp] =
    useState(false);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState("topics");
  const [moduleData, setModuleData] = useState({
    material_id: parseInt(id),
    title: "",
    content: "",
    attachment: null,
    type: 0,
  });
  const [documentFile, setDocumentFile] = useState({
    faq_file: null,
    material_id: parseInt(id),
  });
  const [assignmentParamFile, setAssignmentParamFile] = useState({
    correction_file: null,
    assignment_id: 0,
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

  const openAiPopUp = () => {
    if (activeTab === "topics") {
      setShowQAPopUp(true);
    } else {
      setAssignmentGradingPopUp(true);
    }
  };

  const closeAiPopUp = () => {
    if (activeTab === "topics") {
      setShowQAPopUp(false);
    } else {
      setAssignmentGradingPopUp(false);
    }
  };

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
    if (moduleData.attachment) {
      const reader = new FileReader();

      reader.onloadend = () => {
        const base64File = reader.result.split(",")[1];

        const payload = {
          material_id: moduleData.material_id,
          title: moduleData.title,
          content: moduleData.content,
          attachment: base64File,
          type: moduleData.type,
        };

        sendAuthRequest(
          requestMethods.POST,
          "classes/material/addUnit",
          payload,
          {
            headers: {
              "Content-Type": "application/json",
            },
          }
        )
          .then((response) => {
            if (response.status === 200) {
              toast.success(response.data.message);
              closePopup();
              fetchAndLoadClasses();
            } else {
              toast.error("Failed to create new module");
            }
          })
          .catch((e) => {
            console.log(e);
            toast.error("Failed to create new module");
          });
      };

      reader.onerror = (error) => {
        console.error("Error reading file:", error);
        toast.error("Failed to read file");
      };

      reader.readAsDataURL(moduleData.attachment);
    } else {
      const payload = {
        material_id: moduleData.material_id,
        title: moduleData.title,
        content: moduleData.content,
        type: moduleData.type,
      };

      sendAuthRequest(
        requestMethods.POST,
        "classes/material/addUnit",
        payload,
        {
          headers: {
            "Content-Type": "application/json",
          },
        }
      )
        .then((response) => {
          if (response.status === 200) {
            toast.success(response.data.message);
            closePopup();
            fetchAndLoadClasses();
          } else {
            toast.error("Failed to create new module");
          }
        })
        .catch((e) => {
          console.log(e);
          toast.error("Failed to create new module");
        });
    }
  };

  const handleUploadQAFile = () => {
    const reader = new FileReader();

    reader.onloadend = () => {
      const base64File = reader.result.split(",")[1];

      const payload = {
        faq_file: base64File,
        material_id: documentFile.material_id,
      };

      sendAuthRequest(requestMethods.POST, "faq_file", payload, {
        headers: {
          "Content-Type": "application/json",
        },
      })
        .then((response) => {
          if (response.status === 200) {
            toast.success(response.data.message);
            closeAiPopUp();
          } else {
            toast.error("Failed to upload file");
          }
        })
        .catch(() => {
          toast.error("Failed to upload file");
        });
    };

    reader.onerror = () => {
      toast.error("Failed to read file");
    };

    reader.readAsDataURL(documentFile.faq_file);
  };

  const handleUploadCorrectionFile = () => {
    if (
      !assignmentParamFile.correction_file ||
      !assignmentParamFile.assignment_id
    ) {
      toast.error("Please select a file and an assignment.");
      return;
    }

    const reader = new FileReader();

    reader.onloadend = () => {
      const base64File = reader.result.split(",")[1];

      const payload = {
        correction_file: base64File,
        assignment_id: assignmentParamFile.assignment_id,
      };

      sendAuthRequest(requestMethods.POST, "correction_file", payload, {
        headers: {
          "Content-Type": "application/json",
        },
      })
        .then((response) => {
          if (response.status === 200) {
            toast.success(response.data.message);
            closeAiPopUp();
          } else {
            toast.error("Failed to upload file");
          }
        })
        .catch(() => {
          toast.error("Failed to upload file");
        });
    };

    reader.onerror = () => {
      toast.error("Failed to read file");
    };

    reader.readAsDataURL(assignmentParamFile.correction_file);
  };

  const material = findMaterialInClasses(classes, parseInt(id));

  return (
    <div className="page p-relative d-flex">
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
                  Add
                </button>
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
              {activeTab === "topics"
                ? material?.topics?.map((topic, i) => (
                    <UnitCard key={i} data={topic} />
                  ))
                : material?.assignments?.map((assignment, i) => (
                    <UnitCard key={i} data={assignment} />
                  ))}
            </div>
          </>
        )}
        <div className="assignment-correction">
          <button
            onClick={(e) => {
              e.preventDefault();
              openAiPopUp();
            }}
          >
            <FontAwesomeIcon icon={faRobot} />
          </button>
        </div>
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
      {showQAPopUp && (
        <PopUp
          formTitle={"AI Q&A File Upload"}
          buttonText={"Upload"}
          isOpen={showQAPopUp}
          closePopUp={closeAiPopUp}
          handleSubmit={(e) => {
            e.preventDefault();
            handleUploadQAFile();
          }}
        >
          <div>
            <label htmlFor="document">Q&A Document</label>
            <input
              type="file"
              onChange={(e) => {
                setDocumentFile({
                  ...documentFile,
                  faq_file: e.target.files[0],
                });
              }}
              id="document"
              name="document"
            />
          </div>
        </PopUp>
      )}
      {showAssignmentGradingPopUp && (
        <PopUp
          formTitle={"Assignment Criteria"}
          buttonText={"Upload"}
          isOpen={showAssignmentGradingPopUp}
          closePopUp={closeAiPopUp}
          handleSubmit={(e) => {
            e.preventDefault();
            handleUploadCorrectionFile();
          }}
        >
          <div>
            <label htmlFor="document">Param Document</label>
            <input
              type="file"
              onChange={(e) => {
                setAssignmentParamFile({
                  ...assignmentParamFile,
                  correction_file: e.target.files[0],
                });
              }}
              id="document"
              name="document"
            />
          </div>
          <div>
            <label htmlFor="assignment_id">Select an Assignment</label>
            <select
              onChange={(e) => {
                setAssignmentParamFile({
                  ...assignmentParamFile,
                  assignment_id: parseInt(e.target.value),
                });
              }}
              name="assignment_id"
              id="assignment_id"
            >
              {material?.assignments?.map((assignment) => (
                <option key={assignment.id} value={assignment.id}>
                  {assignment.title}
                </option>
              ))}
            </select>
          </div>
        </PopUp>
      )}
    </div>
  );
};

export default Unit;
