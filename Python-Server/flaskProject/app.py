from flask import Flask
from flask_socketio import SocketIO
import sys
import base64
import cv2
import time

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app)

# Dictionary to hold video chunks received from clients
video_chunks = {}

@socketio.on('connect')
def handle_connect():
    print('Client connected')

@socketio.on('video_chunk')
def handle_video_chunk(video_data):
    print('Receiving video chunk from frontend:')
    try:
        chunk_index = video_data.get('index')
        chunk_data = base64.b64decode(video_data.get('data'))

        if chunk_index not in video_chunks:
            video_chunks[chunk_index] = chunk_data
        else:
            video_chunks[chunk_index] += chunk_data

        print(f'Received chunk {chunk_index}')

        socketio.emit('chunk_received', {'index': chunk_index})

    except Exception as e:
        print('Error handling video chunk:', e)

@socketio.on('video_completed')
def assemble_and_save_video():
    try:
        sorted_chunks = sorted(video_chunks.items(), key=lambda x: x[0])
        complete_video = b''.join(chunk[1] for chunk in sorted_chunks)
        with open('videos/received_video.mp4', 'wb') as f:
            f.write(complete_video)
        print('Video received and saved')
    except Exception as e:
        print('Error assembling or saving video:', e)
    finally:
        video_chunks.clear()

    # Read the image file and convert it to base64
    with open('download.jpeg', 'rb') as image_file:
        image_data = base64.b64encode(image_file.read()).decode('utf-8')

    with open('download (1).jpeg', 'rb') as image_file:
        image_data2 = base64.b64encode(image_file.read()).decode('utf-8')

    # Emit the base64 encoded image data
    socketio.emit('image_received',image_data)
    socketio.emit('image_received',image_data2)
    socketio.emit('image_received',image_data)
    socketio.emit('image_received',image_data2)
    socketio.emit('image_received',image_data)
    socketio.emit('image_received',image_data)
    socketio.emit('image_received',image_data2)
    socketio.emit('image_received',image_data)
    socketio.emit('image_received',image_data2)
    socketio.emit('image_received',image_data)



@socketio.on('disconnect')
def handle_disconnect():
    print('Client disconnected')

if __name__ == '__main__':
    socketio.run(app, debug=True, host='0.0.0.0', port=5000)
