import base64
from flask import Flask
from flask_socketio import SocketIO, emit

app = Flask(__name__)
socketio = SocketIO(app,max_http_buffer_size=100000000)

# Function to save received video to a file
def save_video(video_name, base64_encoded_video):
    video_data = base64.b64decode(base64_encoded_video)

    # Write video data to file
    with open(f'flaskProject/videos/{video_name}', "wb") as video_file:
        video_file.write(video_data)

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
        
        # Save the video to a file
        save_video(video_name, base64_encoded_video)
        print('Video saved')

        emit('videoStatus', {'message': 'Video uploaded successfully'})

    except Exception as e:
        print(f'Error handling video upload: {e}')
        emit('videoStatus', {'message': 'Error uploading video'}, broadcast=False)

if __name__ == '__main__':
    socketio.run(app, debug=True, host='0.0.0.0', port=5000)
