[![Version](https://img.shields.io/cocoapods/v/MapGL.svg?style=flat)](https://cocoapods.org/pods/MapGL)

# 2GIS iOS MapGL

2GIS iOS MapGL is an SDK that allows you to add a [2GIS](https://2gis.ae/) map to your iOS application. It can be used to display the map in your interface, add custom markers and labels to it, draw routes and custom shapes, and highlight various objects on the map, such as buildings, roads, and others.

This SDK uses [WebKit](https://developer.apple.com/documentation/webkit) to render the map. If you need a more native solution (for example, if you don't want to display web content inside your app), take a look at [iOS Native SDK](https://docs.2gis.com/en/ios/native/maps/overview).

Full documentation, including more usage examples and detailed descriptions of all classes and methods, can be found at [docs.2gis.com/en/ios/webgl/maps/overview](https://docs.2gis.com/en/ios/webgl/maps/overview).


## Getting an access key

Usage of this SDK requires an API key to connect to 2GIS servers and retrieve the geographical data. This API key is unique to the SDK and cannot be used with other 2GIS SDKs. To obtain the key, contact us at [mapgl@2gis.com](mailto:mapgl@2gis.com).

Additionally, if you plan to draw routes on the map, you will need a separate key—a [Directions API](https://docs.2gis.com/en/api/navigation/directions/overview) key—to calculate and display an optimal route. To get it, fill the form at [partner.api.2gis.ru](http://partner.api.2gis.ru/) or contact us at [content@2gis.ru](mailto:content@2gis.ru).


## Installation

2GIS iOS MapGL is available through [CocoaPods](http://cocoapods.org/). To install it, add the following line to your Podfile:

```ruby
pod 'MapGL'
```


## Usage

To run the example app, open `HelloSDK.xcworkspace` and specify your API keys in `Example/HelloSDK/HelloVC.swift`:

```swift
enum Constants {
    static let apiKey = "YOUR_MAPGL_KEY"
    static let directionsApiKey = "YOUR_DIRECTIONS_KEY"
}
```


### Creating a map widget

To display a map, first add a [MapView](https://docs.2gis.com/en/ios/webgl/maps/reference/MapView) to your interface. MapView is inherited from [UIView](https://developer.apple.com/documentation/uikit/uiview), therefore you can use Storyboards, XIBs, or create it programmatically:

```swift
let map = MapView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
```

Then, initialize the widget by calling the _show()_ method and passing your API key. You can also pass the initial coordinates and the required zoom level. See the [API Reference](https://docs.2gis.com/en/ios/webgl/maps/reference/MapView#nav-lvl2--show) for the full list of options.

For example, the following code will show the map of Moscow centered around the Kremlin:

```swift
map.show(
    apiKey: "Your API key",
    center: CLLocationCoordinate2D(latitude: 55.7516, longitude: 37.6179),
    zoom: 16
)
```

![kremlin](https://user-images.githubusercontent.com/57934605/89265464-f33e6580-d64d-11ea-89eb-b4ee20f1dbb3.png)

To do something after the map has been initialized, you can write a [trailing closure](https://docs.swift.org/swift-book/LanguageGuide/Closures.html#ID102):

```swift
map.show(apiKey: "Your API key") { _ in
    // closure body
}
```


### Adding a marker

You can add any number of markers to a map. To add a marker, instantiate the [Marker](https://docs.2gis.com/en/ios/webgl/maps/reference/Marker) class and pass the object to the _add()_ method after the map was initialized. The only required parameter is the coordinates of the marker.

```swift
map.show(apiKey: "Your API key") { _ in
    let marker = Marker(coordinates: CLLocationCoordinate2D(latitude: 55.7516, longitude: 37.6179))
    map.add(marker)
}
```

![kremlin-marker](https://user-images.githubusercontent.com/57934605/89265704-4e705800-d64e-11ea-9c9e-1db831dcf34e.png)

Additionally, you can change the marker's appearance. You can specify the _image_ (as [UIImage](https://developer.apple.com/documentation/uikit/uiimage)) and the _anchor_ (where the image's hotspot should be located). See the [API Reference](https://docs.2gis.com/en/ios/webgl/maps/reference/Marker#nav-lvl2--anchor) for more information on how to specify the anchor.

![anchor](https://user-images.githubusercontent.com/57934605/89265659-40223c00-d64e-11ea-9b66-4525dfb94329.png)

```swift
let marker = Marker(
    coordinates: CLLocationCoordinate2D(latitude: 55.7516, longitude: 37.6179),
    image: UIImage(named: "pin")!,
    anchor: .bottom
)
```

To toggle marker visibility, you can use the methods _hide()_ and _show()_:

```swift
marker.hide()
marker.show()
```


### Adding a label

You can add multiple text labels to a map. To add a label, instantiate the [Label](https://docs.2gis.com/en/ios/webgl/maps/reference/Label) class by specifying the coordinates, the label text, the text color (as [UIColor](https://developer.apple.com/documentation/uikit/UIColor)), and the font size. Then, pass the resulting object to the _add()_ method of the map:

```swift
map.show(apiKey: "Your API key") { _ in
    let label = Label(
        center: CLLocationCoordinate2D(latitude: 55.7517, longitude: 37.6179),
        text: "The Kremlin label",
        color: .white,
        fontSize: 14
    )
    map.add(label)
}
```

![kremlin-label](https://user-images.githubusercontent.com/57934605/91268639-211b5380-e78f-11ea-9caa-db1f162e8cdc.png)

To hide the label, you can use the _hide()_ method. To show it again, use the _show()_ method.

```swift
label.hide()
label.show()
```


### Drawing custom shapes

Apart from image markers and text labels, you can draw custom shapes on a map, such as lines, circles and polygons. For each shape, you need to specify the coordinates and colors. Additionally, you can specify the Z-order to layer the shapes over one another.


#### Drawing a line

To draw a line on a map, instantiate the [Polyline](https://docs.2gis.com/en/ios/webgl/maps/reference/Polyline) class and pass the resulting object to the _add()_ method of the map.

_Polyline_ takes two types of parameters: coordinates of line points (array of [CLLocationCoordinate2D](https://developer.apple.com/documentation/corelocation/CLLocationCoordinate2D)) and up to three [PolylineStyle](https://docs.2gis.com/en/ios/webgl/maps/reference/PolylineStyle) objects to stylize the line.

To put it simply, a line can consist of up to three sub-lines drawn under each other. Each subline is customized by a separate parameter (_style1_ for the topmost subline, _style2_ for the middle subline, and _style3_ for the bottommost subline). _style2_ and _style3_ can be omitted to draw a line without sublines.

For example, to draw a simple line between two points, you can use code similar to the following:

```swift
let polyline = Polyline(
    points: [
        CLLocationCoordinate2D(latitude: 55.752164, longitude: 37.615487),
        CLLocationCoordinate2D(latitude: 55.751691, longitude: 37.621339)
    ],
    style1: PolylineStyle(color: .blue, width: 5)
)
map.add(polyline)
```

![kremlin-line1](https://user-images.githubusercontent.com/57934605/91268687-37291400-e78f-11ea-8a1d-2e99a67b71d9.png)

As a more complex example, to draw a line connecting several points and consisting of three sub-lines, you can use the following code:

```swift
let polyline = Polyline(
    points: [
        CLLocationCoordinate2D(latitude: 37.615104, longitude: 55.752375),
        CLLocationCoordinate2D(latitude: 37.618022, longitude: 55.752459),
        CLLocationCoordinate2D(latitude: 37.615189, longitude: 55.750829),
        CLLocationCoordinate2D(latitude: 37.617936, longitude: 55.750865)
    ],
    style1: PolylineStyle(color: .blue, width: 6),
    style2: PolylineStyle(color: .white, width: 10),
    style3: PolylineStyle(color: .black, width: 12)
)
map.add(polyline)
```

![kremlin-line2](https://user-images.githubusercontent.com/57934605/91268722-43ad6c80-e78f-11ea-9348-c934ecd9b4c2.png)

In this example, there is a white line drawn underneath the blue line, and a black line drawn underneath the white line. Together they create a line with a double stroke effect.


#### Drawing a circle

To draw a circle on a map, instantiate the [Circle](https://docs.2gis.com/en/ios/webgl/maps/reference/Circle) class and pass the resulting object to the _add()_ method of the map.

_Circle_ takes several parameters. To specify the center coordinates and size of the circle, specify _center_ and _radius_ (in meters) respectively. To specify fill color, use _fillColor_ (as [UIColor](https://developer.apple.com/documentation/uikit/UIColor)). To specify stroke color and width, use _strokeColor_ and _strokeWidth_. Finally, to specify the Z-order, use the _z_ parameter.

```swift
let circle = Circle(
    center: CLLocationCoordinate2D(latitude: 55.7516, longitude: 37.6179),
    radius: 100,
    fillColor: UIColor.blue.withAlphaComponent(0.2),
    strokeColor: .blue,
    strokeWidth: 2,
    z: 5
)
map.add(circle)
```

![kremlin-circle](https://user-images.githubusercontent.com/57934605/91268791-5a53c380-e78f-11ea-83b2-d3241d581769.png)


#### Drawing a polygon

To draw a polygon on a map, instantiate the [Polygon](https://docs.2gis.com/en/ios/webgl/maps/reference/Polygon) class and pass the resulting object to the _add()_ method of the map.

_Polygon_ takes several parameters. To specify the coordinates of polygon vertices, specify the _points_ parameter as an array of [CLLocationCoordinate2D](https://developer.apple.com/documentation/corelocation/CLLocationCoordinate2D). To specify fill color, use _fillColor_ (as [UIColor](https://developer.apple.com/documentation/uikit/UIColor)). To specify stroke color and width, use _strokeColor_ and _strokeWidth_. Finally, to specify the Z-order, use the _z_ parameter.

```swift
let polygon = Polygon(
    points: [
        CLLocationCoordinate2D(latitude: 55.7526, longitude: 37.6179),
        CLLocationCoordinate2D(latitude: 55.7506, longitude: 37.6161),
        CLLocationCoordinate2D(latitude: 55.7506, longitude: 37.6197)
    ],
    fillColor: UIColor.blue.withAlphaComponent(0.2),
    strokeColor: .blue,
    strokeWidth: 2,
    z: 5
)
map.add(polygon)
```

![kremlin-polygon](https://user-images.githubusercontent.com/57934605/91268817-6770b280-e78f-11ea-99e3-5d5c8c514f7b.png)


### Handling touch events

To receive touch coordinates, you can register a click listener on the map:

```swift
map.mapClick = { coordinates in
    let latitude = coordinates.latitude
}
```

To get the ID of the tapped object (building, road, marker, custom shape, etc.), implement the [optional method](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html#ID284) of the [MapViewDelegate](https://docs.2gis.com/en/ios/webgl/maps/reference/MapViewDelegate) protocol:

```swift
func mapView(_ mapView: MapView, didSelectObject object: MapObject) {
    let objectId = object.id
}
```

You can then use the ID of an object to highlight that object on the map (see [Highlighting objects](#highlighting-objects)). The same ID can also be used to get full information about the object via the [Places API](https://docs.2gis.com/en/api/search/places/overview), since the IDs are the same for all APIs.


### Highlighting objects

You can highlight map objects, such as buildings, roads, and others.

To do that, call the _setSelectedObjects()_ method and pass an array of IDs of the objects that need to be highlighted. You can get the IDs by adding a click listener to the map (see the [Handling touch events](#handling-touch-events) section).

```swift
map.setSelectedObjects(["48231504731808815", "23520539192555249"])
```

![highlight](https://user-images.githubusercontent.com/57934605/89265712-53cda280-d64e-11ea-98af-763d12105f96.gif)

To change the list of highlighted objects, simply call this method again, passing the array of new IDs.

To disable highlighting, pass an empty array to the _setSelectedObjects()_ method:

```swift
map.setSelectedObjects([])
```


### Routes

If you have a [Directions API key](#getting-an-access-key), you can draw routes on a map.

To draw a route, first create a [Directions](https://docs.2gis.com/en/ios/webgl/maps/reference/Directions) object by calling the [makeDirections()](https://docs.2gis.com/en/ios/webgl/maps/reference/MapView#nav-lvl2--makeDirections) method and passing your key:

```swift
let directions = map.makeDirections(with: "Your Directions API key")
```

Then, you can call the _showCarRoute()_ method and pass an array of up to 10 coordinates to calculate and display an optimal route:

```swift
directions.showCarRoute(points: [
    CLLocationCoordinate2D(latitude: 55.746069, longitude: 37.622074),
    CLLocationCoordinate2D(latitude: 55.747313, longitude: 37.615573)
])
```

![route](https://user-images.githubusercontent.com/57934605/91268865-7fe0cd00-e78f-11ea-872a-5e9d8a688cea.png)

To hide the route, call the _clear()_ method:

```swift
directions.clear()
```


## License

2GIS iOS MapGL is licensed under the BSD 2-Clause "Simplified" License. See the LICENSE file for more information.
