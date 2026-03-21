-- Toxic Tracker 数据库迁移脚本
-- 在 Supabase SQL Editor 中运行此脚本

-- ============================================
-- 1. 判决表 (verdicts) - 已创建
-- ============================================
-- 如果表已存在，跳过此步骤
-- CREATE TABLE IF NOT EXISTS verdicts (
--   id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
--   task_id TEXT NOT NULL,
--   task_title TEXT NOT NULL,
--   photo_url TEXT NOT NULL,
--   status TEXT DEFAULT 'pending',
--   created_at TIMESTAMPTZ DEFAULT NOW(),
--   updated_at TIMESTAMPTZ DEFAULT NOW()
-- );

-- ============================================
-- 2. 团队表 (teams) - 企业版功能
-- ============================================
CREATE TABLE IF NOT EXISTS teams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  leader_id TEXT NOT NULL,
  invite_code TEXT UNIQUE,
  settings JSONB DEFAULT '{"enable_notifications": true, "require_photo_proof": true, "fail_threshold": 3}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 3. 团队成员表 (team_members) - 企业版功能
-- ============================================
CREATE TABLE IF NOT EXISTS team_members (
  team_id UUID REFERENCES teams(id) ON DELETE CASCADE,
  user_id TEXT NOT NULL,
  display_name TEXT,
  role TEXT DEFAULT 'member' CHECK (role IN ('admin', 'leader', 'member')),
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (team_id, user_id)
);

-- ============================================
-- 4. 启用 RLS (Row Level Security)
-- ============================================
ALTER TABLE verdicts ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 5. RLS 策略 - 允许匿名操作
-- ============================================

-- verdicts 表策略
CREATE POLICY "Allow anonymous read on verdicts"
  ON verdicts FOR SELECT
  USING (true);

CREATE POLICY "Allow anonymous insert on verdicts"
  ON verdicts FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow anonymous update on verdicts"
  ON verdicts FOR UPDATE
  USING (true);

-- teams 表策略
CREATE POLICY "Allow anonymous read on teams"
  ON teams FOR SELECT
  USING (true);

CREATE POLICY "Allow anonymous insert on teams"
  ON teams FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow anonymous update on teams"
  ON teams FOR UPDATE
  USING (true);

-- team_members 表策略
CREATE POLICY "Allow anonymous read on team_members"
  ON team_members FOR SELECT
  USING (true);

CREATE POLICY "Allow anonymous insert on team_members"
  ON team_members FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow anonymous update on team_members"
  ON team_members FOR UPDATE
  USING (true);

CREATE POLICY "Allow anonymous delete on team_members"
  ON team_members FOR DELETE
  USING (true);

-- ============================================
-- 6. 索引优化
-- ============================================
CREATE INDEX IF NOT EXISTS idx_verdicts_status ON verdicts(status);
CREATE INDEX IF NOT EXISTS idx_verdicts_task_id ON verdicts(task_id);
CREATE INDEX IF NOT EXISTS idx_teams_invite_code ON teams(invite_code);
CREATE INDEX IF NOT EXISTS idx_team_members_user_id ON team_members(user_id);

-- ============================================
-- 7. 触发器 - 自动更新 updated_at
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_verdicts_updated_at
  BEFORE UPDATE ON verdicts
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 8. Storage bucket - proofs (已在控制台创建)
-- ============================================
-- 如果需要通过 SQL 创建:
-- INSERT INTO storage.buckets (id, name, public)
-- VALUES ('proofs', 'proofs', true);

-- Storage 策略
CREATE POLICY "Allow anonymous upload to proofs"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'proofs');

CREATE POLICY "Allow anonymous read from proofs"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'proofs');

-- ============================================
-- 完成！
-- ============================================
-- 运行此脚本后:
-- 1. verdicts 表用于判决记录
-- 2. teams 和 team_members 表用于企业版功能
-- 3. 所有表启用 RLS 并允许匿名操作
-- 4. Storage bucket 'proofs' 允许匿名上传/读取
