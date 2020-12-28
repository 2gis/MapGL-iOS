Pod::Spec.new do |s|
	s.name = 'MapGL'
	s.version = '0.1.15'
	s.swift_version = '5.0'
	s.summary = '2GIS Maps SDK for iOS'
	s.homepage = 'https://github.com/2gis/MapGL-iOS'
	s.ios.deployment_target = '9.0'
	s.platform = :ios, '9.0'
	s.license = {
		:type => 'BSD 2-Clause Simplified License',
		:file => 'LICENSE'
	}
	s.authors = {
		'Alexander Volokhin' => 'mapgl@2gis.com',
		'Eugene Tyutyuev' => 'e.tyutyuev@2gis.ru'
	}
	s.source = {
		:git => 'https://github.com/2gis/MapGL-iOS.git',
		:tag => "v#{s.version}"
	}
	s.framework = "UIKit"
	s.source_files = 'Sources/MapGL/**/*.{swift}'

	s.test_spec 'Tests' do |ts|
		ts.source_files = 'Tests/MapGLTests/**/*.{swift}'
		ts.requires_app_host = true
	end
end
