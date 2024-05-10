// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getMessaging, getToken } from "firebase/messaging";

const firebaseConfig = {
  apiKey: "AIzaSyAL6EzcAuxkNBQibIAG5hJJBBRzKXRMx-Q",
  authDomain: "studify-81155.firebaseapp.com",
  projectId: "studify-81155",
  storageBucket: "studify-81155.appspot.com",
  messagingSenderId: "607925811224",
  appId: "1:607925811224:web:506b746d56d2a642cf6b6d",
  measurementId: "G-5BGNMM18DT",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const messaging = getMessaging(app);
export const generateToken = async () => {
  await Notification.requestPermission();
  const token = await getToken(messaging, {
    vapidKey:
      "BAmmOeneLRRARtqO7a3AX2M2HYrlIJT3b1iktYq7EfZAO0MGW0zRLpI90mbiqQgrK31aooCvHqWNIzO22wllM1Y",
  });
  return token;
};
