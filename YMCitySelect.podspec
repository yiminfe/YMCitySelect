Pod::Spec.new do |s|
    s.name         = 'YMCitySelect'
    s.version      = '1.0.2'
    s.summary      = 'One line of code do city choice'
    s.homepage     = 'https://github.com/iosdeveloperSVIP/YMCitySelect'
    s.license      = 'MIT'
    s.authors      = {'zhaoyimin' => 'iosdeveloper@vip.163.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://github.com/iosdeveloperSVIP/YMCitySelect.git', :tag => s.version}
    s.source_files = 'YMCitySelect/*.{h,m}'
    s.resource     = 'YMCitySelect/YMCitySelect.bundle'
    s.requires_arc = true
end
