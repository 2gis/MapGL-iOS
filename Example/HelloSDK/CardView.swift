import UIKit

class CardView : UIView {

	private lazy var titleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.systemFont(ofSize: 24)
		label.textColor = .black
		return label
	}()

	private lazy var textLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.systemFont(ofSize: 12)
		label.numberOfLines = 0
		label.textColor = .black
		return label
	}()

	private lazy var closeButton: UIButton = {
		let button = UIButton(type: .system)
		button.tintColor = .gray
		button.setImage(UIImage(named: "close"), for: .normal)
		button.addTarget(self, action: #selector(self.close), for: .touchUpInside)
		return button
	}()

	private lazy var removeButton: UIButton = {
		let button = UIButton(type: .system)
		button.tintColor = .gray
		button.setImage(UIImage(named: "trash"), for: .normal)
		button.addTarget(self, action: #selector(self.remove), for: .touchUpInside)
		return button
	}()

	var onClose: (() -> Void)?
	var onRemove: (() -> Void)?

	var title: String? {
		didSet {
			self.titleLabel.text = self.title
		}
	}

	var text: String? {
		didSet {
			self.textLabel.text = self.text
		}
	}

	override init(frame: CGRect) {
		super.init(frame: .zero)
		self.loadUI()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc private func close() {
		self.onClose?()
	}

	@objc private func remove() {
		self.onRemove?()
	}

	private func loadUI() {
		self.addSubview(self.titleLabel)
		self.addSubview(self.textLabel)
		self.addSubview(self.closeButton)
		self.addSubview(self.removeButton)

		self.closeButton.translatesAutoresizingMaskIntoConstraints = false
		self.removeButton.translatesAutoresizingMaskIntoConstraints = false
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
		self.textLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			self.closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			self.closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
			])
		NSLayoutConstraint.activate([
			self.removeButton.centerXAnchor.constraint(equalTo: self.closeButton.centerXAnchor),
			self.removeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
			])
		NSLayoutConstraint.activate([
			self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
			])
		NSLayoutConstraint.activate([
			self.textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			self.textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			self.textLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4),
			])
	}
}
