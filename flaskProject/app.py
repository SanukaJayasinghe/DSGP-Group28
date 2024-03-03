import base64
from flask import Flask
from flask_socketio import SocketIO, emit
from src.postureAnalysisModel import PoseDetector

app = Flask(__name__)
socketio = SocketIO(app, max_http_buffer_size=100000000)




def save_video(video_name, base64_encoded_video):
    video_data = base64.b64decode(base64_encoded_video)
    file_path = f'videos/{video_name}'
    with open(file_path, "wb") as video_file:
        video_file.write(video_data)
    return file_path


def process(file_path,typeOfVideo):
    print('Going to be initialized')
    pose_detector = PoseDetector(typeOfVideo)
    pose_detector.process_video(file_path, send_feedback)


def send_feedback(feedback):
    print('sending video')
    emit('feedbackdata', feedback)


@socketio.on('connect')
def handle_connect():
    print('Client connected')


@socketio.on('disconnect')
def handle_disconnect():
    print('Client disconnected')


@socketio.on('sendVideo')
def handle_send_video(data):
    try:
        video_name = data['name']
        base64_encoded_video = data['file']
        typeOfVideo = data['type']

        # Save the video to a file
        video_file = save_video(video_name, base64_encoded_video)
        print('video saved')
        process(video_file,typeOfVideo)

    except Exception as e:
        print(f'Error handling video upload: {e}')
        emit('videoStatus', {'message': 'Error uploading video'})


@socketio.on_error_default
def error_handler(e):
    print(f"An error occurred: {e}")
    emit('error', {'message': 'An error occurred'})


if __name__ == '__main__':
    socketio.run(app, debug=True, host='0.0.0.0', port=5000)
    # process_video('flaskProject/videos/PushUp2.mp4') #  Testing
