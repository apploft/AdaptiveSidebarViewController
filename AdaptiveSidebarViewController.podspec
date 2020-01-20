Pod::Spec.new do |s|

  s.name         = "AdaptiveSidebarViewController"
  s.version      = "0.1"
  s.summary      = "A simple a simple container which can adaptively display a viewcontroller in a sidebar."

  s.description  = <<-DESC
                   AdaptiveSidebarViewController is a simple container which can adaptively display a
                   viewcontroller in a sidebar (regular environment) or pushed on the
                   navigation stack (compact environment).
                   DESC

  s.homepage     = "https://github.com/apploft/AdaptiveSidebarViewController"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = "Mathias Köhnke"

  s.platform     = :ios, "9.0"
  s.swift_versions = '4.2'

  s.source       = { :git => "https://github.com/apploft/AdaptiveSidebarViewController.git", :tag => s.version.to_s }

  s.source_files  = "Classes", "Classes/**/*.{swift}"
  s.exclude_files = "Classes/Exclude"

  s.requires_arc = true

end
