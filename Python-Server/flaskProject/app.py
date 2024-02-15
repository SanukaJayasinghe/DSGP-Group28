from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/send_message', methods=['GET','POST'])
def receive_message():
    # return jsonify({'message': 'Video details received successfully.'}), 200
    try:
        # Get the message from the request data
        video_details = request.json

        print("video detail:", video_details)  # Print the video_details directly

        return jsonify({'message': 'Video details received successfully.'}), 200

    except Exception as e:
        print(e)
        return jsonify({'error': 'An error occurred while processing the request.'}), 500

@app.route('/', methods=['GET','POST'])
def home():
    return 'its LIVE'

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
