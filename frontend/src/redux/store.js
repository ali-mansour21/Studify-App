import { configureStore } from "@reduxjs/toolkit";
import boardsSlice from "./boardsSlice";

const store = configureStore({
  reducer: {
    instructor: boardsSlice.reducer,
  },
});

export default store;
