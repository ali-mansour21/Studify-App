import { configureStore } from "@reduxjs/toolkit";
import boardsSlice from "./boarderSlice.js";

export const store = configureStore({
  reducer: {
    classes: boardsSlice.reducer,
  },
});
