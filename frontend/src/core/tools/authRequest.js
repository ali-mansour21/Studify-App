import axios from "axios";
import { API_URL } from "../../../utilities/config";

const sendAuthRequest = async (method, route, body) => {
  try {
    axios.defaults.baseURL = API_URL;

    const response = await axios.request({
      method: method,
      url: route,
      data: body,
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${localStorage.getItem("token")}`,
      },
    });

    return response;
  } catch (error) {
    throw error;
  }
};

export default sendAuthRequest;
