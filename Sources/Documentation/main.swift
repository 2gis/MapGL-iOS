import Foundation
import SourceKittenFramework

//let module = Module(spmArguments: [], spmName: "MapGL")
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
for doc in docs {

	if let substructures = doc.docsDictionary[.substructure]?.arrayOfDict {
		for substructure in substructures {

			if let accessibility = Accessibility(substructure[SwiftDocKey.accessibility]),
				accessibility.isValidForExport,
				let objectType = substructure.kind?.objectType(),
				let properties = substructure.objectProperties {
				let object = Object(type: objectType, props: properties)
				refMap[UUID().uuidString] = object
				_ = substructure
			}
		}
	}

}
let e = JSONEncoder()
e.outputFormatting = [.prettyPrinted]
let documentation = Documentation(refMap: refMap)
let data = try! e.encode(documentation)
print("\(String(data: data, encoding: .utf8)!)")
//
//print(">>>>>\(name):\(objectType), \(accessibility), \(substructure.properties)")
//_ = substructure
