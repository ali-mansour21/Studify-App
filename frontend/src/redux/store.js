import { configureStore } from "@reduxjs/toolkit";
import boardsSlice from "./boarderSlice";

const store = configureStore({
  reducer: {
    classes: boardsSlice.reducer,
  },
});

export default store;
