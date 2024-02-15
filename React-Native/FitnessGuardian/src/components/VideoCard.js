import React from 'react';
import { View, ActivityIndicator, StyleSheet, Text } from 'react-native';
import Video from 'react-native-video';

const VideoCard = ({ pathToVideo, containerStyle }) => {
  return (
    <View style={[styles.container, containerStyle]}>
      {pathToVideo ? (
        <Video
          source={{ uri: pathToVideo }}
          style={styles.video}
          resizeMode="contain"
          controls={true}
        />
      ) : (
        <View style={styles.placeholderContainer}>
          <View style={styles.placeholder}>
            <ActivityIndicator size="large" color="#0000ff" />
            <Text style={styles.placeholderText}>Loading Video...</Text>
          </View>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    backgroundColor: 'black',
    alignItems: 'center',
    padding: 10,
    borderRadius: 10,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 3,
    },
    shadowOpacity: 0.3,
    shadowRadius: 4.7,
    elevation: 6,
  },
  placeholderContainer:{
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 10,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 3,
    },
    shadowOpacity: 0.3,
    shadowRadius: 4.65,
    elevation: 6,
  },
  video: {
    width: 360,
    height: 240,
  },
  placeholder: {
    backgroundColor: 'white',
    alignItems: 'center',
    justifyContent: 'center',
    width: 360,
    height: 240,
    padding: 30,
    borderRadius: 10,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 3,
    },
    shadowOpacity: 0.3,
    shadowRadius: 4.65,
    elevation: 6,
  },
  placeholderText: {
    marginTop: 10,
    fontSize: 16,
  },
});

export default VideoCard;