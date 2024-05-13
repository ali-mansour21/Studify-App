import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";
import sendAuthRequest from "../core/tools/authRequest";
import { requestMethods } from "../core/requests/requestMethods";
export const fetchClasses = createAsyncThunk(
  "user/fetchClasses",
  async (_, { rejectWithValue }) => {
    try {
      const response = await sendAuthRequest(requestMethods.GET, "classes");
      if (!response.ok) throw new Error("Network response was not ok");
      const data = await response.json();
      return data;
    } catch (error) {
      return rejectWithValue(error.message);
    }
  }
);
const boardsSlice = createSlice({
  name: "user",
  initialState: {},
  reducers: {},
});

export default boardsSlice;
export const { setUser } = boardsSlice.actions;
