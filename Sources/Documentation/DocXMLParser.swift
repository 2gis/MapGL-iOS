import SWXMLHash

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

	func parseConstructor() -> Method? {
		let xml = SWXMLHash.parse(self)["decl.function.constructor"]
		let parameters = xml.properties()
		return Method(
			name: "init",
			isConstructor: true,
			parameters: parameters,
			result: ReturnResult(types: [])
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
		let parameters = xml.properties()
		return Method(
			name: name,
			parameters: parameters,
			result: ReturnResult(types: returnTypes)
		)
	}

}

extension XMLIndexer {

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
