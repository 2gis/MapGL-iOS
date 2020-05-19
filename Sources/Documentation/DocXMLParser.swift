import SWXMLHash
import SourceKittenFramework

extension String {

	static let xml = """
<decl.function.method.instance>
	<syntaxtype.keyword>func</syntaxtype.keyword>
	<decl.name>method1</decl.name>
(
<decl.var.parameter>
<decl.var.parameter.argument_label>_</decl.var.parameter.argument_label> <decl.var.parameter.name>param1</decl.var.parameter.name>: <decl.var.parameter.type><ref.struct usr=\"s:SS\">String</ref.struct></decl.var.parameter.type>
</decl.var.parameter>, <decl.var.parameter><decl.var.parameter.argument_label>param2</decl.var.parameter.argument_label>: <decl.var.parameter.type><ref.struct usr=\"s:Si\">Int</ref.struct>?</decl.var.parameter.type></decl.var.parameter>, <decl.var.parameter><decl.var.parameter.argument_label>_</decl.var.parameter.argument_label> <decl.var.parameter.name>param3</decl.var.parameter.name>: <decl.var.parameter.type><ref.struct usr=\"s:SS\">String</ref.struct></decl.var.parameter.type> = &quot;&quot;</decl.var.parameter>) -&gt;
<decl.function.returntype>
	<ref.struct usr=\"s:SS\">String</ref.struct>
</decl.function.returntype>
</decl.function.method.instance>
"""
	static let xml2 = """
<decl.function.constructor><syntaxtype.keyword>public</syntaxtype.keyword> <syntaxtype.keyword>override</syntaxtype.keyword> <syntaxtype.keyword>init</syntaxtype.keyword>(<decl.var.parameter><decl.var.parameter.argument_label>frame</decl.var.parameter.argument_label>: <decl.var.parameter.type><ref.struct usr="c:@S@CGRect">CGRect</ref.struct></decl.var.parameter.type></decl.var.parameter>)</decl.function.constructor>
"""
	static let doc = """
<Function file=\"/Users/teanet/Documents/projects/MapGL-iOS/Sources/MapGL/MapView.swift\" line=\"14\" column=\"7\"><Name>method1(_:param2:_:)</Name><USR>s:5MapGL0A4ViewC7method1_6param2_S2S_SiSgSStF</USR><Declaration>func method1(_ param1: String, param2: Int?, _ param3: String = &quot;&quot;) -&gt; String</Declaration><CommentParts><Abstract><Para>Method line 1 Method line 2</Para></Abstract><Parameters><Parameter><Name>param1</Name><Direction isExplicit=\"0\">in</Direction><Discussion><Para>param1 dscr</Para></Discussion></Parameter><Parameter><Name>param2</Name><Direction isExplicit=\"0\">in</Direction><Discussion><Para>param2 dscr</Para></Discussion></Parameter><Parameter><Name>param3</Name><Direction isExplicit=\"0\">in</Direction><Discussion><Para>param3 dscr</Para></Discussion></Parameter></Parameters><ResultDiscussion><Para>ssssssttttring</Para></ResultDiscussion></CommentParts></Function>
"""

	func parseConstructor() -> Method? {
		let xml = SWXMLHash.parse(self)["decl.function.constructor"]
		let parameters = xml.properties()
		return Method(
			name: "init",
			parameters: parameters,
			result: nil
		)
	}

	///android/maps/reference
	func parseMethod() -> Method? {
		let xml = SWXMLHash.parse(self)["decl.function.method.instance"]
		guard let name = xml["decl.name"].element?.text else { return nil }

		var returnTypes = [InstanceType]()
		if let returnType = xml.type(with: "decl.function.returntype") {
			returnTypes += [InstanceType(name: returnType)]
		}
		let result: ReturnResult? = returnTypes.isEmpty ? nil : ReturnResult(types: returnTypes)
		let parameters = xml.properties()
		return Method(
			name: name,
			parameters: parameters,
			result: result
		)
	}

	func propertyDescription() -> String? {
		let xml = SWXMLHash.parse(self)["Other"]
		return xml.comment()
	}

}

extension Method {

	func fill(with xmlDocumentation: String) {
		guard let doc = parseFullXMLDocs(xmlDocumentation) else { return }

		let xml = SWXMLHash.parse(xmlDocumentation)["Function"]
		if let comment = xml.comment() {
			self.description = comment
		} else {
			print("Warning: Method \(self.name) missing description")
		}

		let docParams = doc.docParams
		self.result?.description = doc.docDescription(for: "key.doc.result_discussion")
		for docParam in docParams {
			if let name = docParam["name"] as? String {
				if let parameter = self.parameters.first(where: { $0.name == name }) {
					parameter.description = docParam.docDescription(for: "discussion")
				}
			} else {
				preconditionFailure("Doc param for method: \(self.name) should have name")
			}
		}
		for parameter in self.parameters {
			if parameter.description == nil {
				print("Warning: Method \(self.name): \(parameter.name) missing description")
			}
		}
	}

}

extension XMLIndexer {

	func comment() -> String? {
		self["CommentParts"]["Abstract"]["Para"].element?.text
	}

	func properties() -> [Property] {
		let parameters = self["decl.var.parameter"].all.compactMap { e -> Property? in
			let label = e["decl.var.parameter.argument_label"].element?.text
			let name = e["decl.var.parameter.name"].element?.text

			if let typeName = e.type(with: "decl.var.parameter.type") {
				let type = InstanceType(name: typeName)
				return Property(
					name: label ?? name ?? "",
					types: [type]
				)
			}
			return nil
		}
		return parameters
	}

	func type(with key: String) -> String? {
		guard let modifier = self[key].element?.text else { return nil }
		if let typeName = self[key]["ref.struct"].element?.text{
			return typeName + modifier
		} else if let typeName = self[key]["ref.class"].element?.text{
			return typeName + modifier
		}
		return nil
	}

}
