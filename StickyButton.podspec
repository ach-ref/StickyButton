#
#  Be sure to run `pod spec lint StickyButton.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  spec.name         = "StickyButton"
  spec.version      = "1.0.3"
  spec.summary      = "A sticky floating button menu."
  spec.homepage     = "https://github.com/ach-ref/StickyButton"
  spec.description  = "A sticky floating action button for iOS. It sticks to bottom left or right side of the screen. You can change the side by a simple swipe. It's a fancy and nice way to navigate between controllers for example."
  spec.screenshots  = [ "https://raw.githubusercontent.com/ach-ref/StickyButton/master/Resources/demo1.gif", 
  						"https://raw.githubusercontent.com/ach-ref/StickyButton/master/Resources/demo2.gif", 
  						"https://raw.githubusercontent.com/ach-ref/StickyButton/master/Resources/demo3.gif" ]


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  spec.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  spec.author             = { "Achref Marzouki" => "contact@amarzouki.com" }
  spec.social_media_url   = "https://amarzouki.com"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  spec.platform     	= :ios, "11.0"
  spec.swift_version 	= "5"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source       = { :git => "https://github.com/ach-ref/StickyButton.git", :tag => "#{spec.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  spec.source_files  = "StickyButton/**/*.{h,m,swift}"
  spec.public_header_files = "StickyButton/**/*.h"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  spec.requires_arc = true
  spec.pod_target_xcconfig = { 'LD_RUNPATH_SEARCH_PATHS' => '$(FRAMEWORK_SEARCH_PATHS)' }


end
