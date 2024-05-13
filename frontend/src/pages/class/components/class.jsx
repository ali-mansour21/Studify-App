import { faUser } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React from "react";
import { IMAGE_URL } from "../../../../utilities/config";

const ClassData = ({ data, inviteStudent }) => {
  console.log(data);
  return (
    <div className="class  bg-white rad-6 p-relative">
      <img
        className="cover"
        srcSet={`${IMAGE_URL}${data?.class_image}`}
        alt=""
      />
      <div className="p-20">
        <h4 className="m-0">{data?.name}</h4>
        <p className="description c-gray mt-15 fs-14">{data?.description}</p>
      </div>
      <div className="info p-15 p-relative between-flex">
        <span className="c-gray d-flex align-center gap-10">
          <FontAwesomeIcon icon={faUser} />
          {data?.student_count}
        </span>
        <span
          onClick={(e) => {
            e.preventDefault();
            inviteStudent(data?.id);
          }}
          className="title bg-blue c-white btn-shape"
        >
          Invite
        </span>
      </div>
    </div>
  );
};

export default ClassData;
