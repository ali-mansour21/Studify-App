import axios from "axios";
import { API_URL } from "../../../utilities/config";

const sendRequest = async (method, route, body) => {
  try {
    axios.defaults.baseURL = API_URL;

    const response = await axios.request({
      method: method,
      url: route,
      data: body,
      headers: {
        "Content-Type": "application/json",
      },
    });

    return response;
  } catch (error) {
    throw error;
  }
};

export default sendRequest;
