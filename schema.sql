-- Run this in Supabase → SQL Editor. Same data model as before —
-- every table stores only encrypted blobs, never readable fields.

create table if not exists public.key_material (
  user_id uuid primary key references auth.users(id) on delete cascade,
  salt text not null, check_ct text not null, check_iv text not null,
  created_at timestamptz not null default now()
);
create table if not exists public.settings_enc (
  user_id uuid primary key references auth.users(id) on delete cascade,
  ct text not null, iv text not null, updated_at timestamptz not null default now()
);
create table if not exists public.doses_enc (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  ct text not null, iv text not null, created_at timestamptz not null default now()
);
create table if not exists public.encounters_enc (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  ct text not null, iv text not null, created_at timestamptz not null default now()
);

alter table public.key_material enable row level security;
alter table public.settings_enc enable row level security;
alter table public.doses_enc enable row level security;
alter table public.encounters_enc enable row level security;

create policy "key_material: owner read" on public.key_material for select using (auth.uid() = user_id);
create policy "key_material: owner write" on public.key_material for insert with check (auth.uid() = user_id);
create policy "key_material: owner update" on public.key_material for update using (auth.uid() = user_id);
create policy "settings_enc: owner read" on public.settings_enc for select using (auth.uid() = user_id);
create policy "settings_enc: owner write" on public.settings_enc for insert with check (auth.uid() = user_id);
create policy "settings_enc: owner update" on public.settings_enc for update using (auth.uid() = user_id);
create policy "doses_enc: owner read" on public.doses_enc for select using (auth.uid() = user_id);
create policy "doses_enc: owner write" on public.doses_enc for insert with check (auth.uid() = user_id);
create policy "doses_enc: owner delete" on public.doses_enc for delete using (auth.uid() = user_id);
create policy "encounters_enc: owner read" on public.encounters_enc for select using (auth.uid() = user_id);
create policy "encounters_enc: owner write" on public.encounters_enc for insert with check (auth.uid() = user_id);
create policy "encounters_enc: owner delete" on public.encounters_enc for delete using (auth.uid() = user_id);
