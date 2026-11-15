-- Voorraad-app: database-opzet (stap 1)
-- Plak dit hele bestand in Supabase → SQL Editor → New query, en klik op Run.

create table if not exists public.products (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name             text not null check (char_length(name) between 1 and 100),
  place            text not null default 'koelkast' check (place in ('koelkast', 'vriezer', 'kast')),
  track            text not null default 'aantal'   check (track in ('aantal', 'gram', 'niveau')),
  count            integer not null default 1   check (count >= 0),
  unit             text not null default 'stuks' check (char_length(unit) <= 30),
  grams            integer not null default 0   check (grams >= 0),
  level            text not null default 'Vol'  check (level in ('Vol', 'Half', 'Leeg')),
  grams_per_unit   integer not null default 100 check (grams_per_unit > 0),
  full_grams       integer not null default 500 check (full_grams > 0),
  expires_on       date,
  open_shelf_days  integer check (open_shelf_days > 0),
  opened_on        date,
  freezable        boolean not null default true,
  barcode          text,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now()
);

create index if not exists products_user_id_idx on public.products (user_id);

-- updated_at automatisch bijwerken
create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists products_set_updated_at on public.products;
create trigger products_set_updated_at
  before update on public.products
  for each row execute function public.set_updated_at();

-- Beveiliging: iedereen ziet en wijzigt alleen zijn eigen producten
alter table public.products enable row level security;

drop policy if exists "Eigen producten lezen" on public.products;
create policy "Eigen producten lezen" on public.products
  for select to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Eigen producten toevoegen" on public.products;
create policy "Eigen producten toevoegen" on public.products
  for insert to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Eigen producten wijzigen" on public.products;
create policy "Eigen producten wijzigen" on public.products
  for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists "Eigen producten verwijderen" on public.products;
create policy "Eigen producten verwijderen" on public.products
  for delete to authenticated
  using ((select auth.uid()) = user_id);
