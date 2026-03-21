# Apple Watch 配套应用设置指南

## 前置条件
- Xcode 15+
- Apple 开发者账号
- 配置好签名的 iOS 项目

## 设置步骤

### 1. 在 Xcode 中添加 Watch App Target

1. 打开 `ios/Runner.xcworkspace`
2. 选择 File → New → Target
3. 选择 watchOS → App
4. 配置：
   - Product Name: `ToxicTrackerWatch`
   - Language: Swift
   - User Interface: SwiftUI
   - Watch-only App: 否（需要与 iPhone 配对）

### 2. 配置 App Groups

1. 选择 Runner target → Signing & Capabilities
2. 添加 App Groups capability
3. 创建 group: `group.com.example.toxic_tracker`

4. 对 Watch App target 重复上述步骤
5. 使用相同的 App Group ID

### 3. 替换生成的文件

将以下文件复制到 Watch App 目录：
- `ToxicTrackerWatchApp.swift` → 替换生成的 App 文件
- `ContentView.swift` → 替换生成的 ContentView

### 4. 配置 WatchConnectivity

在 iOS 端（AppDelegate.swift）添加：

```swift
import WatchConnectivity

class WatchConnectivityManager: NSObject, WCSessionDelegate {
    static let shared = WatchConnectivityManager()
    var session: WCSession?

    func start() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        if message["request"] as? String == "sync" {
            // 从 UserDefaults 读取数据
            let defaults = UserDefaults(suiteName: "group.com.example.toxic_tracker")
            let response: [String: Any] = [
                "widget_title": defaults?.string(forKey: "widget_title") ?? "今天鸽了吗？",
                "widget_subtitle": defaults?.string(forKey: "widget_subtitle") ?? "",
                "widget_emoji": defaults?.string(forKey: "widget_emoji") ?? "🙄",
                "task_count": defaults?.integer(forKey: "task_count") ?? 0,
                "total_fails": defaults?.integer(forKey: "total_fails") ?? 0,
                "overdue_count": defaults?.integer(forKey: "overdue_count") ?? 0
            ]
            replyHandler(response)
        }
    }
}
```

在 `application(_:didFinishLaunchingWithOptions:)` 中调用：
```swift
WatchConnectivityManager.shared.start()
```

### 5. 构建和运行

1. 选择 Watch App scheme
2. 选择配对的 Apple Watch 或模拟器
3. 运行

## 功能

- 📊 查看任务统计
- 🕊️ 查看鸽子次数
- ⏰ 查看逾期任务
- 🔄 手动刷新数据

## 设计

- 纯黑背景 + 白色文字
- 荧光黄强调色 (#CCFF00)
- 粗野主义风格
