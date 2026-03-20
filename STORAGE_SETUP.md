# Supabase Storage 配置步骤

## 第一步：创建 proofs bucket

1. 打开 Supabase Dashboard：https://supabase.com/dashboard
2. 选择你的项目 `toxic_tracker`
3. 左侧菜单点击 **Storage**（图标像个桶）
4. 点击右上角 **New bucket** 按钮
5. 在弹出窗口中填写：
   - **Name**: `proofs`（必须完全一致，小写）
   - **Public bucket**: ❌ **取消勾选**（重要！）
6. 点击 **Create bucket** 按钮

---

## 第二步：配置访问策略

创建成功后：

1. 在 Storage 页面，点击刚创建的 **proofs** bucket
2. 点击上方的 **Policies** 标签（在 "Files" 旁边）
3. 点击右上角 **New Policy** 按钮
4. 选择 **For full customization**

### 创建第一个策略（允许上传）

在策略编辑页面：

1. **Policy name**: 输入 `Allow anonymous upload`
2. **Allowed operations**: 只勾选 ✅ **INSERT**
3. **Target roles**: 留空（表示适用于所有用户）
4. 其他字段保持默认
5. 点击右下角 **Save policy** 按钮

### 创建第二个策略（允许读取）

再次点击 **New Policy** → **For full customization**：

1. **Policy name**: 输入 `Allow anonymous read`
2. **Allowed operations**: 只勾选 ✅ **SELECT**
3. **Target roles**: 留空
4. 其他字段保持默认
5. 点击 **Save policy** 按钮

---

## 第三步：验证配置

完成配置后，在 **Policies** 标签页应该能看到两个策略：

| Policy name | Allowed operations |
|-------------|-------------------|
| Allow anonymous upload | INSERT |
| Allow anonymous read | SELECT |

---

## 第四步：测试上传

配置完成后：

1. 刷新你的应用页面：http://localhost:8080
2. 添加一个新任务
3. 点击 **"我颓了"** 按钮
4. 选择一张图片
5. 等待上传完成

**成功标志**：
- 会显示分享弹窗
- 在 Supabase Dashboard → Storage → proofs 中能看到上传的图片文件

---

## 🔍 排查问题

如果还是失败：

1. **检查 Storage 是否启用**：
   - 左侧菜单 → Settings → API
   - 确保 Storage 服务状态是 Active

2. **检查 RLS 策略**：
   - 在 SQL Editor 中运行：
   ```sql
   SELECT * FROM pg_policies WHERE tablename = 'objects' AND schemaname = 'storage';
   ```

3. **查看应用日志**：
   - 打开浏览器控制台（F12）
   - 查看 Console 标签中的错误信息
