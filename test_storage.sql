-- 检查 verdicts 表中的数据
SELECT * FROM verdicts
ORDER BY created_at DESC
LIMIT 5;

-- 查看表结构
SELECT
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_name = 'verdicts'
ORDER BY ordinal_position;

-- 检查 RLS 策略
SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE tablename = 'verdicts';
