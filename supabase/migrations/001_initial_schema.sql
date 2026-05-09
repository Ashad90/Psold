-- Enable extensions
create extension if not exists "uuid-ossp";

-- Profiles table (extends Supabase auth.users)
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text not null check (role in ('merchant', 'client')),
  display_name text not null,
  whatsapp text,
  avatar_url text,
  city text,
  created_at timestamptz default now()
);

-- Products table
create table if not exists public.products (
  id uuid primary key default uuid_generate_v4(),
  merchant_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  description text,
  category text not null check (category in ('alimentaire', 'cosmetique', 'electronique', 'autre')),
  price_original numeric(10,2),
  price_promo numeric(10,2) not null,
  expiry_date date not null,
  quantity integer default 1,
  images text[] default '{}',
  video_url text,
  city text,
  validated boolean default false,
  ai_score numeric(4,2),
  rejection_reason text,
  views_count integer default 0,
  created_at timestamptz default now(),
  expires_at timestamptz
);

-- Likes table
create table if not exists public.likes (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete cascade,
  created_at timestamptz default now(),
  unique(user_id, product_id)
);

-- Comments table
create table if not exists public.comments (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete cascade,
  content text not null,
  created_at timestamptz default now()
);

-- Row Level Security
alter table public.profiles enable row level security;
alter table public.products enable row level security;
alter table public.likes enable row level security;
alter table public.comments enable row level security;

-- Profiles policies
create policy "Profiles public read" on public.profiles for select using (true);
create policy "Users insert own profile" on public.profiles for insert with check (auth.uid() = id);
create policy "Users update own profile" on public.profiles for update using (auth.uid() = id);

-- Products policies
create policy "Products public read validated" on public.products for select using (validated = true or merchant_id = auth.uid());
create policy "Merchants insert own products" on public.products for insert with check (auth.uid() = merchant_id);
create policy "Merchants update own products" on public.products for update using (auth.uid() = merchant_id);
create policy "Merchants delete own products" on public.products for delete using (auth.uid() = merchant_id);

-- Likes policies
create policy "Likes public read" on public.likes for select using (true);
create policy "Users insert own likes" on public.likes for insert with check (auth.uid() = user_id);
create policy "Users delete own likes" on public.likes for delete using (auth.uid() = user_id);

-- Comments policies
create policy "Comments public read" on public.comments for select using (true);
create policy "Users insert own comments" on public.comments for insert with check (auth.uid() = user_id);
create policy "Users delete own comments" on public.comments for delete using (auth.uid() = user_id);

-- Storage bucket for product images
insert into storage.buckets (id, name, public) values ('products', 'products', true) on conflict do nothing;

create policy "Product images public read" on storage.objects for select using (bucket_id = 'products');
create policy "Merchants upload product images" on storage.objects for insert with check (bucket_id = 'products' and auth.role() = 'authenticated');
create policy "Merchants delete product images" on storage.objects for delete using (bucket_id = 'products' and auth.uid()::text = (storage.foldername(name))[1]);