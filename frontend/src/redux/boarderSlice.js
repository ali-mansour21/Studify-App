import { createSlice } from "@reduxjs/toolkit";
const boardsSlice = createSlice({
  initialState: {
    classes: [],
  },
  name: "classes",
  reducers: {
    loadClasses: (state, action) => {
      const { payload } = action;

      state.classes = payload.map((classData) => {
        state.classes.push(classData);
      });
    },
  },
});

export default boardsSlice.reducer;
export const { loadClasses } = boardsSlice.actions;
