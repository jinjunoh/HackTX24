import React from 'react';
import { StyleSheet } from 'react-native';
import { ARKit } from 'react-native-arkit';

const App = () => {
  return (
    <ARKit
      style={styles.container}
      planeDetection="horizontal" // Use string value for planeDetection
      debug
      lightEstimationEnabled
    >
      <ARKit.Box pos={{ x: 0, y: 0, z: 0 }} shape={{ width: 0.1, height: 0.1, length: 0.1, chamfer: 0.01 }} />
      <ARKit.Sphere pos={{ x: 0.2, y: 0, z: 0 }} shape={{ radius: 0.05 }} />
      <ARKit.Cylinder pos={{ x: 0.4, y: 0, z: 0 }} shape={{ radius: 0.05, height: 0.1 }} />
      {/* Add more shapes as needed */}
    </ARKit>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

export default App;
