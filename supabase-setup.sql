-- Run this once in Supabase Dashboard → SQL Editor.
create table if not exists public.spine_user_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.spine_user_data enable row level security;

grant select, insert, update on public.spine_user_data to authenticated;

drop policy if exists "Read own Spine data" on public.spine_user_data;
create policy "Read own Spine data"
on public.spine_user_data for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "Insert own Spine data" on public.spine_user_data;
create policy "Insert own Spine data"
on public.spine_user_data for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "Update own Spine data" on public.spine_user_data;
create policy "Update own Spine data"
on public.spine_user_data for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);
