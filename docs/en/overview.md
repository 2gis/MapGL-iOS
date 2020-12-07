# Overview

## Introduction

2GIS iOS MapGL is an SDK that allows you to add a [2GIS](https://2gis.ae/) map to your iOS application. It can be used to display the map in your interface, add custom markers and labels to it, draw routes and custom shapes, and highlight various objects on the map, such as buildings, roads, and others.

This SDK uses [WebKit](https://developer.apple.com/documentation/webkit) to render the map. If you need a more native solution (for example, if you don't want to display web content inside your app), take a look at `iOS Native SDK`.

## Getting an access key

Usage of this SDK requires an `API key` to connect to 2GIS servers and retrieve the geographical data. This `API key` is unique to the SDK and cannot be used with other 2GIS SDKs. To obtain the key, contact us at [mapgl@2gis.com](mailto:mapgl@2gis.com).

Additionally, if you plan to draw routes on the map, you will need a separate key - a [Directions API](/en/api/navigation/directions/overview) key - to calculate and display an optimal route. To get it, fill the form at [partner.api.2gis.ru](https://partner.api.2gis.ru/) or contact us at [content@2gis.ru](mailto:content@2gis.ru).

## Installation

2GIS iOS MapGL is available through [CocoaPods](https://cocoapods.org/). To install it, add the following line to your Podfile:

```
pod 'MapGL'
```

[![Version](https://img.shields.io/cocoapods/v/MapGL.svg?style=social&logo=cocoapods&label=version)](https://cocoapods.org/pods/MapGL)

After that, you should be good to go. Check the [Examples](/en/ios/webgl/maps/examples) section to see how to display the map in your application. Alternatively, check the [API Reference](/en/ios/webgl/maps/reference) to learn more about specific classes and methods.

## License

2GIS iOS MapGL is licensed under the BSD 2-Clause "Simplified" License. See the [LICENSE](https://github.com/2gis/MapGL-iOS/blob/master/LICENSE) file for more information.
