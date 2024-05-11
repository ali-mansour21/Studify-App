// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getMessaging, getToken } from "firebase/messaging";

const firebaseConfig = {
  apiKey: "AIzaSyAUmAIvc568vkPamF6XtU3LqaMLkpwEdJc",
  authDomain: "studify-notifications.firebaseapp.com",
  databaseURL: "https://studify-notifications-default-rtdb.firebaseio.com",
  projectId: "studify-notifications",
  storageBucket: "studify-notifications.appspot.com",
  messagingSenderId: "256089037545",
  appId: "1:256089037545:web:008abf3f8fefe7a505ae78",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const messaging = getMessaging(app);
export const generateToken = async () => {
  await Notification.requestPermission();
  const token = await getToken(messaging, {
    vapidKey:
      "BA3Xnsyb1PZEb1BBve8ZkWDQ3xGmdtbH4B4Zi6XKpfx-_g-ccrci-tIeMCgKwQCCfiE3Tw5DrvzY-095V4SQDoM",
  });
  return token;
};
