# Uncomment the next line to define a global platform for your project
platform :ios, '13.2'

target 'Hymns' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Hymns

  #Realm database for use with favorites
  pod 'RealmSwift'
  
  # Tool to enforce Swift style and conventions.
  # https://realm.github.io/SwiftLint
  pod 'SwiftLint'
  
  # Dependency Injection Framework
  # https://github.com/hmlongco/Resolver
  pod 'Resolver'
  
  target 'HymnsTests' do
    inherit! :search_paths
    
    # Mocking framework
    # https://github.com/birdrides/mockingbird
    pod 'MockingbirdFramework'

    # Quick & Nimble
    # https://github.com/Quick/Quick
    pod 'Quick'
    # https://github.com/Quick/Nimble
    pod 'Nimble'
  end

  target 'HymnsUITests' do
    # Pods for testing
  end
end
