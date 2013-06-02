namespace :test do
  task :prepare do
    #system(%Q{mkdir -p "Tests/AFNetworking Tests.xcodeproj/xcshareddata/xcschemes" && cp Tests/Schemes/*.xcscheme "Tests/AFNetworking Tests.xcodeproj/xcshareddata/xcschemes/"})
    puts "prepare"
  end

  desc "Run the AFNetworking Tests for Mac OS X"
  task :osx => :prepare do
    $osx_success = system("xctool -workspace larussoSTD.xcworkspace -scheme 'OSX Tests' build -sdk macosx -configuration Release")
    $osx_success = system("xctool -workspace larussoSTD.xcworkspace -scheme 'OSX Tests' build-tests -sdk macosx -configuration Release")
    $osx_success = system("xctool -workspace larussoSTD.xcworkspace -scheme 'OSX Tests' test -test-sdk macosx -sdk macosx -configuration Release")
  end
end

desc "Run the LarussoSDT Tests for Mac OS X"
task :test => ['test:osx'] do
  puts "\033[0;31m! OS X unit tests failed" unless $osx_success
  if $osx_success
    puts "\033[0;32m** All tests executed successfully"
  else
    exit(-1)
  end
end

task :default => 'test'
