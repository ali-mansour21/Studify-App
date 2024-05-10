import React, { useState } from "react";
import "../../styles/popup.css";
const PopUp = ({
  children,
  handleSubmit,
  buttonText,
  formTitle,
  isOpen,
  closePopUp,
}) => {
  return (
    <div>
      {isOpen && (
        <div className="popup">
          <div className="popup-inner">
            <div>
              <h2>{formTitle}</h2>
              <span onClick={closePopUp}>&times;</span>
            </div>
            <form onSubmit={handleSubmit} encType="multipart/form-data">
              {children}
              <button type="submit">{buttonText}</button>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default PopUp;
