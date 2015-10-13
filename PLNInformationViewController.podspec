Pod::Spec.new do |s|
  s.name         = "PLNInformationViewController"
  s.version      = "0.0.8"
  s.summary      = "PLNInformationViewController provides simple UI for about this application."

  s.description  = <<-DESC
                   A longer description of PLNInformationViewController in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/palnyan/PLNInformationViewController"
  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author    = "Haruka Togawa (a.k.a. palnyan)"
  s.social_media_url   = "http://twitter.com/palnyan"

  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/palnyan/PLNInformationViewController.git", :tag => "v#{s.version}" }
  s.source_files  = "PLNInformationViewController/*.{h,m}"

  # s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  s.framework  = "MessageUI"
  # s.frameworks = "SomeFramework", "AnotherFramework"
end
