import { configureStore } from "@reduxjs/toolkit";
import boardsSlice from "./boarderSlice.js";

const store = configureStore({
  reducer: {
    user: boardsSlice.reducer,
  },
});

export default store;
