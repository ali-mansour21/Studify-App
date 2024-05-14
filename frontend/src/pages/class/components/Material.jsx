import React from "react";
import { useNavigate } from "react-router-dom";

const Material = ({ material }) => {
  const navigate = useNavigate();
  const handleCardClick = (id) => {
    navigate(`/material/data/${id}`);
  };
  return (
    <div
      onClick={(e) => {
        e.preventDefault();
        handleCardClick(material.id);
      }}
      className="material  bg-white rad-6 p-relative"
    >
      <div className="p-20">
        <h4 className="m-0">{material.name}</h4>
      </div>
    </div>
  );
};

export default Material;
