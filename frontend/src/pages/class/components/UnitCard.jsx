import { faArrowDown, faBook } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React from "react";

const UnitCard = () => {
  return (
    <div className="unit-card">
      <div className="unit-icon">
        <FontAwesomeIcon icon={faBook} />
      </div>
      <div className="unit-content">
        <p>ali</p>
      </div>
      <div className="unit-actions">
        <button className="expand-button">
          <FontAwesomeIcon icon={faArrowDown} />
        </button>
      </div>
    </div>
  );
};

export default UnitCard;
