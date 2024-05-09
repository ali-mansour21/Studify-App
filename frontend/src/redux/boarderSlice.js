import { createSlice } from "@reduxjs/toolkit";

const boardsSlice = createSlice({
  name: "boards",
  initialState: [],
  reducers: {},
});

export default boardsSlice;
export const { loadBoards } = boardsSlice.actions;
