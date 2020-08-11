import Foundation
import SourceKittenFramework

//try? String.xml2.parseMethod()

let module = Module(
	xcodeBuildArguments: [
		"-project", "MapGL-iOS.xcodeproj",
		"-target", "MapGL",
		"-sdk", "iphoneos13.6",
		"-verbose",
	],
	inPath: "/Users/teanet/Documents/projects/MapGL-iOS"
)

guard let docs = module?.docs else { exit(0) }
let parser = DocsParser()
let json = parser.parse(docs)
print("\(json)")
