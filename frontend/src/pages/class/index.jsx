import React, { useEffect, useState } from "react";
import SideBar from "../../components/sidebar";
import "../../styles/utilities.css";
import "../../styles/index.css";
import Header from "../../components/header";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useSelector, useDispatch } from "react-redux";
import { faPlus } from "@fortawesome/free-solid-svg-icons";
import PopUp from "../components/PopUp";
import sendAuthRequest from "../../core/tools/authRequest";
import { requestMethods } from "../../core/requests/requestMethods";
import { toast } from "react-toastify";
import { loadClasses } from "../../redux/boarderSlice";
import { BeatLoader } from "react-spinners";
import ClassData from "./components/class";

const Home = () => {
  const dispatch = useDispatch();
  const classes = useSelector((state) => state.classes?.classes);
  const [showPopup, setShowPopup] = useState(false);
  const [classData, setClassData] = useState({
    name: "",
    description: "",
    category_id: "",
    class_image: null,
  });
  const closePopup = () => {
    setShowPopup(false);
  };
  const openPopup = () => {
    setShowPopup(true);
  };
  const uploadImage = async (e) => {
    const file = e.target.files[0];
    const base64 = await convertBase64(file);
    setClassData({ ...classData, class_image: base64 });
  };
  const convertBase64 = (file) => {
    return new Promise((resolve, reject) => {
      const fileReader = new FileReader();
      fileReader.readAsDataURL(file);

      fileReader.onload = () => {
        resolve(fileReader.result);
      };

      fileReader.onerror = (error) => {
        reject(error);
      };
    });
  };
  const handleCreateClass = () => {
    sendAuthRequest(requestMethods.POST, "classes", classData).then(
      (response) => {
        if (response.status === 200) {
          toast.success(response.data.message);
          closePopup();
        }
      }
    );
  };
  const fetchClasses = () => {
    sendAuthRequest(requestMethods.GET, "classes").then((response) => {
      if (response.status === 200) {
        dispatch(loadClasses(response.data.data.classes));
      }
    });
  };
  useEffect(() => {
    fetchClasses();
  }, []);
  return (
    <div className="page d-flex">
      <SideBar />
      <div className="content w-full">
        <Header />
        <div className="d-flex spacebetween h-50">
          <h1 className="p-relative">Classes</h1>
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
        <div className="classes-page d-grid gap-20 m-20">
          {classes?.map((cls) => (
            <ClassData key={cls.id} data={cls} />
          ))}
        </div>
      </div>
      {showPopup && (
        <PopUp
          formTitle={"Create Class"}
          buttonText={"Create"}
          isOpen={showPopup}
          closePopUp={closePopup}
          handleSubmit={(e) => {
            e.preventDefault();
            handleCreateClass();
          }}
        >
          <div>
            <label htmlFor="name">Name</label>
            <input
              type="text"
              onChange={(e) => {
                setClassData({
                  ...classData,
                  name: e.target.value,
                });
              }}
              id="name"
              name="name"
            />
          </div>
          <div>
            <label htmlFor="description">Description</label>
            <textarea
              onChange={(e) => {
                setClassData({
                  ...classData,
                  description: e.target.value,
                });
              }}
              type="text"
              id="description"
              name="description"
            ></textarea>
          </div>
          <div>
            <label htmlFor="class_image">Image</label>
            <input
              type="file"
              onChange={(e) => uploadImage(e)}
              name="class_image"
              id="class_image"
              multiple
            />
          </div>
          <div>
            <label htmlFor="category">Category</label>
            <select
              defaultValue={1}
              onChange={(e) => {
                setClassData({
                  ...classData,
                  category_id: parseInt(e.target.value),
                });
              }}
              name="category"
              id="category"
            >
              <option value="1">Math</option>
              <option value="2">Arabic</option>
              <option value="3">English</option>
              <option value="4">French</option>
              <option value="5">Geo</option>
              <option value="6">History</option>
              <option value="7">Science</option>
            </select>
          </div>
        </PopUp>
      )}
    </div>
  );
};

export default Home;
