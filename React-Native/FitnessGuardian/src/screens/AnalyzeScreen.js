import React, { useState, useEffect } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Image, PermissionsAndroid } from 'react-native';
import DocumentPicker from 'react-native-document-picker';
import VideoCard from '../components/VideoCard';
import UploadVideo from '../api/Api';

const AnalyzeScreen = () => {
  const [video, setVideo] = useState([]);

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
      const videoFile = await DocumentPicker.pickSingle({
        type: [DocumentPicker.types.allFiles],
      });

      const videoDetails = {
        uri: videoFile.uri,
        type: videoFile.type,
        name: videoFile.name,
        size: videoFile.size,
      };

      setVideo(videoFile);

      console.log('Picked Video:', videoDetails);

    } catch (err) {
      if (DocumentPicker.isCancel(err)) {
        console.log('Document picker cancelled');
      } else {
        console.error('Error picking video:', err);
      }
    }
  };

  const removeVideo = async () => {
    setVideo([]);
  };

  return (
    <View style={styles.container}>
      {video ? <Text style={styles.text}>Name: {video.name}</Text> : null}

      <VideoCard
        pathToVideo={video.uri}
        containerStyle={styles.videoContainer}
      />

      <View style={styles.buttonContainer}>
        <TouchableOpacity style={styles.button} onPress={pickVideo}>
          <Text style={styles.buttonText}>Select Video</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.button} onPress={removeVideo}>
          <Text style={styles.buttonText}>Remove Video</Text>
        </TouchableOpacity>
      </View>

      <View>
        <UploadVideo videoFile={video}/>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  buttonContainer: {
    position:'absolute',
    top:340,
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 20,
  },
  button: {
    backgroundColor: 'blue',
    paddingVertical: 10,
    paddingHorizontal: 20,
    borderRadius: 5,
    justifyContent: 'center',
    alignItems: 'center',
    flex: 1,
    marginHorizontal: 5,
  },
  buttonText: {
    color: 'white',
    fontSize: 16,
  },
  text: {
    color:'black',
    fontWeight: 'bold',
    position:'absolute',
    top:10,
    left:10,
    marginTop: 20,
    fontSize: 20,
  },
  videoContainer: {
    position: 'absolute',
    top: 70,
  },
});

export default AnalyzeScreen;
