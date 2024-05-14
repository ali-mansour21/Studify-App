import React from 'react'

const Material = ({material}) => {
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
}

export default Material