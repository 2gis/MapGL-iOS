// swift-tools-version:5.2
//
//  Package.swift
//
//  Copyright (c) 2019-2020 2GIS (https://github.com/2gis/MapGL-iOS/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import PackageDescription

let package = Package(
	name: "MapGL-iOS",
	platforms: [
		.iOS(.v10)
	],
	products: [
		.library(
			name: "MapGL",
			targets: ["MapGL"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/jpsim/SourceKitten.git", .upToNextMinor(from: "0.29.0")),
	],
	targets: [
		.target(
			name: "MapGL",
			dependencies: []
		),
		.testTarget(
			name: "MapGLTests",
			dependencies: ["MapGL"]
		),
		.target(
			name: "Documentation",
			dependencies: [
				.product(name: "SourceKittenFramework", package: "SourceKitten"),
			]
		),
	],
	swiftLanguageVersions: [.v5]
)
