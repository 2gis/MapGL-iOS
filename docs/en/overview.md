# MapGL iOS API

## Introduction

MapGL iOS API is a wrapper around [MapGL API](/en/mapgl/overview) that allows you to add a [2GIS map](https://2gis.ae/) to your iOS application.

Like the regular [iOS SDK](/en/ios/sdk/overview), it can be used to display the map in your interface and add various objects to it, but unlike iOS SDK, MapGL iOS API uses [WebKit](https://developer.apple.com/documentation/webkit) to render the map and is more limited in capabilities.

## Getting an access key

Usage of this SDK requires an `API key` to connect to 2GIS servers and retrieve the geographical data. This `API key` is unique to the SDK and cannot be used with other 2GIS SDKs.

Additionally, if you plan to draw routes on the map, you will need a separate key - a [Directions API](/en/api/navigation/directions/overview) key - to calculate and display an optimal route.

To obtain either of these API keys, fill in the form at [dev.2gis.com](https://dev.2gis.com/order).

## Installation

MapGL iOS API is available through [CocoaPods](https://cocoapods.org/). To install it, add the following line to your Podfile:

```
pod 'MapGL'
```

[![Version](https://img.shields.io/cocoapods/v/MapGL.svg?style=social&logo=cocoapods&label=version)](https://cocoapods.org/pods/MapGL)

After that, you should be good to go. Check the [Examples](/en/ios/mapgl/maps/examples) section to see how to display the map in your application. Alternatively, check the [API Reference](/en/ios/mapgl/maps/reference) to learn more about specific classes and methods.

Also, you could visit [the GitHub repository](https://github.com/2gis/MapGL-iOS) to learn more about the SDK and get familiar with sample project.

## License

MapGL iOS API is licensed under the BSD 2-Clause "Simplified" License. See the [LICENSE](https://github.com/2gis/MapGL-iOS/blob/master/LICENSE) file for more information.
