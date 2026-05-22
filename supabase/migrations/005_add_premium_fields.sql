alter table public.profiles
  add column if not exists is_premium boolean default false,
  add column if not exists upload_count integer default 0,
  add column if not exists premium_since timestamptz,
  add column if not exists upload_reset_at timestamptz;
