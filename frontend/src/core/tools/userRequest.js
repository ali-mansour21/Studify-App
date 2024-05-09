import axios from "axios";

const sendRequest = async (method, route, body) => {
  try {
    axios.defaults.baseURL = "http://127.0.0.1:8000/api/";

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
