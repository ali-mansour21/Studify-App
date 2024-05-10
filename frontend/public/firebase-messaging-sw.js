importScripts("https://www.gstatic.com/firebasejs/10.11.1/firebase-app.js");
importScripts(
  "https://www.gstatic.com/firebasejs/10.11.1/firebase-messaging.js"
);
firebase.initializeApp({
  apiKey: "AIzaSyAL6EzcAuxkNBQibIAG5hJJBBRzKXRMx-Q",
  authDomain: "studify-81155.firebaseapp.com",
  projectId: "studify-81155",
  storageBucket: "studify-81155.appspot.com",
  messagingSenderId: "607925811224",
  appId: "1:607925811224:web:506b746d56d2a642cf6b6d",
  measurementId: "G-5BGNMM18DT",
});
const messaging = firebase.messaging();
