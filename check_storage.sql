-- 检查 Storage buckets 是否存在
SELECT * FROM storage.buckets;

-- 检查 Storage objects 表中是否有文件
SELECT * FROM storage.objects ORDER BY created_at DESC LIMIT 10;

-- 检查 Storage 策略
SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd
FROM pg_policies
WHERE schemaname = 'storage';

-- 查看 verdicts 表中最新的记录
SELECT id, task_title, photo_url, status, created_at
FROM verdicts
ORDER BY created_at DESC
LIMIT 1;
