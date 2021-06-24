# 2GIS MapGL iOS API
[![Version](https://img.shields.io/cocoapods/v/MapGL.svg?style=flat)](https://cocoapods.org/pods/MapGL)

2GIS MapGL iOS API is a wrapper around [MapGL API](https://docs.2gis.com/en/mapgl/overview) that allows you to add a [2GIS map](https://2gis.ae/) to your iOS application.

Like the regular [iOS SDK](https://docs.2gis.com/en/ios/sdk/overview), it can be used to display the map in your interface and add various objects to it, but unlike iOS SDK, MapGL iOS API uses [WebKit](https://developer.apple.com/documentation/webkit) to render the map and is more limited in capabilities.

## Getting API keys

Usage of this SDK requires an API key to connect to 2GIS servers and retrieve the geographical data. This API key is unique to the SDK and cannot be used with other 2GIS SDKs.

Additionally, if you plan to draw routes on the map, you will need a separate key - a [Directions API](https://docs.2gis.com/en/api/navigation/directions/overview) key - to calculate and display an optimal route. 

To obtain either of these API keys, fill in the form at [dev.2gis.com](https://dev.2gis.com/order/).

## Installation

MapGL iOS API is available through [CocoaPods](http://cocoapods.org/). To install it, add the following line to your Podfile:

```ruby
pod 'MapGL'
```

## Running the demo app

To run the demo app, clone this Git repository, open `HelloSDK.xcworkspace` and specify your API keys in `Example/HelloSDK/HelloVC.swift`:

```swift
enum Constants {
    static let apiKey = "YOUR_MAPGL_KEY"
    static let directionsApiKey = "YOUR_DIRECTIONS_KEY"
}
```

## Documentation

Full documentation, including [usage examples](https://docs.2gis.com/en/ios/mapgl/maps/examples) and [API reference](https://docs.2gis.com/en/ios/mapgl/maps/reference/MapView) with detailed descriptions of all classes and methods, can be found at [docs.2gis.com](https://docs.2gis.com/en/ios/mapgl/maps/overview).

## License

The demo application is licensed under the BSD 2-Clause "Simplified" License. See the [LICENSE](https://github.com/2gis/MapGL-iOS/blob/master/LICENSE) file for more information.
