-- Fix RLS policy: user can only insert their own profile (id must match auth.uid)
drop policy if exists "Users can insert their own profile" on public.profiles;
create policy "Users can insert their own profile"
  on public.profiles
  for insert
  with check (auth.uid() = id);