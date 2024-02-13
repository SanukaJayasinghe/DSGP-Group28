// HomeScreen.js
import React from 'react';
import {View, Button, PermissionsAndroid} from 'react-native';
import DocumentPicker from 'react-native-document-picker';
import RNFS from 'react-native-fs';

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
  requestExternalStoragePermission();

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

    // Convert JSON object to a string
    const jsonString = JSON.stringify(videoDetails);

    // Define file path where the JSON file will be saved
    const filePath = RNFS.DocumentDirectoryPath + '/pickedVideo.json';

    // Write the JSON string to the file
    await RNFS.writeFile(filePath, jsonString, 'utf8');

    console.log('Video details saved to:', filePath);

    // Read the file
    RNFS.readFile(filePath, 'utf8')
    .then((fileContents) => {
      const videoDetails = JSON.parse(fileContents);
      console.log('Video details read from file:', videoDetails);
    })
    .catch((error) => {
      console.error('Error reading file:', error);
    });

  } catch (err) {
    if (DocumentPicker.isCancel(err)) {
      console.log(err)
    } else {
      throw err;
    }
  }
};

function AnalyzeScreen() {
  return (
    <View
      style={{
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'palegreen',
      }}>
      <Button title="Select Video" onPress={pickVideo} />
    </View>
  );
}

export default AnalyzeScreen;
