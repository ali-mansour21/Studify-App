import { configureStore } from "@reduxjs/toolkit";
import boardsSlice from "./boarderSlice.js";

const store = configureStore({
  reducer: {
    instructor: boardsSlice.reducer,
  },
});

export default store;
