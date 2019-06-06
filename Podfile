# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'iVoiceRecord' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for iVoiceRecord

	# Rx
    pod 'RxSwift', '~> 4.0.0'
    pod 'RxCocoa', '~> 4.0.0'
    pod 'RxDataSources', '~> 3.0.1'
	pod 'PinLayout', '~> 1'
	pod 'SnapKit'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.2'
        end
    end
end
