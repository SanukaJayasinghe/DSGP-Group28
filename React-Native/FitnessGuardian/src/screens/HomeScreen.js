import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, ScrollView } from 'react-native';
import GetCurrentDate from '../util/GetCurrentDate.js';
import { FontAwesomeIcon } from '@fortawesome/react-native-fontawesome';
import { faCog } from '@fortawesome/free-solid-svg-icons';
import Card from '../components/Card.js';
import BarCard from '../components/BarCard.js';
import CardData from '../assets/CardData.json'; // Import the regular cards data
import BarCardData from '../assets/BarCardData.json'; // Import the bar cards data

const HomeScreen = () => {
  const [cards, setCards] = useState([]);
  const [barCards, setBarCards] = useState([]);

  useEffect(() => {
    // Load data from JSON file
    setCards(CardData);
    setBarCards(BarCardData);
  }, []);

  // Function to render regular cards
  const renderCards = () => {
    return cards.map(card => (
      <Card
        key={card.id}
        heading={card.heading}
        buttonText={card.buttonText}
        onPress={() => console.log('Button pressed for', card.heading)}
      />
    ));
  };

  // Function to render bar cards
  const renderBarCards = () => {
    return barCards.map((card, index) => (
      <BarCard
        key={index}
        title={card.title}
        barPercentage={card.barPercentage}
      />
    ));
  };

  return (
    <View style={styles.container}>

      <View style={styles.header}>
        <View style={styles.headerLeft}>
          <Text style={styles.text}><GetCurrentDate /></Text>
          <Text style={styles.text}>Have a nice day!</Text>
        </View>
        <View style={styles.headerRight}>
          <FontAwesomeIcon icon={faCog} style={styles.icon} />
        </View>
      </View>

      <Text style={styles.heading}>Recently Analyzed</Text>

      <ScrollView horizontal showsHorizontalScrollIndicator={false} showsVerticalScrollIndicator={false}>
        {renderBarCards()}
      </ScrollView>

      <Text style={styles.heading}>Mistakes</Text>

      <ScrollView style={styles.scrollView} showsHorizontalScrollIndicator={false} showsVerticalScrollIndicator={false}>
        {renderCards()}
      </ScrollView>

    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingHorizontal: 20,
    paddingTop: 20,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  headerLeft: {
    flexDirection: 'column',
  },
  headerRight: {
    flexDirection: 'column',
  },
  heading: {
    fontSize: 20,
    fontWeight: 'bold',
    color: 'black',
    marginBottom: 10,
  },
  text: {
    fontSize: 14,
  },
  icon: {
    color: 'black',
  },
  scrollView: {
    // marginBottom: 20,
  },
});

export default HomeScreen;
