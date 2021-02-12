# 2GIS iOS MapGL
[![Version](https://img.shields.io/cocoapods/v/MapGL.svg?style=flat)](https://cocoapods.org/pods/MapGL)

2GIS iOS MapGL is an SDK that allows you to add a [2GIS map](https://2gis.ae/) to your iOS application. It can be used to display the map in your interface, add custom markers and labels to it, draw routes and custom shapes, and highlight various objects on the map, such as buildings, roads, and others.

This SDK uses [WebKit](https://developer.apple.com/documentation/webkit) to render the map. If you need a more native solution (for example, if you don't want to display web content inside your app), take a look at [iOS Native SDK](https://docs.2gis.com/en/ios/native/maps/overview).

Full documentation, including more usage examples and detailed descriptions of all classes and methods, can be found at [docs.2gis.com](https://docs.2gis.com/en/ios/webgl/maps/overview).


## Getting API Keys

Usage of this SDK requires an API key to connect to 2GIS servers and retrieve the geographical data. This API key is unique to the SDK and cannot be used with other 2GIS SDKs.

Additionally, if you plan to draw routes on the map, you will need a separate key—a [Directions API](https://docs.2gis.com/en/api/navigation/directions/overview) key—to calculate and display an optimal route. 

To obtain either of these API keys, fill in the form at [dev.2gis.ae](https://dev.2gis.ae/order/).


## Installation

2GIS iOS MapGL SDK is available through [CocoaPods](http://cocoapods.org/). To install it, add the following line to your Podfile:

```ruby
pod 'MapGL'
```


## Running Example App

To run the example app, clone this Git repository, open `HelloSDK.xcworkspace` and specify your API keys in `Example/HelloSDK/HelloVC.swift`:

```swift
enum Constants {
    static let apiKey = "YOUR_MAPGL_KEY"
    static let directionsApiKey = "YOUR_DIRECTIONS_KEY"
}
```


## Documentation

Full documentation, including [usage examples](https://docs.2gis.com/en/ios/webgl/maps/examples) and [API reference](https://docs.2gis.com/en/ios/webgl/maps/reference/MapView) with detailed descriptions of all classes and methods, can be found at [docs.2gis.com](https://docs.2gis.com/en/ios/webgl/maps/overview).


## License

2GIS iOS MapGL is licensed under the BSD 2-Clause "Simplified" License. See the [LICENSE](https://github.com/2gis/MapGL-iOS/blob/master/LICENSE) file for more information.
