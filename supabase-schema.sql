-- Tab Bookmark Manager Cloud 用 Supabase スキーマ
-- Supabase SQL Editor で実行してください。

create table if not exists public.tab_bookmarks (
  profile_id text not null,
  id text not null,
  title text not null default '',
  url text not null default '',
  domain text not null default '',
  saved_at timestamptz not null default now(),
  tags jsonb not null default '[]'::jsonb,
  comment text not null default '',
  palette jsonb not null default '[]'::jsonb,
  published_at timestamptz,
  feed_url text,
  highlight text,
  image text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (profile_id, id)
);

alter table public.tab_bookmarks enable row level security;

grant select, insert, update, delete on public.tab_bookmarks to anon;

drop policy if exists "tab_bookmarks_anon_select" on public.tab_bookmarks;
drop policy if exists "tab_bookmarks_anon_insert" on public.tab_bookmarks;
drop policy if exists "tab_bookmarks_anon_update" on public.tab_bookmarks;
drop policy if exists "tab_bookmarks_anon_delete" on public.tab_bookmarks;

create policy "tab_bookmarks_anon_select" on public.tab_bookmarks
  for select to anon using (true);

create policy "tab_bookmarks_anon_insert" on public.tab_bookmarks
  for insert to anon with check (profile_id <> '' and id <> '');

create policy "tab_bookmarks_anon_update" on public.tab_bookmarks
  for update to anon using (profile_id <> '' and id <> '')
  with check (profile_id <> '' and id <> '');

create policy "tab_bookmarks_anon_delete" on public.tab_bookmarks
  for delete to anon using (profile_id <> '' and id <> '');

create index if not exists tab_bookmarks_profile_saved_idx
  on public.tab_bookmarks (profile_id, saved_at desc);

create index if not exists tab_bookmarks_profile_url_idx
  on public.tab_bookmarks (profile_id, url);
