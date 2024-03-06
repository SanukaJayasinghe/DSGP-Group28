import os
import base64
from flask import Flask
from flask_socketio import SocketIO, emit
from src.pose_detector import PoseDetector

app = Flask(__name__)
socketio = SocketIO(app, max_http_buffer_size=100000000)
pose_detector = PoseDetector()  # Initialize PoseDetector object


def decode(encoded_data):
    return base64.b64decode(encoded_data)


@socketio.on('sendVideo')
def handle_send_video(data):
    try:
        video_name = data['name']
        encoded_video = data['file']
        video_type = data['type']

        # Decode the base64 encoded video
        video_data = decode(encoded_video)

        # Save the video to a file
        file_path = os.path.join('videos', video_name)
        with open(file_path, "wb") as video_file:
            video_file.write(video_data)
        print('Video saved')

        # Load the model and process the video
        pose_detector.stop_stream()
        pose_detector.load_model(video_type)
        pose_detector.process_video(file_path, send_feedback)

    except Exception as e:
        print(f'Error handling video upload: {e}')
        emit('videoStatus', {'message': 'Error uploading video'})


def send_feedback(feedback):
    print('Sending feedback')
    emit('feedbackdata', feedback)


@socketio.on('connect')
def handle_connect():
    print('Client connected')


@socketio.on('disconnect')
def handle_disconnect():
    print('Client disconnected')


@socketio.on_error_default
def error_handler(e):
    print(f"An error occurred: {e}")
    emit('error', {'message': 'An error occurred'})


if __name__ == '__main__':
    socketio.run(app, debug=True, host='0.0.0.0', port=5000)
