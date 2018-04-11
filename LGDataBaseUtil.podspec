Pod::Spec.new do |s|
  s.name         = "LGDataBaseUtil"
  s.version      = "1.0.0"
  s.summary      = "数据库管理（基于Realm）"

  # 项目主页地址
  s.homepage     = "https://github.com/LYajun/LGDataBaseUtil"
 
  # 许可证
  s.license      = "MIT"
 
  # 作者
  s.author             = { "刘亚军" => "liuyajun1999@icloud.com" }
 

  # 支持平台
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = '8.0'

  # 项目的地址
  s.source       = { 
            :git => "https://github.com/LYajun/LGDataBaseUtil.git", 
            :tag => s.version 
  }

  # 需要包含的源文件
  s.source_files = "LGDataBaseUtil/*.{h,m}"


  # 是否支持ARC 
  s.requires_arc = true

  
  # 依赖的开源库
  s.dependency 'Realm'

end
