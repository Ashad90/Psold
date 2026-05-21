-- =============================================
-- PSOLD - Database Schema for Supabase
-- Run this in Supabase SQL Editor
-- =============================================

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- =============================================
-- PROFILES TABLE
-- =============================================
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text not null check (role in ('merchant', 'client')),
  display_name text not null,
  whatsapp text,
  avatar_url text,
  city text,
  fcm_token text,
  last_active timestamptz default now(),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- =============================================
-- PRODUCTS TABLE
-- =============================================
create table public.products (
  id uuid primary key default uuid_generate_v4(),
  merchant_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  description text,
  category text not null check (category in ('alimentaire', 'electronique', 'cosmetique', 'autre')),
  price_original numeric(10,2),
  price_promo numeric(10,2) not null,
  expiry_date date not null,
  quantity integer default 1,
  images text[] default '{}',
  video_url text,
  validated boolean default false,
  ai_score numeric(4,2),
  rejection_reason text,
  views_count integer default 0,
  city text,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  expires_at timestamptz generated always as (expiry_date + interval '1 day') stored
);

-- =============================================
-- LIKES TABLE
-- =============================================
create table public.likes (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete cascade,
  created_at timestamptz default now(),
  unique(user_id, product_id)
);

-- =============================================
-- COMMENTS TABLE
-- =============================================
create table public.comments (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete cascade,
  content text not null,
  created_at timestamptz default now()
);

-- =============================================
-- NOTIFICATIONS TABLE
-- =============================================
create table public.notifications (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  type text not null check (type in ('new_product', 'like', 'comment', 'general', 'product_expiry')),
  title text not null,
  body text,
  data jsonb,
  is_read boolean default false,
  created_at timestamptz default now()
);

-- =============================================
-- ROW LEVEL SECURITY (RLS)
-- =============================================
alter table public.profiles enable row level security;
alter table public.products enable row level security;
alter table public.likes enable row level security;
alter table public.comments enable row level security;
alter table public.notifications enable row level security;

-- =============================================
-- RLS POLICIES
-- =============================================

-- PROFILES
create policy "Profiles are publicly readable" on public.profiles for select using (true);
create policy "Users can insert their own profile" on public.profiles for insert with check (true);
create policy "Users can update their own profile" on public.profiles for update using (auth.uid() = id);

-- PRODUCTS
create policy "Validated products are publicly readable" on public.products for select using (validated = true or merchant_id = auth.uid());
create policy "Merchants can insert products" on public.products for insert with check (exists (select 1 from public.profiles where id = auth.uid() and role = 'merchant'));
create policy "Merchants can update their own products" on public.products for update using (merchant_id = auth.uid());
create policy "Merchants can delete their own products" on public.products for delete using (merchant_id = auth.uid());

-- LIKES
create policy "Likes are publicly readable" on public.likes for select using (true);
create policy "Authenticated users can like" on public.likes for insert with check (auth.uid() is not null and auth.uid() = user_id);
create policy "Users can delete their own likes" on public.likes for delete using (user_id = auth.uid());

-- COMMENTS
create policy "Comments are publicly readable" on public.comments for select using (true);
create policy "Authenticated users can comment" on public.comments for insert with check (auth.uid() is not null and auth.uid() = user_id);
create policy "Users can delete their own comments" on public.comments for delete using (user_id = auth.uid());

-- NOTIFICATIONS
create policy "Users can read their own notifications" on public.notifications for select using (user_id = auth.uid());
create policy "System can insert notifications" on public.notifications for insert with check (true);
create policy "Users can update their own notifications" on public.notifications for update using (user_id = auth.uid());

-- =============================================
-- FUNCTIONS
-- =============================================

-- Auto-update updated_at column
create or replace function public.update_updated_at_column()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- =============================================
-- TRIGGERS
-- =============================================

create trigger update_profiles_updated_at before update on public.profiles for each row execute procedure public.update_updated_at_column();
create trigger update_products_updated_at before update on public.products for each row execute procedure public.update_updated_at_column();

-- =============================================
-- INDEXES
-- =============================================

create index idx_products_merchant_id on public.products(merchant_id);
create index idx_products_validated on public.products(validated);
create index idx_products_category on public.products(category);
create index idx_products_created_at on public.products(created_at desc);
create index idx_likes_user_id on public.likes(user_id);
create index idx_likes_product_id on public.likes(product_id);
create index idx_comments_user_id on public.comments(user_id);
create index idx_comments_product_id on public.comments(product_id);
create index idx_notifications_user_id on public.notifications(user_id);
create index idx_notifications_is_read on public.notifications(is_read);