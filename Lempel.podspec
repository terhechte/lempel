Pod::Spec.new do |s|
  s.name         = "Lempel"
  s.version      = "0.1.3"
  s.license      = "MIT"
  s.summary      = "A simple Gzip implementation in Swift."
  s.homepage     = "https://github.com/terhechte/lempel"
  s.author       = { "Benedikt Terhechte" => "terhechte@gmail.com" }
  s.source       = { :git => "https://github.com/terhechte/lempel.git", :tag => "v#{s.version}" }

  
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  
  s.source_files  = "Lempel/*.swift"
  s.preserve_paths = "zlib/*"

  s.requires_arc = true
  s.library = "z"
  s.xcconfig = { 'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/Lempel/zlib' }

  # Uncomment for `pod lib lint`
  # s.prepare_command = 'mkdir -p $TMPDIR/CocoaPods/Lint/Pods/Lempel && cp -r zlib $TMPDIR/CocoaPods/Lint/Pods/Lempel/zlib'
end