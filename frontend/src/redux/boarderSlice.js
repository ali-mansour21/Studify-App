import { createSlice } from "@reduxjs/toolkit";

const boardsSlice = createSlice({
  name: "user",
  initialState: {},
  reducers: {},
});

export default boardsSlice;
export const { setUser } = boardsSlice.actions;
