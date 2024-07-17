require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "react-native-nmap"
  s.version      = package['version']
  s.summary      = "React Native Naver Mapview component for iOS + Android"

  s.authors      = { "author" => "pop9310@gmail.com" }
  s.homepage     = "https://github.com/quadflask/react-native-naver-map"
  s.license      = package['license']
  s.platform     = :ios, "9.0"

  s.source       = { :http => "https://repository.map.naver.com/archive/pod/NMapsMap/3.16.1/NMapsMap.zip" }
  s.source_files = "ios/**/*.{h,m}"

  s.static_framework = true
  s.dependency 'React'
  s.dependency 'NMapsMap-Legacy', '~> 3.16.1'

end
