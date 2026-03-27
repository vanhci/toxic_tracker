# 应用商店提审素材

## 📱 App Icon

### 要求
- **Android**: 512x512 (Play Store), 192x192 (App), 各尺寸自适应图标
- **iOS**: 1024x1024 (App Store), 各尺寸图标

### 当前状态
⚠️ 需要创建 App Icon

### 创建步骤

1. **设计图标**
   - 尺寸: 1024x1024
   - 风格: 粗野主义，黑边框，荧光黄 (#FFE500)
   - 内容: 鸽子图标或"鸽"字变形

2. **生成各尺寸图标**
   ```bash
   # 使用 flutter_launcher_icons
   flutter pub run flutter_launcher_icons
   
   # 或手动创建以下尺寸:
   # Android:
   # - mipmap-mdpi: 48x48
   # - mipmap-hdpi: 72x72
   # - mipmap-xhdpi: 96x96
   # - mipmap-xxhdpi: 144x144
   # - mipmap-xxxhdpi: 192x192
   # - Play Store: 512x512
   
   # iOS:
   # - iPhone: 180x180, 120x120, 60x60
   # - iPad: 167x167, 152x152, 76x76
   # - App Store: 1024x1024
   ```

3. **放置图标文件**
   - 主图标: `assets/icon/app_icon.png` (1024x1024)
   - 自适应前景: `assets/icon/app_icon_foreground.png` (透明背景)

---

## 🖼️ 截图素材

### Android 截图要求 (Google Play)
- **手机截图**: 至少 2 张，最多 8 张
- **平板截图**: 可选
- **尺寸**: 
  - 手机: 16:9 比例 (1920x1080 或 1080x1920)
  - 7寸平板: 1280x800 或 800x1280
  - 10寸平板: 2560x1600 或 1600x2560
- **格式**: PNG 或 JPEG
- **禁止**: 透明背景、截图中有临时内容

### iOS 截图要求 (App Store)
- **必需尺寸**: 至少 3 张 (不同尺寸设备)
- **支持尺寸**:
  - 6.7" (iPhone 14 Pro Max): 1290x2796
  - 6.5" (iPhone 11 Pro Max/XS Max): 1242x2688
  - 5.5" (iPhone 8 Plus): 1242x2208
- **格式**: PNG 或 JPEG
- **状态栏**: 必须显示完整状态栏

### 建议截图内容
1. **首页截图**: 展示任务列表界面
2. **拍照截图**: 展示鸽子拍照流程
3. **判决截图**: 展示死党判决页面
4. **惩罚截图**: 展示30秒惩罚界面
5. **成就截图**: 展示成就系统

### 生成截图方法
```bash
# 使用 Flutter 截图工具
flutter drive --driver=test_driver/screenshot.dart \
  --target=integration_test/screenshot_test.dart

# 或使用 Android Studio/模拟器截图
```

---

## 📝 描述文案

### App 名称 (中文)
**今天鸽了吗**

### App 名称 (英文)
**Toxic Tracker**

### 副标题 (30字符)
**一款专门骂你的自律 App**

### 简短描述 (80字符)
**连续鸽了3次，你的死党将有权远程处刑。极简主义自律神器。**

### 完整描述 (4000字符)
```
连续鸽了3次，你的死党将有权远程处刑。

这是一款极简主义风格的自律应用，没有温柔的鼓励，只有无情的嘲讽。
每次你放弃任务，都要拍照留证，分享给死党让他来判决：
是放你一马，还是立刻触发30秒的"赛博处刑"。

💀 粗野主义界面
硬核黑边框，刺眼的荧光黄，零模糊。不是丑，是态度。

📸 强制拍照
没有照片就不算鸽了。留下你懒惰的证据，接受审判吧。

🤝 社交处刑
让死党来当你的行刑官。朋友是用来干嘛的？就是用来监督你的！

💬 毒舌教练
Amanda 免费陪你立 Flag，解锁更多教练需订阅：
- 暴躁的健身教练（免费）
- 阴阳怪气的班主任
- 佛系躺平大师
- 更多教练持续上线...

🏆 成就系统
连续打卡获得徽章，虽然你还是鸽了，至少有点成就感。

📊 数据统计
可视化展示你鸽了多少次，直面自己的失败。

📱 小组件支持
桌面小组件，随时看到你的鸽子记录。

🔒 隐私保护
匿名使用，无需注册。数据加密存储，安全可靠。

【订阅服务】
- 年度会员：¥19.9/年
- 终身会员：¥68 (一次购买永久使用)

订阅后解锁：
- 所有教练人设
- 高级成就徽章
- 数据导出功能
- 团队监督功能

【联系我们】
- 邮箱：support@vanhci.com
- GitHub：github.com/vanhci/toxic_tracker
```

---

## 🏷️ 关键词 (ASO)

### 中文关键词 (100字符)
```
自律,打卡,习惯,监督,Flag,鸽子,拖延症,目标管理,时间管理,自我提升,毒舌,监督,社交惩罚
```

### 英文关键词
```
productivity,habit,tracker,goals,accountability,motivation,self-improvement,todo
```

---

## 📋 分类

### Google Play
- **主分类**: 生产力 (Productivity)
- **次分类**: 生活方式 (Lifestyle)

### App Store
- **主分类**: 效率 (Productivity)
- **次分类**: 生活 (Lifestyle)

---

## 🈳 内容分级

### Google Play
填写内容分级问卷，根据以下内容：
- 无暴力内容
- 无性暗示
- 无毒品相关
- 无赌博元素
- 用户生成内容（照片上传）

### App Store
- 年龄分级: 4+
- 无不当内容

---

## 🔗 相关链接

### 隐私政策
- URL: https://vanhci.github.io/toxic_tracker/ (待 GitHub Pages 激活)
- 文件: docs/index.html

### 服务条款
- 需要创建: docs/terms.html

### 支持页面
- 邮箱: support@vanhci.com
- GitHub: https://github.com/vanhci/toxic_tracker

---

## ✅ 提审前检查清单

- [x] 隐私政策创建
- [x] 隐私政策托管 (GitHub Pages)
- [x] Android 签名证书创建
- [x] 签名配置更新
- [ ] App Icon 设计 (需要设计)
- [ ] 截图素材 (需要设备截图)
- [ ] 服务条款页面 (可选)
- [ ] Google Play Console 注册
- [ ] App Store Connect 注册
- [ ] RevenueCat Android 配置

---

## 🚨 重要提醒

### 签名证书备份
**立即备份以下文件到安全位置：**
- `android/toxic-tracker-release.jks`
- `android/key.properties`

⚠️ **丢失证书将无法更新应用！**

### 密码信息
```
密钥库密码: toxic2026tracker
密钥密码: toxic2026tracker
密钥别名: toxic-tracker
```

建议使用密码管理器保存。
