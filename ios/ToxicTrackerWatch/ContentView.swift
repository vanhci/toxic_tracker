import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @StateObject private var viewModel = WatchViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // 状态卡片
                HStack {
                    Text(viewModel.emoji)
                        .font(.system(size: 28))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(viewModel.title)
                            .font(.system(size: 14, weight: .black))
                            .lineLimit(2)
                        if !viewModel.subtitle.isEmpty {
                            Text(viewModel.subtitle)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.black)
                .cornerRadius(12)

                // 统计数据
                HStack(spacing: 8) {
                    StatItem(emoji: "🚩", value: "\(viewModel.taskCount)", label: "Flag")
                    StatItem(emoji: "🕊️", value: "\(viewModel.totalFails)", label: "鸽了")
                    StatItem(emoji: "💀", value: "\(viewModel.overdueCount)", label: "逾期")
                }

                // 刷新按钮
                Button(action: {
                    viewModel.refresh()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("刷新")
                    }
                    .font(.system(size: 12, weight: .bold))
                }
                .buttonStyle(.bordered)
                .tint(Color(red: 0.8, green: 1.0, blue: 0.0)) // CCFF00
            }
            .padding()
        }
        .background(Color.black)
        .onAppear {
            viewModel.refresh()
        }
    }
}

struct StatItem: View {
    let emoji: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(emoji)
                .font(.system(size: 16))
            Text(value)
                .font(.system(size: 18, weight: .black))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

// MARK: - WatchViewModel
class WatchViewModel: ObservableObject {
    @Published var emoji: String = "🙄"
    @Published var title: String = "今天鸽了吗？"
    @Published var subtitle: String = ""
    @Published var taskCount: Int = 0
    @Published var totalFails: Int = 0
    @Published var overdueCount: Int = 0

    private var session: WCSession?

    init() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = WatchSessionDelegate.shared
            session?.activate()
        }
    }

    func refresh() {
        // 请求 iPhone 发送数据
        session?.sendMessage(["request": "sync"], replyHandler: { response in
            DispatchQueue.main.async {
                self.updateFromResponse(response)
            }
        }, errorHandler: { error in
            print("Watch 连接错误: \(error)")
        })
    }

    private func updateFromResponse(_ response: [String: Any]) {
        if let title = response["widget_title"] as? String {
            self.title = title
        }
        if let subtitle = response["widget_subtitle"] as? String {
            self.subtitle = subtitle
        }
        if let emoji = response["widget_emoji"] as? String {
            self.emoji = emoji
        }
        if let taskCount = response["task_count"] as? Int {
            self.taskCount = taskCount
        }
        if let totalFails = response["total_fails"] as? Int {
            self.totalFails = totalFails
        }
        if let overdueCount = response["overdue_count"] as? Int {
            self.overdueCount = overdueCount
        }
    }
}

// MARK: - WatchSessionDelegate
class WatchSessionDelegate: NSObject, WCSessionDelegate {
    static let shared = WatchSessionDelegate()

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Watch session activated: \(activationState)")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("Watch received message: \(message)")
    }
}

#Preview {
    ContentView()
}
