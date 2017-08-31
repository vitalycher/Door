# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

target '111Secuirty' do
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'PKHUD', :git => 'https://github.com/pkluz/PKHUD.git', :branch => 'release/swift4'
    pod 'IQKeyboardManager'
end

target 'Door Widget' do
    inherit! :search_paths
    pod 'Alamofire'
end

target 'DoorSiri' do
    inherit! :search_paths
    pod 'Alamofire'
end

target 'WatchDoorSiri' do
    platform :watchos, '3.0'
    pod 'Alamofire'
#    , :git => 'git@github.com:neonichu/Alamofire.git', :branch => 'watchos'
end
