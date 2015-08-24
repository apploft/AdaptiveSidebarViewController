Pod::Spec.new do |s|

  s.name         = "AdaptiveSidebarViewController"
  s.version      = "0.0.1"
  s.summary      = "A simple a simple container which can adaptively display a viewcontroller in a sidebar."

  s.description  = <<-DESC
		   ExpandableLabel is a simple UILabel subclass that shows
		   a tappable link if the content doesn't fit the specified
		   number of lines. If touched, the label will expand to show
		   the entire content.
                   DESC

  s.homepage     = "https://github.com/apploft/AdaptiveSidebarViewController"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = "Mathias Köhnke"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/apploft/ExpandableLabel.git", :tag => s.version.to_s }

  s.source_files  = "Classes", "Classes/**/*.{swift}"
  s.exclude_files = "Classes/Exclude"

  s.requires_arc = true

end
