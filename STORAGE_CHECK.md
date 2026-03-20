# Storage 配置检查清单

## 第一步：检查 verdicts 表数据

在 Supabase Dashboard → SQL Editor 中执行：

```sql
SELECT * FROM verdicts ORDER BY created_at DESC LIMIT 5;
```

你应该能看到刚才创建的记录，包括：
- task_title: 任务标题
- photo_url: 图片 URL
- status: 'pending'

---

## 第二步：检查 Storage Bucket

1. 在 Supabase Dashboard 左侧点击 **Storage**
2. 查看是否有名为 **proofs** 的 bucket
3. 如果**没有**，请创建：

### 创建 proofs bucket

1. 点击 **New bucket**
2. 填写：
   - Name: `proofs`
   - **取消勾选** "Public bucket"
3. 点击 "Create bucket"

---

## 第三步：配置 Storage 策略

在 `proofs` bucket 中：

1. 点击 bucket 名称 `proofs`
2. 点击上方 **Policies** 标签
3. 点击 **New Policy** → **For full customization**

### 策略 1: 允许上传
- Policy name: `Allow anonymous upload`
- Allowed operations: ✅ **INSERT**
- Target roles: 留空（所有用户）
- 点击 "Save policy"

### 策略 2: 允许读取
- Policy name: `Allow anonymous read`
- Allowed operations: ✅ **SELECT**
- Target roles: 留空
- 点击 "Save policy"

---

## 第四步：验证图片上传

查看应用中刚才上传的图片：

在 verdicts 表中查看 `photo_url` 字段：

**如果 photo_url 是 Supabase Storage URL**：
- 格式类似：`https://iyziuawpbpyvwhomtjkh.supabase.co/storage/v1/object/public/proofs/...`
- ✅ 说明上传成功

**如果 photo_url 是占位符 URL**：
- 格式类似：`https://via.placeholder.com/...`
- ❌ 说明 Storage 还没配置好，需要完成上面的步骤

---

## 配置完成后测试

完成 Storage 配置后：

1. 刷新应用页面
2. 添加一个新任务
3. 点击"我颓了"，选择图片上传
4. 检查 photo_url 是否变成了 Supabase Storage 的真实 URL
