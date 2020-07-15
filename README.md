# MapGL
[![Version](https://img.shields.io/cocoapods/v/MapGL.svg?style=flat)](https://cocoapods.org/pods/MapGL)

2GIS Maps SDK for iOS.

- [Documentation](https://docs.2gis.com/en/ios/webgl/maps/reference/MapView)

<p float="left">
  <img src="https://github.com/2gis/MapGL-iOS/raw/master/Example/Screenshots/example.jpg" width="300" />
  <img src="https://github.com/2gis/MapGL-iOS/raw/master/Example/Screenshots/route.jpg" width="300" /> 
</p>

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

### Showing the Circle

```swift
let circle = Circle(
  center: CLLocationCoordinate2D(latitude: 25.23584, longitude: 55.31878),
  radius: 500,
  strokeColor: .red,
  strokeWidth: 5,
  fillColor: UIColor.lightGray.withAlphaComponent(0.5)
)
map.add(circle)
```


### Showing the Polygon

```swift
let polygon = Polygon(
  points: [
    CLLocationCoordinate2D(latitude: 25.20, longitude: 55.4478),
    CLLocationCoordinate2D(latitude: 25.20, longitude: 55.4878),
    CLLocationCoordinate2D(latitude: 25.24584, longitude: 55.31878),
  ],
  strokeColor: .red,
  strokeWidth: 5,
  fillColor: UIColor.blue.withAlphaComponent(0.5)
)
map.add(polygon)
```

### Showing the Polyline

```swift
let polyline = Polyline(
  points: [
    CLLocationCoordinate2D(latitude: 25.30, longitude: 55.378),
    CLLocationCoordinate2D(latitude: 25.20, longitude: 55.378),
  ],
  style1: PolylineStyle(color: .red, width: 5),
  style2: PolylineStyle(color: .green, width: 9),
  style3: PolylineStyle(color: .blue, width: 13)
)
map.add(polyline)
```


### Showing the Label

```swift
let label = Label(
  center: CLLocationCoordinate2D(latitude: 25.30, longitude: 55.378),
  color: .red,
  text: "Demo label",
  fontSize: 24
)
map.add(label)
```

### Selecting the building, road and others objects on map

```swift
let entity = MapEntity(
  id: "13933647002609599"
)
map.add(entity)
```

### Receiving Map Click Events

```swift
map.mapClick = { coordinates in
  // Do smth with map click coordinates
}
```

### Receiving Object Click Events

```swift
func mapView(_ mapView: MapView, didSelectObject object: MapObject) {
  // do smth with object
}
```

### Show route on map

[To get directions API key please visit](http://partner.api.2gis.ru) or contact [content@2gis.ru]()

```swift
let directions = map.makeDirections(with: "Your directions api key")
directions.showCarRoute(points: [
  CLLocationCoordinate2D(latitude: 25.20, longitude: 55.4878),
  CLLocationCoordinate2D(latitude: 25.20, longitude: 55.5278),
])
```

### Hide route from map
```swift
directions.clear()
```

### Hiding and showing objects

Some objects (Marker, Label, Building) can be shown/hidden via `.show()` or `.hide()` method

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
