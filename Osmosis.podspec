Pod::Spec.new do |s|
  s.name             = "Osmosis"
  s.version          = "1.0.0"
  s.summary          = "Osmosis - Web scraping for Swift"
  s.description      = "Osmosis was built to make scraping websites using Swift easy. With Osmosis you can daisy
                        chain commands to retrieve a websites data in a convenient manner and build apps around
                        existing websites"

  s.homepage         = "https://github.com/ChristianPraiss/Osmosis"
  s.license          = 'MIT'
  s.author           = { "Christian Praiß" => "christian_praiss@icloud.com" }
  s.source           = { :git => "https://github.com/ChristianPraiss/Osmosis.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/chrisspraiss'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.dependency 'Kanna', '~> 1.0.0'

end
