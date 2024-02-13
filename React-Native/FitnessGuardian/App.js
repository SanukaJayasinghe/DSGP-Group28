// Import main components
import React from 'react';
import {NavigationContainer} from '@react-navigation/native';
import {createBottomTabNavigator} from '@react-navigation/bottom-tabs';
import {FontAwesomeIcon} from '@fortawesome/react-native-fontawesome';
import {
  faHome,
  faRunning,
  faMugHot,
  faCog,
  faSquarePlus,
} from '@fortawesome/free-solid-svg-icons';

// Import screens
import HomeScreen from './src/screens/HomeScreen';
import ExerciseScreen from './src/screens/ExerciseScreen';
import AnalyzeScreen from './src/screens/AnalyzeScreen';
import DietScreen from './src/screens/DietScreen';
import SettingsScreen from './src/screens/SettingsScreen';


const Tab = createBottomTabNavigator();

function App() {
  return (
    <NavigationContainer>
      <Tab.Navigator
        screenOptions={({route}) => ({
          headerShown: false,
          tabBarIcon: ({focused, color, size}) => {
            let iconName;

            if (route.name === 'Home') {
              iconName = focused ? faHome : faHome;
            } else if (route.name === 'Exercise') {
              iconName = focused ? faRunning : faRunning;
            }  else if (route.name === 'Analyze') {
                iconName = focused ? faSquarePlus : faSquarePlus;
            } else if (route.name === 'Diet') {
              iconName = focused ? faMugHot : faMugHot ;
            } else if (route.name === 'Settings') {
              iconName = focused ? faCog : faCog;
            }
            return (
              <FontAwesomeIcon icon={iconName} size={size} color={color} />
            );
          },
          tabBarActiveTintColor: 'tomato',
          tabBarInactiveTintColor: 'black',
        })}>
        <Tab.Screen name="Home" component={HomeScreen} />
        <Tab.Screen name="Exercise" component={ExerciseScreen} />
        <Tab.Screen name="Analyze" component={AnalyzeScreen} />
        <Tab.Screen name="Diet" component={DietScreen} />
        <Tab.Screen name="Settings" component={SettingsScreen} />
      </Tab.Navigator>
    </NavigationContainer>
  );
}

export default App;
