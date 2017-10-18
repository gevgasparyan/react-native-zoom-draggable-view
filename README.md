
# react-native-zoom-draggable-view

## iOS only. (android returns `View` component)

<img src="https://github.com/gevorg94/react-native-zoom-draggable-view/blob/master/readme_assets/demo.gif?raw=true" width="240">

## Getting started

`$ npm install react-native-zoom-draggable-view --save`


### Manual installation


#### iOS

1. In XCode, in the project navigator, create new group and name it `RNZoomDraggableView`.
2. Right click on `RNZoomDraggableView` group, `Add Files to [your project's name]`.
3. Go to `node_modules` ➜ `react-native-zoom-draggable-view/ios` and add `RNZoomDraggableView-Bridging-Header.h`, `RNZoomDraggableView.swift`, `RNZoomDraggableViewBridge.m`, `RNZoomDraggableViewManager.swift` files.
4. You may need to add `#import "React/RCTView.h"` to your `[your project's name]-Bridging-Header.h` file.
5. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNZoomDraggableViewPackage;` to the imports at the top of the file
  - Add `new RNZoomDraggableViewPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-zoom-draggable-view'
  	project(':react-native-zoom-draggable-view').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-zoom-draggable-view/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-zoom-draggable-view')
  	```


## Usage
```javascript
import { RNZoomDraggableView } from 'react-native-zoom-draggable-view';

  onTap = () => {
    console.log('onTap');
  };

  onTouchStart = ({ nativeEvent }) => {
    const { numberOfTouches } = nativeEvent;
    console.log('NumberOfTouches', numberOfTouches);
  };

  onTouchEnd = ({ nativeEvent }) => {
    const { numberOfTouches } = nativeEvent;
    console.log('NumberOfTouches', numberOfTouches);
  };

  onLongPress = ({ nativeEvent }) => {
    const { touchEnd } = nativeEvent;
    console.log('TouchEnd', touchEnd);
  };

  render() {
    return (
      <View style={{ flex: 1 }}>
        <ZoomDraggableView
          ref={ref => this.viewRef = ref}
          style={{ width: 350, height: 350 }}
          zoomScale={0.5} // initial Scale
          minimumZoomScale={0.2}
          maximumZoomScale={2}
          requiresMinScale={true}
          onTap={this.onTap}
          onTouchStart={this.onTouchStart}
          onTouchEnd={this.onTouchEnd}
          onLongPress={this.onLongPress}
          userInteractionEnabled={this.state.userInteractionEnabled}
          longPressEnabled={true}
        >
          <Image
            style={{ width: 700, height: 700 }}
            source={{ uri: 'yourImageSourcePath'}}
          />
        </ZoomDraggableView>
      </View>
    );
  }
```
  
