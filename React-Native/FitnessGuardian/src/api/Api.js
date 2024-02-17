import React, { useEffect, useState } from 'react';
import { View, Image, StyleSheet, Text, ScrollView } from 'react-native';
import io from 'socket.io-client';
import RNFS from 'react-native-fs';

const serverUrl = 'ws://localhost:5000';
const socket = io(serverUrl);

const UploadVideo = ({ videoFile }) => {
  const [images, setImages] = useState([]);

  useEffect(() => {
    socket.on('connect', () => {
      console.log('WebSocket connection established');
    });

    socket.on('message', (data) => {
      console.log('message received');
    });

    socket.on('image_received', (imageData) => {
      setImages((prevImages) => [...prevImages, imageData]);
      console.log('message received');
    });

    socket.on('disconnect', () => {
      console.log('WebSocket connection closed');
    });

    socket.on('error', (error) => {
      console.error('WebSocket error:', error);
    });

    return () => {
      socket.close();
    };
  }, []);

  useEffect(() => {
    const sendVideoToServer = async () => {
      try {
        setImages([]);
        if (videoFile && videoFile.uri) {
          console.log('ApiScreen: ', videoFile);
          const fileUri = videoFile.uri;
          const chunkSize = 500 * 100;

          const filePath = `${RNFS.DocumentDirectoryPath}/newFile.mp4`;
          await RNFS.copyFile(fileUri, filePath);

          const { size } = await RNFS.stat(filePath);

          const totalChunks = Math.ceil(size / chunkSize);

          for (let i = 0; i < totalChunks; i++) {
            const start = i * chunkSize;
            const end = Math.min(start + chunkSize, size);
            const chunk = await RNFS.read(filePath, chunkSize, start, 'base64');
            socket.emit('video_chunk', { index: i, data: chunk });
          }

          socket.emit('video_completed');
        }
      } catch (error) {
        console.error('Error reading or sending file:', error);
      }
    };
    sendVideoToServer();
  }, [videoFile]);

  return (
    <View style={styles.container}>
      <View style={styles.scrollViewContainer}>
        <ScrollView contentContainerStyle={styles.scrollViewContent} showsHorizontalScrollIndicator={false} showsVerticalScrollIndicator={true}>
          <Text>Total Images: {images.length}</Text>
          <View style={styles.imageContainer}>
            {images.map((imageData, index) => (
              <Image key={index} source={{ uri: `data:image/jpeg;base64,${imageData}` }} style={styles.image} />
            ))}
          </View>
        </ScrollView>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    position: 'relative',
    top: 390,
  },
  scrollViewContainer: {
  },
  scrollViewContent: {
    flexGrow: 1,
    alignItems:'center',
  },
  imageContainer: {
    flexDirection: 'column',
    flexWrap: 'wrap',
  },
  image: {
    width: 350,
    height: 100,
    margin: 5,
  },
});

export default UploadVideo;
