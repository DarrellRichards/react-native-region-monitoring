
# react-native-region-monitoring

## Getting started

### NPM Install

`$ npm install react-native-region-monitoring --save`

### Yarn Install

`$ yarn add react-native-region-monitoring`

### Mostly automatic installation

`$ react-native link react-native-region-monitoring`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-region-monitoring` and add `RNRegionMonitoring.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNRegionMonitoring.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNRegionMonitoringPackage;` to the imports at the top of the file
  - Add `new RNRegionMonitoringPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-region-monitoring'
  	project(':react-native-region-monitoring').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-region-monitoring/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-region-monitoring')
  	```

## Usage
```javascript
import RegionTracker from 'react-native-region-monitoring';
```

### Config
```javascript

RegionTracker.config({
  url: 'https://geolocation.localtunnel.me/geolocation',
  exitRegion: true,
  enterRegion: true,
  radius: 15, // Meters
  backgroundTracking: true,
  pauseLocationUpdates: false
});
```
