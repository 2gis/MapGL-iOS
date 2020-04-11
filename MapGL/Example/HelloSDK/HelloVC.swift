import UIKit
import CoreLocation
import MapGL

class HelloVC: UIViewController {

	private static let cardViewHeight: CGFloat = 100

	private var selectedMarker: Marker?

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

		self.map.centerDidChange = {
			[weak self] center in
			self?.mapCenterLabel.text = "Map center: \(center.latitude), \(center.longitude)"
		}

		self.map.zoomDidChange = {
			[weak self] zoom in
			self?.mapZoomLabel.text = "Map zoom: \(zoom)"
		}

		self.map.rotationDidChange = {
			[weak self] rotation in
			self?.mapRotationLabel.text = "Map rotation: \(rotation)"
		}

		self.map.pitchDidChange = {
			[weak self] pitch in
			self?.mapPitchLabel.text = "Map pitch: \(pitch)"
		}

		self.map.mapClick = {
			[weak self] coordinates in
			guard let self = self else { return }
			let marker = Marker(coordinates: coordinates, image: UIImage(named: "pin")!, anchor: .bottom)
			self.map.addMarker(marker)
			self.updateCardView(with: marker)
			self.selectedMarker = marker
			self.showCardView()
		}

		self.map.markerClick = {
			[weak self] marker in
			guard let self = self else { return }
			self.updateCardView(with: marker)
			self.selectedMarker = marker
			self.showCardView()
		}

		self.cardView.onClose = {
			[weak self] in
			guard let self = self else { return }
			self.selectedMarker = nil
			self.hideCardView()
		}

		self.cardView.onRemove = {
			[weak self] in
			guard let self = self else { return }
			self.selectedMarker?.remove()
			self.selectedMarker = nil
			self.hideCardView()
		}

		self.map.show(
			apiKey: "apiKey",
			center: CLLocationCoordinate2D(latitude: 25.23584, longitude: 55.31878),
			zoom: 16) {
				error in
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

	private func updateCardView(with marker: Marker) {
		self.cardView.title = "Marker"
		self.cardView.text = "Lon: \(marker.coordinates.longitude)\nLat: \(marker.coordinates.latitude)"
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

		let showMarkerAction = UIAlertAction(title: "Add Marker", style: .default) { _ in
			let marker = Marker(
				coordinates: self.map.mapCenter,
				image: UIImage(named: "pin")!,
				anchor: .bottom
			)
			self.map.addMarker(marker)
		}

		let showPolygon = UIAlertAction(title: "Show polygon", style: .default) { _ in
			let p = Polygon(
				points: [
					self.map.mapCenter,
					CLLocationCoordinate2D(latitude: 25.20, longitude: 55.4878),
					CLLocationCoordinate2D(latitude: 25.24584, longitude: 55.31878),
					self.map.mapCenter,
				],
				strokeColor: .red,
				strokeWidth: 5,
				fillColor: UIColor.blue.withAlphaComponent(0.5)
			)
			self.map.add(p)
		}
		let showCircle = UIAlertAction(title: "Show circle", style: .default) { _ in
			let circle = Circle(
				center: self.map.mapCenter,
				radius: 500
			)
			self.map.add(circle)
		}
		let removeMarkersAction = UIAlertAction(title: "Remove all objects", style: .destructive) { _ in
			self.map.removeAllMarkers()
			self.map.removeAllCircles()
			self.map.removeAllPolygons()
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		alert.addAction(showPolygon)
		alert.addAction(showCircle)
		alert.addAction(showMarkerAction)
		alert.addAction(removeMarkersAction)
		alert.addAction(cancelAction)

		self.present(alert, animated: true, completion: nil)
	}

	private func loadUI() {

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
