Pod::Spec.new do |s|
    s.name             = "LocationManager"
    s.version          = "1.0.0"
    s.summary          = "LocationManager"
    s.homepage         = "https://github.com/varshylmobile/LocationManager"
    s.license          = 'MIT'
    s.author           = { "Jimmy Jose" => "jimmy@varshyl.com" }
    s.ios.deployment_target = '8.0'
    s.source           = { :git => 'https://github.com/varshylmobile/LocationManager.git', :tag => s.version }
    s.source_files     = "LocationManager.swift"
    s.requires_arc     = true
end
