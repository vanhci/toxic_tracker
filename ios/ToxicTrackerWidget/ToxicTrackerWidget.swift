import WidgetKit
import SwiftUI

// 小组件数据提供者
struct ToxicTrackerEntry: TimelineEntry {
    let date: Date
    let title: String
    let subtitle: String
    let emoji: String
    let pendingCount: Int
    let overdueCount: Int
    let totalFails: Int
}

// Timeline Provider
struct ToxicTrackerProvider: TimelineProvider {
    func placeholder(in context: Context) -> ToxicTrackerEntry {
        ToxicTrackerEntry(
            date: Date(),
            title: "今天鸽了吗？",
            subtitle: "快来添加任务吧",
            emoji: "🙄",
            pendingCount: 0,
            overdueCount: 0,
            totalFails: 0
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (ToxicTrackerEntry) -> Void) {
        let entry = ToxicTrackerEntry(
            date: Date(),
            title: "今天鸽了吗？",
            subtitle: "快来添加任务吧",
            emoji: "🙄",
            pendingCount: 0,
            overdueCount: 0,
            totalFails: 0
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ToxicTrackerEntry>) -> Void) {
        // 从 App Group 读取数据
        let userDefaults = UserDefaults(suiteName: "group.com.toxictracker.app")

        let title = userDefaults?.string(forKey: "widget_title") ?? "今天鸽了吗？"
        let subtitle = userDefaults?.string(forKey: "widget_subtitle") ?? ""
        let emoji = userDefaults?.string(forKey: "widget_emoji") ?? "🙄"
        let pendingCount = userDefaults?.integer(forKey: "pending_count") ?? 0
        let overdueCount = userDefaults?.integer(forKey: "overdue_count") ?? 0
        let totalFails = userDefaults?.integer(forKey: "total_fails") ?? 0

        let entry = ToxicTrackerEntry(
            date: Date(),
            title: title,
            subtitle: subtitle,
            emoji: emoji,
            pendingCount: pendingCount,
            overdueCount: overdueCount,
            totalFails: totalFails
        )

        // 每 15 分钟更新一次
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))

        completion(timeline)
    }
}

// 小组件视图
struct ToxicTrackerWidgetView: View {
    var entry: ToxicTrackerEntry
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            // 背景
            (colorScheme == .dark ? Color.black : Color.white)
                .ignoresSafeArea()

            VStack(spacing: 8) {
                // Emoji
                Text(entry.emoji)
                    .font(.system(size: 40))

                // 标题
                Text(entry.title)
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                // 副标题
                if !entry.subtitle.isEmpty {
                    Text(entry.subtitle)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                }

                // 底部装饰条
                Rectangle()
                    .fill(Color(red: 0.8, green: 1.0, blue: 0.0)) // CCFF00
                    .frame(height: 3)
                    .padding(.top, 4)
            }
            .padding()
        }
        .overlay(
            // 粗野主义边框
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color.black, lineWidth: 3)
        )
    }
}

// 小组件配置
@main
struct ToxicTrackerWidget: Widget {
    let kind: String = "ToxicTrackerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ToxicTrackerProvider()) { entry in
            ToxicTrackerWidgetView(entry: entry)
        }
        .configurationDisplayName("今天鸽了吗")
        .description("实时显示你的任务状态和鸽子次数")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// 预览
struct ToxicTrackerWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ToxicTrackerWidgetView(entry: ToxicTrackerEntry(
                date: Date(),
                title: "今天鸽了吗？",
                subtitle: "还有 3 个任务",
                emoji: "🙄",
                pendingCount: 3,
                overdueCount: 0,
                totalFails: 2
            ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

            ToxicTrackerWidgetView(entry: ToxicTrackerEntry(
                date: Date(),
                title: "鸽王之王",
                subtitle: "已累计鸽了 15 次",
                emoji: "👑",
                pendingCount: 5,
                overdueCount: 2,
                totalFails: 15
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
