create extension if not exists pgcrypto;
create table if not exists public.products (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 name text not null, category text default 'Geral', brand text, model text, sku text, notes text,
 created_at timestamptz not null default now()
);
create table if not exists public.stock_lots (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 product_id uuid not null references public.products(id) on delete cascade,
 invoice_number text, supplier text, purchase_date date not null default current_date,
 quantity_in integer not null check(quantity_in>0),
 quantity_remaining integer not null check(quantity_remaining>=0 and quantity_remaining<=quantity_in),
 unit_cost numeric(12,2) not null check(unit_cost>=0),
 planned_price numeric(12,2) not null default 0 check(planned_price>=0),
 created_at timestamptz not null default now()
);
create table if not exists public.sales (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 sold_at timestamptz not null default now(), payment_method text default 'PIX',
 notes text, status text not null default 'completed' check(status in ('completed','cancelled','returned'))
);
create table if not exists public.sale_items (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 sale_id uuid not null references public.sales(id) on delete cascade,
 lot_id uuid not null references public.stock_lots(id), product_id uuid not null references public.products(id),
 quantity integer not null check(quantity>0), unit_cost numeric(12,2) not null check(unit_cost>=0),
 unit_price numeric(12,2) not null check(unit_price>=0), fees numeric(12,2) not null default 0
);
create table if not exists public.cash_movements (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 movement_date timestamptz not null default now(), kind text not null check(kind in ('income','expense','reserve','reserve_use')),
 category text not null, description text, amount numeric(12,2) not null check(amount>=0),
 related_sale_id uuid references public.sales(id)
);
create table if not exists public.settings (
 user_id uuid primary key references auth.users(id) on delete cascade,
 reinvestment_percent numeric(5,2) not null default 10 check(reinvestment_percent between 0 and 100),
 reserve_percent numeric(5,2) not null default 0 check(reserve_percent between 0 and 100),
 report_email text, whatsapp_number text, updated_at timestamptz not null default now()
);
alter table public.products enable row level security;
alter table public.stock_lots enable row level security;
alter table public.sales enable row level security;
alter table public.sale_items enable row level security;
alter table public.cash_movements enable row level security;
alter table public.settings enable row level security;
create policy "own products" on public.products for all using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy "own lots" on public.stock_lots for all using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy "own sales" on public.sales for all using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy "own sale items" on public.sale_items for all using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy "own cash movements" on public.cash_movements for all using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy "own settings" on public.settings for all using(auth.uid()=user_id) with check(auth.uid()=user_id);
-- No Supabase Auth: Authentication > Settings > desative novos cadastros públicos.
-- Crie o único administrador manualmente em Authentication > Users.
-- Nunca exponha a chave service_role no frontend.
