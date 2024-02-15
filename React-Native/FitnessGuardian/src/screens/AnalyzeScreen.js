import React, { useState } from 'react';
import { View, Button, PermissionsAndroid, Text, TouchableOpacity, StyleSheet } from 'react-native';
import DocumentPicker from 'react-native-document-picker';
import VideoCard from '../components/VideoCard';
import sendMessageToFlaskBackend from '../api/Api';

const HomeScreen = () => {
  const [message, setMessage] = useState('');

  const requestExternalStoragePermission = async () => {
    try {
      const granted = await PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.READ_MEDIA_VIDEO,
        {
          title: 'Storage Permission',
          message: 'This app needs access to your storage to save files.',
          buttonNeutral: 'Ask Me Later',
          buttonNegative: 'Cancel',
          buttonPositive: 'OK',
        },
      );
      if (granted === PermissionsAndroid.RESULTS.GRANTED) {
        console.log('Storage permission granted');
      } else {
        console.log('Storage permission denied');
      }
    } catch (err) {
      console.warn(err);
    }
  };

  const pickVideo = async () => {
    await requestExternalStoragePermission();

    try {
      const result = await DocumentPicker.pickSingle({
        type: [DocumentPicker.types.allFiles],
      });

      const videoDetails = {
        uri: result.uri,
        type: result.type,
        name: result.name,
        size: result.size,
      };

      console.log('Analyze screen:', videoDetails);

      // Send message to backend
      const message = await sendMessageToFlaskBackend(videoDetails);

      console.log('Analyze screen:', message);

      setMessage(videoDetails); // Update message state with the video details
    } catch (err) {
      if (DocumentPicker.isCancel(err)) {
        console.log('Document picker cancelled');
      } else {
        console.error('Error picking video:', err);
      }
    }
  };

  return (
    <View style={styles.container}>

      <VideoCard
        pathToVideo={message.uri}
        containerStyle={styles.videoContainer}
      />

      <TouchableOpacity style={styles.button} onPress={pickVideo}>
        <Text style={styles.buttonText}>Select Video</Text>
      </TouchableOpacity>

      {message ? <Text style={styles.text}>{message.name}</Text> : null}

    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  button: {
    marginTop: 40,
    backgroundColor: 'blue',
    paddingVertical: 10,
    paddingHorizontal: 20,
    borderRadius: 5,
    justifyContent: 'center',
    alignItems: 'center',
  },
  buttonText: {
    color: 'white',
    fontSize: 16,
  },
  text: {
    marginTop: 0,
  },
  videoContainer: {
    position: 'absolute',
    top: 80,
  },
});

export default HomeScreen;
