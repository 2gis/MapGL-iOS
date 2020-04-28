Pod::Spec.new do |s|

  s.name                    = "TestHost"
  s.version                 = "0.0.1"
  s.summary                 = "A tests hosting application."
  s.description             = "A hosting application for the unit and UI tests."
  s.homepage                = "https://2gis.com/"
  s.license                 = "MIT"
  s.author                  = { "e.tyutyuev" => "e.tyutyuev@2gis.ru" }
  s.platform                = :ios
  s.source                  = { :git => "http://2gis.ru/v4ios.git", :tag => "#{s.version}" }

  # Has to have at least one file.
  s.source_files = 'Dummy.swift'
  s.ios.deployment_target = '10.0'
  s.app_spec "App" do |as|
    as.source_files = 'AppDelegate.swift'
    as.resources = [
      '../Example/HelloSDK/Images.xcassets',
    ]
    as.ios.frameworks = 'Foundation', 'QuartzCore', 'UIKit'
  end
end
