import { createSlice } from "@reduxjs/toolkit";

const boardsSlice = createSlice({
  name: "instructor",
  initialState: {
    user: null,
  },
  reducers: {
    setUser(state, action) {
      state.user = action.payload;
    },
  },
});

export default boardsSlice;
export const { setUser } = boardsSlice.actions;
