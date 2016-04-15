Pod::Spec.new do |s|

s.name         = 'ESTabView'
s.version      = '0.1.0'
s.summary      = 'Request.'
s.homepage     = 'https://github.com/cezres/ESTabView'
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.author       = { 'cezres' => 'cezres@163.com' }

s.platform     = :ios, '7.0'
s.source       = { :git => 'https://github.com/cezres/ESTabView.git', :tag => s.version }
s.source_files = 'ESTabView'
s.requires_arc = true
s.public_header_files = 'ESTabView/*.h'

end
