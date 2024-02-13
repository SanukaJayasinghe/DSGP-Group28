import React from 'react';
import { View, Text, StyleSheet  } from 'react-native';

const GetCurrentDate = () => {
  // Create a new Date object
  const currentDate = new Date();

  // Options for formatting the date
  const options = { weekday: 'long', day: '2-digit', month: 'short' };

  // Format the date using the options
  const formattedDate = currentDate.toLocaleDateString('en-US', options);

  return (
    <View>
      <Text style={styles.text}>{formattedDate}</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  text: {
    fontSize: 12,
  },
});

export default GetCurrentDate;
