import UIKit
import CoreLocation
import MapGL

/// contact us mapgl@2gis.com if you need one
enum Constants {
	static let apiKey = ""
	static let directionsApiKey = ""
}

class HelloVC: UIViewController {

	private static let cardViewHeight: CGFloat = 100

	private lazy var map: MapView = {
		return MapView(frame: .zero)
	}()

	private lazy var mapCenterLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 8)
		label.textColor = .black
		return label
	}()

	private lazy var mapZoomLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 8)
		label.textColor = .black
		return label
	}()

	private lazy var mapRotationLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 8)
		label.textColor = .black
		return label
	}()

	private lazy var mapPitchLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 8)
		label.textColor = .black
		return label
	}()

	private lazy var zoomInButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setImage(UIImage(named: "zoomInButton"), for: .normal)
		button.addTarget(self, action: #selector(self.zoomIn), for: .touchUpInside)
		return button
	}()

	private lazy var zoomOutButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setImage(UIImage(named: "zoomOutButton"), for: .normal)
		button.addTarget(self, action: #selector(self.zoomOut), for: .touchUpInside)
		return button
	}()

	private lazy var locationButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setImage(UIImage(named: "locationButton"), for: .normal)
		button.addTarget(self, action: #selector(self.showLocation), for: .touchUpInside)
		return button
	}()

	private lazy var menuButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setImage(UIImage(named: "details"), for: .normal)
		button.addTarget(self, action: #selector(self.showMenu), for: .touchUpInside)
		return button
	}()

	private lazy var cardView: CardView = {
		let view = CardView(frame: .zero)
		view.backgroundColor = .white
		view.layer.cornerRadius = 20
		view.isHidden = true
		view.transform = CGAffineTransform(translationX: 0, y: self.view.safeArea.bottom + HelloVC.cardViewHeight + 16)
		return view
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.loadUI()

		self.map.centerDidChange = { [weak self] center in
			self?.mapCenterLabel.text = "Map center: \(center.latitude), \(center.longitude)"
		}

		self.map.zoomDidChange = { [weak self] zoom in
			self?.mapZoomLabel.text = "Map zoom: \(zoom)"
		}

		self.map.rotationDidChange = { [weak self] rotation in
			self?.mapRotationLabel.text = "Map rotation: \(rotation)"
		}

		self.map.pitchDidChange = { [weak self] pitch in
			self?.mapPitchLabel.text = "Map pitch: \(pitch)"
		}

		self.cardView.onClose = {
			[weak self] in
			guard let self = self else { return }
			self.cardView.onRemove = nil
			self.hideCardView()
		}
		assert(!Constants.apiKey.isEmpty, "contact us mapgl@2gis.com if you need one")
		self.map.show(
			apiKey: Constants.apiKey,
			center: CLLocationCoordinate2D(latitude: 25.23584, longitude: 55.31878),
			zoom: 16,
			autoHideOSMCopyright: true
		) { error in
			print(error ?? "Map initialized")
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.map.frame = self.view.bounds
	}

	@objc private func zoomIn() {
		self.map.zoomIn()
	}

	@objc private func zoomOut() {
		self.map.zoomOut()
	}

	@objc private func showLocation() {
		self.map.mapCenter = CLLocationCoordinate2D(latitude: 25.23584, longitude: 55.31878)
		self.map.mapZoom = 16
	}

	private func showCardView(object: MapObject) {
		self.cardView.title = object.title
		self.cardView.text = object.text
		self.cardView.onRemove = {
			[weak self] in
			guard let self = self else { return }
			self.map.remove(object)
			self.hideCardView()
		}
		self.showCardView()
	}

	private func showCardView() {
		self.cardView.layer.removeAllAnimations()
		UIView.animate(
			withDuration: 0.5,
			delay: 0,
			usingSpringWithDamping: 0.5,
			initialSpringVelocity: 0,
			options: [.curveEaseOut, .beginFromCurrentState],
			animations: {
				self.cardView.isHidden = false
				self.cardView.transform = .identity
		}, completion: nil)
	}

	private func hideCardView() {
		self.cardView.layer.removeAllAnimations()
		UIView.animate(
			withDuration: 0.3,
			delay: 0,
			usingSpringWithDamping: 1,
			initialSpringVelocity: 0,
			options: [.curveEaseIn, .beginFromCurrentState],
			animations: {
				self.cardView.isHidden = false
				self.cardView.transform = CGAffineTransform(translationX: 0, y: self.view.safeArea.bottom + HelloVC.cardViewHeight + 16)
		}, completion: { completed in
			if completed {
				self.cardView.isHidden = true
			}
		})
	}

	@objc private func showMenu() {

		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alert.popoverPresentationController?.sourceView = self.menuButton
		alert.popoverPresentationController?.sourceRect = CGRect(x: self.menuButton.bounds.midX, y: -16, width: 0, height: 0)

		let showRoute = UIAlertAction(title: "Show Route, hide in 10 sec", style: .default) { _ in
			assert(!Constants.directionsApiKey.isEmpty, "contact us mapgl@2gis.com if you need one")
			let directions = self.map.makeDirections(with: Constants.directionsApiKey)
			let points = [
				self.map.mapCenter,
				CLLocationCoordinate2D(latitude: 25.20, longitude: 55.4878),
				CLLocationCoordinate2D(latitude: 25.20, longitude: 55.5278),
			]
			directions.showCarRoute(points: points) { [weak self] result in
				switch result {
				case .success:
					break
				case .failure(let error):
					self?.showError(error)
				}
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
				directions.clear()
			}
		}
		let showMarkerAction = UIAlertAction(title: "Add Marker", style: .default) { _ in
			let marker = Marker(
				coordinates: self.map.mapCenter,
				image: UIImage(named: "pin")!,
				anchor: .bottom
			)
			self.map.add(marker)
		}
		let showCluster = UIAlertAction(title: "Show cluster", style: .default) { _ in
			let cluster = Cluster(radius: 50, markers: [
				Marker(coordinates: self.map.mapCenter),
				Marker(coordinates: CLLocationCoordinate2D(latitude: 25.20, longitude: 55.4878)),
				Marker(coordinates: CLLocationCoordinate2D(latitude: 25.20, longitude: 55.4978)),
				Marker(coordinates: CLLocationCoordinate2D(latitude: 25.20, longitude: 55.5278)),
			])
			self.map.add(cluster)
		}
		let showPolygon = UIAlertAction(title: "Show polygon", style: .default) { _ in
			let p = Polygon(
				points: [
					self.map.mapCenter,
					CLLocationCoordinate2D(latitude: 25.20, longitude: 55.4878),
					CLLocationCoordinate2D(latitude: 25.24584, longitude: 55.31878),
				],
				strokeColor: .red,
				strokeWidth: 5,
				fillColor: UIColor.blue.withAlphaComponent(0.5),
				z: 4
			)
			self.map.add(p)
		}
		let showCircle = UIAlertAction(title: "Show circle", style: .default) { _ in
			let circle = Circle(
				center: self.map.mapCenter,
				radius: 500,
				strokeColor: .red,
				strokeWidth: 5,
				fillColor: UIColor.lightGray.withAlphaComponent(0.5),
				z: 5
			)
			self.map.add(circle)
		}
		let showLabel = UIAlertAction(title: "Show label, hide in 5 sec", style: .default) { _ in
			let image = UIImage(named: "stretchable")!.resizableImage(
				withCapInsets: UIEdgeInsets(top: 50, left: 10, bottom: 5, right: 10)
			)
			let bgImage = LabelImage(
				image: image,
				padding: UIEdgeInsets(top: 30, left: 15, bottom: 10, right: 25)
			)
			let label = Label(
				center: self.map.mapCenter,
				color: .red,
				text: "Demo label",
				fontSize: 24,
				backgroundImage: bgImage
			)
			self.map.add(label)
			DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
				label.hide()
			}
		}
		let showPolyline = UIAlertAction(title: "Show polyline", style: .default) { _ in
			let polyline = Polyline(
				points: [
					self.map.mapCenter,
					CLLocationCoordinate2D(latitude: 25.20, longitude: 55.378),
				],
				style1: PolylineStyle(color: .red, width: 5),
				style2: PolylineStyle(color: .green, width: 9),
				style3: PolylineStyle(color: .blue, width: 13)
			)
			self.map.add(polyline)
		}
		let showBuilding = UIAlertAction(title: "Select Building, deselect in 5 sec", style: .default) { _ in
			let entity = MapEntity(id: "13933647002609599")
			self.map.add(entity)
			DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
				entity.deselect()
			}
		}
		let removeMarkersAction = UIAlertAction(title: "Remove all objects", style: .destructive) { _ in
			self.map.removeAllObjects()
		}
		let delesectAllObjects = UIAlertAction(title: "Deselect all objects", style: .destructive) { _ in
			self.map.setSelectedObjects([])
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		alert.addAction(showRoute)
		alert.addAction(showBuilding)
		alert.addAction(showLabel)
		alert.addAction(showCluster)
		alert.addAction(showPolyline)
		alert.addAction(showPolygon)
		alert.addAction(showCircle)
		alert.addAction(showMarkerAction)
		alert.addAction(removeMarkersAction)
		alert.addAction(delesectAllObjects)
		alert.addAction(cancelAction)
		self.present(alert, animated: true, completion: nil)
	}

	private func showError(_ error: Error) {
		let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alert.addAction(okAction)
		self.present(alert, animated: true, completion: nil)
	}

	private func loadUI() {

		self.map.delegate = self
		self.view.addSubview(self.map)
		self.view.addSubview(self.mapCenterLabel)
		self.view.addSubview(self.mapZoomLabel)
		self.view.addSubview(self.mapRotationLabel)
		self.view.addSubview(self.mapPitchLabel)
		self.view.addSubview(self.zoomInButton)
		self.view.addSubview(self.zoomOutButton)
		self.view.addSubview(self.locationButton)
		self.view.addSubview(self.menuButton)
		self.view.addSubview(self.cardView)

		self.mapCenterLabel.translatesAutoresizingMaskIntoConstraints = false
		self.mapZoomLabel.translatesAutoresizingMaskIntoConstraints = false
		self.mapRotationLabel.translatesAutoresizingMaskIntoConstraints = false
		self.mapPitchLabel.translatesAutoresizingMaskIntoConstraints = false
		self.zoomInButton.translatesAutoresizingMaskIntoConstraints = false
		self.zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
		self.menuButton.translatesAutoresizingMaskIntoConstraints = false
		self.locationButton.translatesAutoresizingMaskIntoConstraints = false
		self.cardView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			self.mapCenterLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLeadingAnchor, constant: 8),
			self.mapCenterLabel.topAnchor.constraint(equalTo: self.view.safeAreaTopAnchor, constant: 8),
			])

		NSLayoutConstraint.activate([
			self.mapZoomLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLeadingAnchor, constant: 8),
			self.mapZoomLabel.topAnchor.constraint(equalTo: self.mapCenterLabel.bottomAnchor, constant: 4),
			])

		NSLayoutConstraint.activate([
			self.mapRotationLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLeadingAnchor, constant: 8),
			self.mapRotationLabel.topAnchor.constraint(equalTo: self.mapZoomLabel.bottomAnchor, constant: 4),
			])

		NSLayoutConstraint.activate([
			self.mapPitchLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLeadingAnchor, constant: 8),
			self.mapPitchLabel.topAnchor.constraint(equalTo: self.mapRotationLabel.bottomAnchor, constant: 4),
			])

		NSLayoutConstraint.activate([
			self.zoomInButton.widthAnchor.constraint(equalToConstant: 40),
			self.zoomInButton.heightAnchor.constraint(equalToConstant: 40),
			self.zoomInButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -22),
			self.zoomInButton.trailingAnchor.constraint(equalTo: self.view.safeAreaTrailingAnchor, constant: -16),
			])

		NSLayoutConstraint.activate([
			self.zoomOutButton.widthAnchor.constraint(equalToConstant: 40),
			self.zoomOutButton.heightAnchor.constraint(equalToConstant: 40),
			self.zoomOutButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 22),
			self.zoomOutButton.trailingAnchor.constraint(equalTo: self.view.safeAreaTrailingAnchor, constant: -16),
			])

		NSLayoutConstraint.activate([
			self.locationButton.widthAnchor.constraint(equalToConstant: 40),
			self.locationButton.heightAnchor.constraint(equalToConstant: 40),
			self.locationButton.trailingAnchor.constraint(equalTo: self.view.safeAreaTrailingAnchor, constant: -16),
			self.locationButton.bottomAnchor.constraint(equalTo: self.view.safeAreaBottomAnchor, constant: -16),
			])

		NSLayoutConstraint.activate([
			self.menuButton.widthAnchor.constraint(equalToConstant: 40),
			self.menuButton.heightAnchor.constraint(equalToConstant: 40),
			self.menuButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			self.menuButton.bottomAnchor.constraint(equalTo: self.view.safeAreaBottomAnchor, constant: -16),
			])

		NSLayoutConstraint.activate([
			self.cardView.heightAnchor.constraint(equalToConstant: HelloVC.cardViewHeight),
			self.cardView.leadingAnchor.constraint(equalTo: self.view.safeAreaLeadingAnchor, constant: 16),
			self.cardView.trailingAnchor.constraint(equalTo: self.view.safeAreaTrailingAnchor, constant: -16),
			self.cardView.bottomAnchor.constraint(equalTo: self.view.safeAreaBottomAnchor, constant: -16),
			])
	}

}

extension HelloVC: MapViewDelegate {

	func mapView(_ mapView: MapView, didSelectMarkers markers: [Marker], in cluster: Cluster) {
		self.cardView.title = "Cluster"
		self.cardView.text = markers.map { $0.coordinates.toCard() }.joined(separator: "\n")
		self.cardView.onRemove = {
			[weak self] in
			guard let self = self else { return }
			let removeIds = markers.map { $0.id }
			cluster.markers = cluster.markers.filter({
				!removeIds.contains($0.id)
			})
			self.hideCardView()
		}
		self.showCardView()
	}

	func mapView(_ mapView: MapView, didSelectObject object: MapObject) {
		self.showCardView(object: object)
		if let entity = object as? MapEntity {
			self.map.add(entity)
		}
	}

}

extension MapObject {
	var title: String {
		return type(of: self).description()
	}
	var text: String {
		if let marker = self as? Marker {
			return marker.coordinates.toCard()
		} else if let circle = self as? Circle {
			return circle.center.toCard()
		} else if let polygon = self as? Polygon {
			return polygon.points[0].toCard()
		} else if let polyline = self as? Polyline {
			return polyline.points[0].toCard()
		} else if let entity = self as? MapEntity {
			return entity.entityId
		}
		return ""
	}

}

extension CLLocationCoordinate2D {

	func toCard() -> String {
		"Lat: \(self.latitude) Lon: \(self.longitude)"
	}

}
