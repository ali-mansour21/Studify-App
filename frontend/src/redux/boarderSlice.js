import { createSlice } from "@reduxjs/toolkit";
const boardsSlice = createSlice({
  initialState: {
    classes: [],
  },
  name: "classes",
  reducers: {
    loadClasses: (state, action) => {
      const { payload } = action;
      console.log("the action", payload);
      state.classes = payload;
    },
  },
});

export default boardsSlice;
export const { loadClasses } = boardsSlice.actions;
