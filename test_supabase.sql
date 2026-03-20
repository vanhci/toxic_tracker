-- 测试 Supabase 配置
-- 请在 Supabase Dashboard 的 SQL Editor 中执行

-- 1. 测试插入 verdicts 表
INSERT INTO verdicts (task_id, task_title, photo_url, status)
VALUES (
  'test-task-001',
  '测试任务：每天运动30分钟',
  'https://via.placeholder.com/400?text=Test+Photo',
  'pending'
)
RETURNING *;

-- 2. 查询刚才插入的数据
SELECT * FROM verdicts
WHERE task_id = 'test-task-001'
ORDER BY created_at DESC;

-- 3. 测试更新状态（模拟死党判决）
UPDATE verdicts
SET status = 'punish'
WHERE task_id = 'test-task-001'
RETURNING *;

-- 4. 清理测试数据
DELETE FROM verdicts
WHERE task_id = 'test-task-001';

-- 如果以上命令都能成功执行，说明数据库配置正确！
