package com.vanhci.toxictracker

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Android 小组件 Provider
 * 粗野主义风格桌面小组件
 */
class ToxicTrackerWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // 小组件首次添加时调用
    }

    override fun onDisabled(context: Context) {
        // 最后一个小组件被移除时调用
    }

    companion object {
        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            // 从 HomeWidget 读取数据
            val widgetData = HomeWidgetPlugin.getData(context)

            val title = widgetData.getString("widget_title", "今天鸽了吗？")
            val subtitle = widgetData.getString("widget_subtitle", "")
            val emoji = widgetData.getString("widget_emoji", "🙄")

            // 创建 RemoteViews
            val views = RemoteViews(context.packageName, R.layout.toxic_tracker_widget)

            // 设置文本
            views.setTextViewText(R.id.widget_emoji, emoji)
            views.setTextViewText(R.id.widget_title, title)
            views.setTextViewText(R.id.widget_subtitle, subtitle)

            // 更新小组件
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
