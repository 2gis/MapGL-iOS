import SourceKittenFramework
import Foundation

class DocsParser {

	var nameObjectMap = [String: Object]()
	var allNameObjectMap = [String: [Object]]()
	var extensions = [String: [Object]]()

	func parse(_ docs: [SwiftDocs]) -> String {
		var nameRefMap = [String: String]()
		for doc in docs {
			if let substructures = doc.docsDictionary[.substructure]?.arrayOfDict {
				for substructure in substructures {
					if let object = substructure.object {
						nameRefMap[object.props.name] = object.refMap()
						self.allNameObjectMap.append(key: object.props.name, newValue: object)
						if substructure.kind == .extension {
							// собираем в кучу все экстеншены
							self.extensions.append(key: object.props.name, newValue: object)
						} else {
							// все что не экстеншены, считаем объектами
							assert(self.nameObjectMap[object.props.name] == nil)
							self.nameObjectMap[object.props.name] = object
						}
					}
					_ = substructure
				}
			}
		}

		var refMap = [String : Object]()
		// пробежимся по всем классам, наполним их методами из экстеншенов
		self.nameObjectMap.forEach {
			let object = $0.value
			if let extensionsForName = self.extensions[object.props.name] {
				for ext in extensionsForName {
					$0.value.applyExtension(ext)
				}
			}
			if object.isValidForExport {
				if let implement = object.props.implement, !implement.isEmpty {
					// удалим все непубличные протоколы
					let validProtocols = implement.filter {
						let objects = self.allNameObjectMap[$0.name]
						return objects?.contains { $0.isValidExtension() } == true
					}
					object.props.implement = validProtocols.isEmpty ? nil : validProtocols
				}
				refMap[object.refMap()] = object
			}
		}
		let referenceVisitor = ReferenceVisitor(existingReferences: nameRefMap)
		// добавим ссылки всем объектам
		refMap.forEach {
			$0.value.addMissingRefs(referenceVisitor)
		}
		let e = JSONEncoder()
		e.outputFormatting = [.prettyPrinted]
		let documentation = Documentation(refMap: refMap)
		let data = try! e.encode(documentation)
		return String(data: data, encoding: .utf8)!
	}

}

extension Object {

	static let validProtocols: Set<String> = [
		"CustomStringConvertible",
		"Equatable",
		"Comparable",
		"Error",
		"LocalizedError",
	]

	/// Должен ли этот экстеншн экспортироваться в документацию
	func isValidExtension() -> Bool {
		return
			self.accessibility?.isValidForExport == true ||
			Object.validProtocols.contains(self.props.name)
	}

	func applyExtension(_ ext: Object) {
		if let extMethods = ext.props.methods {
			if let methods = self.props.methods {
				self.props.methods = methods + extMethods
			} else {
				self.props.methods = extMethods
			}
		}
		if let extProperties = ext.props.properties {
			if let properties = self.props.properties {
				self.props.properties = properties + extProperties
			} else {
				self.props.properties = extProperties
			}
		}
		if let extImplement = ext.props.implement {
			if let implement = self.props.implement {
				self.props.implement = implement + extImplement
			} else {
				self.props.implement = extImplement
			}
		}
	}

}

extension Dictionary {

	mutating func append<T>(key: Key, newValue: T) where Value == Array<T> {
		if var values = self[key] {
			values.append(newValue)
			self[key] = values
		} else {
			self[key] = [newValue]
		}
	}

}
