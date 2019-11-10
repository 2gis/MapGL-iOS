Pod::Spec.new do |s|
	s.name = 'MapGL'
	s.version = '0.0.1'
	s.swift_version = '5.0'
	s.summary = '2GIS Maps SDK for iOS'
	s.homepage = 'https://github.com/2gis/MapGL-iOS'
	s.ios.deployment_target = '9.0'
	s.platform = :ios, '9.0'
	s.license = {
		:type => 'BSD 2-Clause Simplified License',
		:file => 'LICENSE'
	}
	s.author = {
		'Alexander Volokhin' => 'mapgl@2gis.com'
	}
	s.source = {
		:git => 'https://github.com/2gis/MapGL-iOS.git',
		:tag => "#{s.version}" 
	}
	s.framework = "UIKit"
	s.source_files = 'MapGL/SDK/**/*.{swift}'
	s.resource_bundles = { 'Map' => 'MapGL/SDK/**/*.{html}' }
end
