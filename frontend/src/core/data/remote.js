import { requestMethods } from "../requests/requestMethods";
import sendAuthRequest from "../tools/authRequest";

export const fetchClasses = async () => {
  try {
    const response = await sendAuthRequest(requestMethods.GET, "classes");
    if (response.status === 200) {
      return response.data.data.classes;
    } else {
      throw new Error("Failed to fetch classes");
    }
  } catch (error) {
    console.error("Error fetching classes:", error);
    return [];
  }
};
