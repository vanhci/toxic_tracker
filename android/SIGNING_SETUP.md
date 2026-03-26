# Android 签名配置指南

## 当前状态

⚠️ **未配置发布签名** - 当前使用 debug 签名，无法发布到 Google Play。

## 创建签名证书

### 方法一：命令行创建（推荐）

```bash
# 在项目 android 目录下执行
cd /Users/vanhci/.openclaw/workspace-coding/toxic_tracker/android

# 创建签名证书
keytool -genkey -v -keystore toxic-tracker-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias toxic-tracker

# 按提示输入：
# - 密钥库口令（保存好！）
# - 姓名、组织、城市等信息
# - 密钥口令（可以直接回车使用相同口令）
```

### 方法二：Android Studio 创建

1. 打开 Android Studio
2. Build → Generate Signed Bundle/APK
3. 选择 APK
4. 点击 "Create new..." 创建新密钥库

## 配置签名

### 步骤 1: 创建 key.properties

在 `android/` 目录下创建 `key.properties` 文件：

```properties
storePassword=你的密钥库密码
keyPassword=你的密钥密码
keyAlias=toxic-tracker
storeFile=toxic-tracker-release.jks
```

⚠️ **重要：** 将 `key.properties` 添加到 `.gitignore`，不要提交到 Git！

### 步骤 2: 修改 build.gradle.kts

在 `android/app/build.gradle.kts` 中添加签名配置：

```kotlin
import java.util.Properties
import java.io.FileInputStream

// 在 plugins 块之后添加
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ... 现有配置 ...

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file("$it") }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // 其他 release 配置...
        }
    }
}
```

### 步骤 3: 更新 .gitignore

在项目根目录 `.gitignore` 中添加：

```
# Android signing
android/key.properties
android/*.jks
android/*.keystore
```

## 验证签名

```bash
# 构建发布版本
flutter build apk --release

# 验证 APK 签名
apksigner verify --print-certs build/app/outputs/flutter-apk/app-release.apk
```

## 安全提示

1. **备份密钥库** - 将 `.jks` 文件备份到安全位置
2. **安全存储密码** - 使用密码管理器保存密码
3. **不要提交到 Git** - 密钥库和密码文件绝对不能提交
4. **Google Play App Signing** - 考虑启用 Google Play 应用签名，增加安全保障

## 相关文档

- [Flutter 应用签名](https://docs.flutter.dev/deployment/android#signing-the-app)
- [Google Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756)
