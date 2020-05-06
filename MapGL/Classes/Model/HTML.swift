enum HTML {
static let html = """
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<meta http-equiv="X-UA-Compatible" content="ie=edge" />
	<style>
		html,
		body,
		#map {
			margin: 0;
			width: 100%;
			height: 100%;
			overflow: hidden;
		}
	</style>

</head>

<body>
	<div id="map"></div>
	<script src="https://mapgl.2gis.com/api/js"></script>
	<script src="https://unpkg.com/@2gis/mapgl-clusterer@^1/dist/clustering.js"></script>
	<script>
		var objects = new Map();
		const container = document.getElementById('map');

		window.initializeMap = function(center, maxZoom, minZoom, zoom, maxPitch, minPitch, pitch, rotation, apiKey) {
			window.map = new mapgl.Map(container, {
				center: center,
				maxZoom: maxZoom,
				minZoom: minZoom,
				zoom: zoom,
				maxPitch: maxPitch,
				minPitch: minPitch,
				pitch: pitch,
				rotation: rotation,
				zoomControl: false,
				key: apiKey
			});

			window.map.on('click', (ev) => {
				window.webkit.messageHandlers.dgsMessage.postMessage({
					type: "mapClick",
					value: ev.lngLat
				});
			});

			window.map.on('centerend', (ev) => {
				window.webkit.messageHandlers.dgsMessage.postMessage({
					type: "centerChanged",
					value: window.map.getCenter()
				});
			});

			window.map.on('zoomend', (ev) => {
				window.webkit.messageHandlers.dgsMessage.postMessage({
					type: "zoomChanged",
					value: window.map.getZoom()
				});
			});

			window.map.on('rotationend', (ev) => {
				window.webkit.messageHandlers.dgsMessage.postMessage({
					type: "rotationChanged",
					value: window.map.getRotation()
				});
			});

			window.map.on('pitchend', (ev) => {
				window.webkit.messageHandlers.dgsMessage.postMessage({
					type: "pitchChanged",
					value: window.map.getPitch()
				});
			});
		}

		window.addMarker = function (options) {
			const marker = new mapgl.Marker(window.map, options);
			window.setupObject(options.id, marker);
		}
		window.addCluster = function (id, radius, markers) {
			const clusterer = new mapgl.Clusterer(window.map, {
				radius: radius,
			});
			clusterer.__id = id
			clusterer.on('click', (event) => {
				window.webkit.messageHandlers.dgsMessage.postMessage({
					type: "clusterClick",
					value: event.target.data,
					id: id
				});
			});
			objects.set(id, clusterer);
			window.updateCluster(id, markers);
		}
		window.updateCluster = function (id, markers) {
			const clusterer = objects.get(id);
			clusterer.load(markers);
		}
		window.hideObject = function (id) {
			const object = objects.get(id);
			object.hide();
		}
		window.showObject = function (id) {
			const marker = objects.get(id);
			marker.show();
		}
		window.setMarkerCoordinates = function (id, coordinates) {
			const marker = objects.get(id);
			marker.setCoordinates(coordinates);
		}
		window.addPolygon = function (options) {
			const polygon = new mapgl.Polygon(window.map, options);
			window.setupObject(options.id, polygon);
		}
		window.addCircle = function (options) {
			const circle = new mapgl.Circle(window.map, options);
			window.setupObject(options.id, circle);
		}
		window.addPolyline = function (options) {
			const polyline = new mapgl.Polyline(window.map, options);
			window.setupObject(options.id, polyline);
		}
		window.addLabel = function (options) {
			const label = new mapgl.Label(window.map, options);
			window.setupObject(options.id, label);
		}
		window.destroyObject = function (id) {
			const object = objects.get(id);
			object.destroy();
			objects.delete(id);
		}
		window.setupObject = function (id, object) {
			object.__id = id;
			objects.set(id, object);
			object.on('click', (event) => {
				window.webkit.messageHandlers.dgsMessage.postMessage({
					type: "objectClick",
					value: id
				});
			})
		}
		window.onerror = (msg, url, line, column, error) => {
			const message = {
				message: msg,
				url: url,
				line: line,
				column: column,
				error: JSON.stringify(error)
			}
			if (window.webkit) {
				window.webkit.messageHandlers.error.postMessage(message);
			} else {
				console.log("Error:", message);
			}
		};
		window.addEventListener('resize', () => window.map.invalidateSize());

	</script>
</body>

</html>
"""
}
