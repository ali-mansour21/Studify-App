import {
  faArrowDown,
  faArrowUp,
  faBook,
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React from "react";
import { useState } from "react";

const UnitCard = () => {
  const [isExpanded, setIsExpanded] = useState(false);
  const toggleExpand = () => {
    setIsExpanded(!isExpanded);
  };
  return (
    <div className={`unit-card ${isExpanded ? "expanded" : ""}`}>
      <div className="unit-header" onClick={toggleExpand}>
        <div className="unit-icon">
          <FontAwesomeIcon icon={faBook} />
        </div>
        <div className="unit-content">
          <p>ali</p>
        </div>
        <div className="unit-actions">
          <button className="expand-button">
            {isExpanded ? (
              <FontAwesomeIcon icon={faArrowUp} />
            ) : (
              <FontAwesomeIcon icon={faArrowDown} />
            )}
          </button>
        </div>
      </div>
      {isExpanded && <div className="unit-body">ali</div>}
    </div>
  );
};

export default UnitCard;
