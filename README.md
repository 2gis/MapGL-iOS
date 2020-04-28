# MapGL
2GIS Maps SDK for iOS.

## Usage

### Get Access
As a first step to use MapGL you need to get the access key (contact us mapgl@2gis.com if you need one).

### Creating the Map
To show the map you should first create `MapView` object. It is a custom `UIView` so you can create it using XIB, Storyboard or in code.
```swift
let map = MapView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
```

### Showing the Map with default center and zoom
```swift
map.show(apiKey: "Your API access key")
```

### Showing the Map with custom center and zoom
```swift
map.show(
    apiKey: "Your API access key",
    center: CLLocationCoordinate2D(latitude: 25.23584, longitude: 55.31878),
    zoom: 16
)
```

### Showing the Marker with default image
All manipulations with the map is allowed after the `show(apiKey:)` method is completed.
```swift
map.show(apiKey: "apiKey") { _ in
    let marker = Marker(coordinates: map.mapCenter)
    map.addMarker(marker)
}
```

### Showing the Marker with custom image
```swift
let marker = Marker(
    coordinates: CLLocationCoordinate2D(latitude: 25.23584, longitude: 55.31878),
    image: UIImage(named: "pin")!,
    anchor: .bottom
)
map.addMarker(marker)
```

### Receiving Map Click Events
```swift
map.mapClick = { coordinates in
    // Do smth with map click coordinates
}
```

### Receiving Marker Click Events
```swift
map.markerClick = { marker in
    // Do smth with marker
}
```

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory.

## Installation
MapGL is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile.

```ruby
pod 'MapGL'
```

## License
MapGL is available under the BSD 2-Clause "Simplified" license. See the LICENSE file for more info.