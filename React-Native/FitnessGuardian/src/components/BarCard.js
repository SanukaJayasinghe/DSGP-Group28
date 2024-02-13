// BarCard.js
import React from 'react';
import { View , Text, StyleSheet, TouchableOpacity, ProgressBarAndroid } from 'react-native';
import {ProgressView} from "@react-native-community/progress-view";
import { FontAwesomeIcon } from '@fortawesome/react-native-fontawesome';
import { faCheckCircle  } from '@fortawesome/free-solid-svg-icons';

const getRandomColor = () => {
  const colors = ['#FF6347', '#4682B4', '#32CD32', '#9370DB', '#FFA500'];
  return colors[Math.floor(Math.random() * colors.length)];
};

const BarCard = ({ title, barPercentage }) => {
  const color = getRandomColor();

  return (
    <View style={styles.card}>
      <TouchableOpacity style={styles.cardContainer} onPress={() => console.log(`Button pressed for ${title}`)}>

        <View style={styles.textContainer}>
          <Text style={styles.heading}>{title}</Text>
        </View>

        <ProgressView style={styles.progressBar} styleAttr="Horizontal" progress={barPercentage} trackTintColor={color} progressTintColor={color}/>

        <View style={styles.textContainer}>
          <Text style={styles.text}>{barPercentage * 100}%</Text>
          <View style={styles.iconContainer}>
            <FontAwesomeIcon icon={faCheckCircle} style={styles.icon} />
          </View>
        </View>


      </TouchableOpacity>

    </View>
  );
};

const styles = StyleSheet.create({
  card: {
    marginBottom: 60,
    padding: 10,
    width: 120,
  },
  cardContainer: {
    elevation: 5,
    borderRadius: 10,
    backgroundColor: 'white',
    alignItems: 'center',
    paddingBottom: 10, // Add padding to the bottom to prevent overshadowing
  },
  textContainer: {
    padding: 10,
    alignItems: 'center',
    justifyContent: 'center',
    flexDirection: 'row', // Arrange children horizontally
  },
  heading: {
    fontSize: 18,
    fontWeight: 'bold',
    color: 'black',
  },
  progressBar: {
    width: '80%', // Adjust the width of the progress bar as needed
  },
  text: {
    color: 'green',
  },
  iconContainer: {
    position: 'relative',
  },
  icon: {
    color: 'green',
  },
});


export default BarCard;
