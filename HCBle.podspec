Pod::Spec.new do |s|
  
  # local.properties 파일에서 환경 변수 불러오기
  project_file = File.expand_path("local.properties", __dir__)
  
  if File.exist?(project_file)
    File.foreach(project_file) do |line|
      key, value = line.strip.split('=', 2)
      ENV[key] = value if key && value
    end
  else
    puts "⚠️ Warning: local.properties 파일을 찾을 수 없습니다."
  end
  
  # 변수 설정
  token = ENV['GIT_ACCESS_TOKEN']
  version = ENV['VERSION']
  description = ENV['DESCRIPTION']
  repo_url = ENV['URL']
  
  s.name             = 'HCBle'
  s.version          = version
  s.summary          = description
  
  s.description      = description
  s.homepage         = repo_url
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hconnectdx' => 'kmwdev@hconnect.co.kr' }
  
  # 🔥 보안 강화: URL에서 토큰 직접 사용 금지 → x-oauth-basic 방식 적용
  s.source           = { :git => "https://oauth2:#{token}@github.com/hconnectdx/bt-sdk-ios.git", :tag => version }
  
  s.ios.deployment_target = '10.0'
  s.source_files = 'HCBle/Classes/**/*', 'HCBle/PeripheralModel.swift'
end
