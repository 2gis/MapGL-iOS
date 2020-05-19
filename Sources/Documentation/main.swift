import Foundation
import SourceKittenFramework

//try? String.xml2.parseMethod()

let module = Module(
	xcodeBuildArguments: [
		"-project", "MapGL-iOS.xcodeproj",
		"-target", "MapGL",
		"-sdk", "iphoneos13.4",
		"-verbose",
	],
	inPath: "/Users/teanet/Documents/projects/MapGL-iOS"
)

guard let docs = module?.docs else { exit(0) }

var refMap = [String : Object]()
var nameRefMap = [String: String]()

for doc in docs {

	if let substructures = doc.docsDictionary[.substructure]?.arrayOfDict {
		for substructure in substructures {

			if substructure.accessibility?.isValidForExport == true,
				let objectType = substructure.kind?.objectType(),
				let properties = substructure.objectProperties {
				let object = Object(type: objectType, props: properties)
				nameRefMap[object.props.name] = object.refMap()
				refMap[object.refMap()] = object
				_ = substructure
			}
		}
	}
}

refMap.forEach {
	$0.value.addMissingRefs(nameRefMap)
}

let e = JSONEncoder()
e.outputFormatting = [.prettyPrinted]
let documentation = Documentation(refMap: refMap)
let data = try! e.encode(documentation)
print("\(String(data: data, encoding: .utf8)!)")
//
//print(">>>>>\(name):\(objectType), \(accessibility), \(substructure.properties)")
//_ = substructure
