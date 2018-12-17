加固后v2签名脚本。

1.配置好安卓环境变量ANDROID_HOME
2.把待签名的apk包放到apk目录下面
3.init.config配置文件里面配置
  BUILD_TOOL：工具版本；
  KEY_STORE：keystore文件路径
  OUT_PUT：输出目录
  STORE_PASSWORD：store密码
  KEY_ALIAS：keyAlias
  KEY_PASSWORD：keyPassword
