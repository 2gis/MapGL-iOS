# Примеры

## Использование

Для запуска примера склонируйте проект HelloSDK (`./HelloSDK.xcworkspace/`) из [GitHub-репозитория 2GIS](https://github.com/2gis/MapGL-iOS) и задайте ваши ключи API в файле `./Example/HelloSDK/HelloVC.swift`:

```swift
enum Constants {
    static let apiKey = "YOUR_MAPGL_KEY"
    static let directionsApiKey = "YOUR_DIRECTIONS_KEY"
}
```

## Создание виджета карты

Чтобы отобразить карту, для начала добавьте [MapView](/en/ios/webgl/maps/reference/MapView) в ваш пользовательский интерфейс. MapView является наследником класса [UIView](https://developer.apple.com/documentation/uikit/uiview), так что вы сможете использовать Storyboards и XIBs или создавать их программно:

```swift
let map = MapView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
```

Затем инициализируйте виджет: вызовите метод `show()` и передайте в него свой ключ API. Вы также можете передать начальные координаты и необходимый уровень приближения. Полный список параметров смотрите в [описании API](/en/ios/webgl/maps/reference/MapView#nav-lvl2--show).

Например, приведённый ниже фрагмент кода показывает карту Москвы с Кремлём в центре карты:

```swift
map.show(
    apiKey: "Your API key",
    center: CLLocationCoordinate2D(latitude: 55.7516, longitude: 37.6179),
    zoom: 16
)
```

![kremlin](https://user-images.githubusercontent.com/57934605/89265464-f33e6580-d64d-11ea-89eb-b4ee20f1dbb3.png)

Для вызова какой-либо функции после инициализации карты вы можете написать [trailing closure](https://docs.swift.org/swift-book/LanguageGuide/Closures.html#ID102):

```swift
map.show(apiKey: "Your API key") { _ in
    // closure body
}
```

## Добавление маркера

Вы можете добавить на карту любое количество маркеров. Для добавления маркера создайте экземпляр класса [Marker](/en/ios/webgl/maps/reference/Marker) и передайте этот объект в метод `add()` после инициализации карты. Из параметров вам нужно задать только координаты маркера.

```swift
map.show(apiKey: "Your API key") { _ in
    let marker = Marker(coordinates: CLLocationCoordinate2D(latitude: 55.7516, longitude: 37.6179))
    map.add(marker)
}
```

![kremlin-marker](https://user-images.githubusercontent.com/57934605/89265704-4e705800-d64e-11ea-9c9e-1db831dcf34e.png)

Кроме того, вы можете изменить внешний вид маркера. Вы можете задать изображение в `image` (как экземпляр класса [UIImage](https://developer.apple.com/documentation/uikit/uiimage)) и якорь (координаты отображения маркера) в `anchor`. Более подробную информацию о том, как задать якорь, смотрите в [описании API](/en/ios/webgl/maps/reference/Marker#nav-lvl2--anchor). 

![anchor](https://user-images.githubusercontent.com/57934605/89265659-40223c00-d64e-11ea-9b66-4525dfb94329.png)

```swift
let marker = Marker(
    coordinates: CLLocationCoordinate2D(latitude: 55.7516, longitude: 37.6179),
    image: UIImage(named: "pin")!,
    anchor: .bottom
)
```

Для переключения видимости маркера используйте методы `hide()` и `show()`:

```swift
marker.hide()
marker.show()
```

## Добавление текстовой метки

Вы можете добавлять на карту текстовые метки. Для этого создайте экземпляр класса [Label](/en/ios/webgl/maps/reference/Label), задав координаты, текст метки, цвет текста (как экземпляр класса [UIColor](https://developer.apple.com/documentation/uikit/UIColor)) и размер шрифта. Затем передайте получившийся объект в метод карты `add()`:

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

Чтобы скрыть метку, используйте метод `hide()`. Чтобы снова показать её, используйте метод `show()`.

```swift
label.hide()
label.show()
```

## Отрисовка пользовательских фигур

Помимо маркеров и текстовых меток вы можете отображать на карте другие объекты: линии, круги и многоугольники. Для каждой фигуры вам нужно задать координаты и цвета. Кроме того, вы можете задать Z-координату, чтобы упорядочить фигуры относительно друг друга.

### Отрисовка линии

Чтобы нарисовать на карте линию, создайте экземпляр класса [Polyline](/en/ios/webgl/maps/reference/Polyline) и передайте полученный объект в метод карты `add()`.

Конструктор класса `Polyline` принимает два типа параметров: координаты точек, лежащих на линии (массив координат [CLLocationCoordinate2D](https://developer.apple.com/documentation/corelocation/CLLocationCoordinate2D)), и до трёх объектов класса [PolylineStyle](/en/ios/webgl/maps/reference/PolylineStyle) для применения стилей к линии.

Простыми словами, линия может состоять из под-линий (до трёх штук), наложенных друг на друга. Каждая под-линия настраивается отдельным параметром (`style1` для самой верхней под-линии, `style2` для средней и `style3` для нижней). `style2` и `style3` можно опустить для отрисовки линии без под-линий.

Например, для отрисовки простой линии между двумя точками вы можете использовать подобный код:

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

В качестве более сложного примера, вы можете использовать следующий код для отрисовки линии, соединяющей несколько точек и состоящей из трёх под-линий:

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

В этом примере под синей линией рисуется белая, а под белой - черная. В результате получается линия с эффектом двойной обводки.

### Отрисовка круга

Чтобы нарисовать на карте круг, создайте экземпляр класса [Circle](/en/ios/webgl/maps/reference/Circle) и передайте полученный объект в метод карты `add()`.

Конструктор класса `Circle` принимает несколько параметров. Для определения координат центра и размера круга задайте значения (в метрах) соответствующих параметров `center` и `radius`. Для выбора цвета заливки используйте `fillColor`, передав экземпляр класса [UIColor](https://developer.apple.com/documentation/uikit/UIColor). Чтобы задать цвет и толщину линии, используйте `strokeColor` и `strokeWidth`. Наконец, чтобы задать порядок по координате Z, используйте параметр `z`.

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

### Отрисовка многоугольника

Чтобы нарисовать на карте многоугольник, создайте экземпляр класса [Polygon](/en/ios/webgl/maps/reference/Polygon) и передайте полученный объект в метод карты `add()`.

Конструктор класса `Polygon` принимает несколько параметров. Для определения координат вершин многоугольника задайте значение параметра `points` как массив координат [CLLocationCoordinate2D](https://developer.apple.com/documentation/corelocation/CLLocationCoordinate2D). Для выбора цвета заливки используйте `fillColor`, передав экземпляр класса [UIColor](https://developer.apple.com/documentation/uikit/UIColor). Чтобы задать цвет и толщину линии, используйте `strokeColor` и `strokeWidth`. Наконец, чтобы задать порядок по координате Z, используйте параметр `z`.

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

## Обработка событий нажатия

Для получения координат нажатия на карту вы можете добавить для неё click listener:

```
map.mapClick = { coordinates in
    let latitude = coordinates.latitude
}
```

Чтобы получить ID объекта, на который произведено нажатие (здание, дорога, рынок, произвольная фигура и т.д.), реализуйте [дополнительный метод](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html#ID284) протокола [MapViewDelegate](/en/ios/webgl/maps/reference/MapViewDelegate):

```swift
func mapView(_ mapView: MapView, didSelectObject object: MapObject) {
    let objectId = object.id
}
```

После этого вы сможете использовать ID объекта для выделения его на карте (подробнее в разделе [Выделение объектов](/ru/ios/webgl/maps/examples#nav-lvl1--Выделение_объектов)). Этот же ID можно использовать для получения полной информации об объекте через другие API, например, [Places API](/ru/api/search/places/overview), так как для всех API используется одинаковый ID.

## Выделение объектов

Вы можете выделять на карте объекты: здания, дороги и т. д.

Для этого вызовите метод `setSelectedObjects()`, передав ему массив ID объектов, которые нужно выделить. Вы можете получить ID объектов, добавив для карты click listener (подробнее в разделе [Обработка событий нажатия](#nav-lvl1--Обработка_событий_нажатия)).

```swift
map.setSelectedObjects(["48231504731808815", "23520539192555249"])
```

![highlight](https://user-images.githubusercontent.com/57934605/89265712-53cda280-d64e-11ea-98af-763d12105f96.gif)

Чтобы изменить список выделенных объектов, вызовите этот же метод, передав в него массив новых ID.

Чтобы убрать все выделения с карты, передайте в метод `setSelectedObjects()` пустой массив:

```swift
map.setSelectedObjects([])
```

## Маршруты

Если у вас есть [ключ Directions API](/ru/ios/webgl/maps/overview#nav-lvl1--Получение_ключа_доступа), вы можете прокладывать маршруты на карте.

Чтобы проложить маршрут, сперва создайте объект класса [Directions](/en/ios/webgl/maps/reference/Directions): вызовите метод [makeDirections()](/en/ios/webgl/maps/reference/MapView#nav-lvl2--makeDirections) и передайте свой ключ:

```swift
let directions = map.makeDirections(with: "Your Directions API key")
```

Затем вы можете вызвать метод `showCarRoute()` и передать массив с координатами (до 10 точек), чтобы вычислить и отобразить оптимальный маршрут:

```swift
directions.showCarRoute(points: [
    CLLocationCoordinate2D(latitude: 55.746069, longitude: 37.622074),
    CLLocationCoordinate2D(latitude: 55.747313, longitude: 37.615573)
])
```

![route](https://user-images.githubusercontent.com/57934605/91268865-7fe0cd00-e78f-11ea-872a-5e9d8a688cea.png)

Чтобы скрыть маршрут, вызовите метод `clear()`:

```swift
directions.clear()
```

## Изменение стиля карты

Вы можете изменять стиль карты с помощью метода `setStyle (by:)`. В первом аргументе метода передайте идентификатор стиля карты. По умолчанию используется светлый стиль, которому соответствует идентификатор `c080bb6a-8134-4993-93a1-5b4d8c36a59b`. В будущем могут быть добавлены новые стили.

Как задать светлую тему (пример):

```swift
map.setStyle (by: "c080bb6a-8134-4993-93a1-5b4d8c36a59b")
```

Как задать тёмную тему (пример):

```swift
map.setStyle (by: "e05ac437-fcc2-4845-ad74-b1de9ce07555")
```

Также можно задать стиль карты при её инициализации (подробнее в разделе [Создание виджета карты](#nav-lvl1--Создание_виджета_карты)). Для этого при инициализации карты используйте дополнительный аргумент `mapStyleId`.
