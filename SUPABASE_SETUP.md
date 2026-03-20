# Supabase 配置指南

## 第一步：创建 Supabase 项目

1. **访问 Supabase 官网**
   - 打开 https://supabase.com
   - 点击右上角 "Start your project"

2. **注册/登录**
   - 可以使用 GitHub 账号快速登录
   - 或者使用邮箱注册

3. **创建组织**（如果是第一次使用）
   - 输入组织名称，如：`Personal`
   - 点击 "Create organization"

4. **创建新项目**
   - 点击 "New project"
   - 项目名称：`toxic_tracker`
   - 数据库密码：**请记住这个密码**（后面会用到）
   - 区域：选择离你最近的区域，推荐 `Northeast Asia (Tokyo)` 或 `Southeast Asia (Singapore)`
   - 点击 "Create new project"

5. **等待项目初始化**
   - 大约需要 1-2 分钟
   - 完成后会自动跳转到项目控制台

---

## 第二步：获取项目配置信息

1. 在项目控制台中，点击左侧菜单的 **Settings** (齿轮图标)

2. 点击 **API** 选项

3. 找到以下信息并记录下来：
   - **Project URL** (类似: `https://xxxxxxxxxxxx.supabase.co`)
   - **anon public key** (一长串以 `eyJ` 开头的字符串)

---

## 第三步：配置数据库表

1. 在左侧菜单点击 **SQL Editor**

2. 点击右上角 **New query**

3. 复制以下 SQL 脚本并粘贴到编辑器中：

```sql
-- 创建 verdicts 表
create table verdicts (
  id uuid default gen_random_uuid() primary key,
  task_id text not null,
  task_title text not null,
  photo_url text not null,
  status text default 'pending',
  created_at timestamp with time zone default now()
);

-- 启用 RLS (Row Level Security)
alter table verdicts enable row level security;

-- 允许匿名插入
create policy "Allow anonymous insert" on verdicts for insert with check (true);

-- 允许匿名更新
create policy "Allow anonymous update" on verdicts for update using (true);

-- 允许匿名查询
create policy "Allow anonymous select" on verdicts for select using (true);
```

4. 点击右下角的 **Run** 按钮执行

5. 如果成功，会在下方看到 "Success. No rows returned" 的提示

---

## 第四步：创建 Storage Bucket

1. 在左侧菜单点击 **Storage**

2. 点击 **New bucket**

3. 输入信息：
   - Name: `proofs`
   - 取消勾选 "Public bucket"（我们会用策略控制访问）
   - 点击 "Create bucket"

4. 点击刚创建的 `proofs` bucket，然后点击 **Policies**

5. 点击 **New Policy**，选择 **For full customization**

6. 创建第一个策略（允许上传）：
   - Policy name: `Allow anonymous upload`
   - Allowed operations: 勾选 `INSERT`
   - Target roles: 留空（表示所有用户）
   - 点击 "Save policy"

7. 再创建第二个策略（允许读取）：
   - Policy name: `Allow anonymous read`
   - Allowed operations: 勾选 `SELECT`
   - Target roles: 留空
   - 点击 "Save policy"

---

## 第五步：启用匿名认证

1. 在左侧菜单点击 **Authentication**

2. 点击 **Providers**

3. 找到 **Anonymous** 选项

4. 点击开关启用

---

## 第六步：测试配置

在 SQL Editor 中运行以下命令测试：

```sql
-- 测试插入
insert into verdicts (task_id, task_title, photo_url)
values ('test-task', '测试任务', 'https://example.com/photo.jpg')
returning *;

-- 查询结果
select * from verdicts order by created_at desc limit 1;

-- 清理测试数据（可选）
delete from verdicts where task_id = 'test-task';
```

如果都能成功执行，说明配置完成！

---

## 配置完成后

请将以下信息告诉我：

1. **Project URL**: `https://xxxxxxxxxxxx.supabase.co`
2. **Anon Key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

我会帮你更新代码中的配置。
