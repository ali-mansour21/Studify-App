import { getMessaging, getToken } from "firebase/messaging";
import app from "./firebase-config";

const messaging = getMessaging(app);

export const fetchToken = (setTokenFound) => {
  return getToken(messaging, {
    vapidKey:
      "BAmmOeneLRRARtqO7a3AX2M2HYrlIJT3b1iktYq7EfZAO0MGW0zRLpI90mbiqQgrK31aooCvHqWNIzO22wllM1Y",
  })
    .then((currentToken) => {
      if (currentToken) {
        console.log("Current token for client: ", currentToken);
        setTokenFound(true);
      } else {
        console.log(
          "No registration token available. Request permission to generate one."
        );
        setTokenFound(false);
      }
    })
    .catch((err) => {
      console.log("An error occurred while retrieving token. ", err);
      setTokenFound(false);
    });
};
