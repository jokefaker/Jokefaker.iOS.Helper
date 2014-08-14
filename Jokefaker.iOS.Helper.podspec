#
#  Be sure to run `pod spec lint Jokefaker.iOS.Helper.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #
  s.name         = "Jokefaker.iOS.Helper"
  s.version      = "0.0.1"
  s.summary      = "Something helpful for iOS-Develope."
  s.homepage     = "https://github.com/503315533/JokeLib.git"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = 'MIT'


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author       = { "Jokefaker" => "503315533@qq.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.ios.deployment_target = '6.0'


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://git.oschina.net/jokefaker/Whalefin.iOS.Helper.git", :tag => "0.0.4" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = '**/*.{h,m}'


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.resources = "**/*.png"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  # s.libraries = 'iconv', 'xml2'


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true

end
