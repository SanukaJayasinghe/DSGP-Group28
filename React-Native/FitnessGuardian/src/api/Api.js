import axios from 'axios';

// URL of Flask backend
const flaskBackendURL = 'http://localhost:5000';

// Define a function to send the message to the Flask backend
const sendMessageToFlaskBackend = async (videoDetails) => {
  try {
    const config = {
      headers: {
        'Content-Type': 'application/json',
      },
    };

    // Send a POST request to the Flask backend with the message
    const response = await axios.post(`${flaskBackendURL}/send_message`, videoDetails, config);

    // Log the response from the Flask backend
    console.log('ApiScreen -> Response from Flask backend:', response.data);

    return response.data.message;

  } catch (error) {
    // Log errors that occur during the request
    console.error('Error sending message to Flask backend:', error);
  }
};

// Call the function to send the message
export default sendMessageToFlaskBackend;
