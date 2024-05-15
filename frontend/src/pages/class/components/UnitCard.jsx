import {
  faArrowDown,
  faArrowUp,
  faBook,
  faPlus,
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useState } from "react";

const UnitCard = ({ data }) => {
  const [isExpanded, setIsExpanded] = useState(false);
  const toggleExpand = () => {
    setIsExpanded(!isExpanded);
  };
  return (
    <>
      <div className={`unit-card ${isExpanded ? "expanded" : ""}`}>
        <div className="unit-header" onClick={toggleExpand}>
          <div className="unit-icon">
            <FontAwesomeIcon icon={faBook} />
          </div>
          <div className="unit-content">
            <p>{data?.title}</p>
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
        {isExpanded && (
          <div className="unit-body">
            <p>{data?.content}</p>
          </div>
        )}
      </div>
    </>
  );
};

export default UnitCard;
