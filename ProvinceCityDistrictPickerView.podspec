Pod::Spec.new do |s|
  s.name         = "ProvinceCityDistrictPickerView"
  s.version      = "1.0.0"
  s.summary      = "Custom province - city - district pickerView."
  s.homepage     = "https://github.com/YQ-Z/ProvinceCityDistrictPickerView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "YQ-Z" => "449115125@qq.com" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/YQ-Z/ProvinceCityDistrictPickerView.git", :tag => s.version }
  s.source_files = 'YQPCDPickerViewSample/ProvinceCityDistrict/*.{ h, m}'
  s.source_files = 'YQPCDPickerViewSample/ProvinceCityDistrict/*.plist'
  s.requires_arc = true

end
