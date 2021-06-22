# 2GIS MapGL iOS API

## Введение

2GIS MapGL iOS API позволяет добавить [карту 2GIS](https://2gis.ru/) в ваше iOS-приложение.

В отличие от [iOS SDK](/ru/ios/sdk/overview), MapGL iOS использует [MapGL API](/ru/mapgl/overview) и [WebKit](https://developer.apple.com/documentation/webkit) для отображения карты и более ограничен в возможностях.

## Получение ключа доступа

Чтобы использовать этот SDK, необходим ключ API для подключения к серверам 2GIS и получения географических данных. Этот ключ доступа API уникален для конкретного SDK и не может быть использован с другими SDK от 2GIS.

Кроме того, если вы планируете прокладывать маршруты на карте, то для вычисления и отображения оптимального маршрута вам понадобится отдельный ключ API - для [Directions API](/ru/api/navigation/directions/overview).

Чтобы получить любой из этих ключей API, заполните форму на [dev.2gis.ru](https://dev.2gis.ru/order). 

## Установка

MapGL iOS API доступен через менеджер зависимостей [CocoaPods](https://cocoapods.org/). Для его установки добавьте следующую строку в ваш Podfile:

```
pod 'MapGL'
```

[![Version](https://img.shields.io/cocoapods/v/MapGL.svg?style=social&logo=cocoapods&label=version)](https://cocoapods.org/pods/MapGL)

После этого всё должно быть готово к работе. В разделе [Примеры](/ru/ios/mapgl/maps/examples) вы можете посмотреть, как добавить карту к вашему приложению. Или загляните в [описание API](/en/ios/mapgl/maps/reference), чтобы узнать больше о конкретных классах и методах.

Также доступен [GitHub-репозиторий](https://github.com/2gis/MapGL-iOS), в котором можно познакомиться с SDK и демонстрационным проектом.

## Лицензия

2GIS MapGL iOS API распространяется под упрощённой лицензией BSD 2-Clause. Дополнительную информацию можно найти в файле [LICENSE](https://github.com/2gis/MapGL-iOS/blob/master/LICENSE).
