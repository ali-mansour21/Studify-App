import axios from "axios";

const sendAuthRequest = async (method, route, body) => {
  try {
    axios.defaults.baseURL = "http://192.168.0.104:8001/api/";

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
