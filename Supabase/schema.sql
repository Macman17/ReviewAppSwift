-- ReviewApp Swift Supabase backend
-- Run this file in the Supabase SQL editor for a fresh or upgraded backend.

create extension if not exists pgcrypto;
create extension if not exists pg_trgm;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique,
  name text,
  full_name text,
  avatar_url text,
  cover_image text,
  bio text,
  show_followers boolean not null default true,
  is_public boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.follows (
  id uuid primary key default gen_random_uuid(),
  follower_id uuid not null references public.profiles(id) on delete cascade,
  following_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (follower_id, following_id),
  constraint follows_no_self_follow check (follower_id <> following_id)
);

create table if not exists public.reviews (
  id uuid primary key default gen_random_uuid(),
  reviewer_id uuid not null references public.profiles(id) on delete cascade,
  reviewed_user_id uuid not null references public.profiles(id) on delete cascade,
  review_type text not null check (review_type in ('star', 'written', 'video')),
  rating integer check (rating between 1 and 5),
  title text,
  content text,
  video_url text,
  thumbnail_url text,
  duration integer check (duration is null or duration >= 0),
  images text[],
  likes integer not null default 0 check (likes >= 0),
  comments integer not null default 0 check (comments >= 0),
  views integer not null default 0 check (views >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint reviews_no_self_review check (reviewer_id <> reviewed_user_id),
  constraint reviews_type_shape check (
    (review_type = 'star' and rating is not null)
    or (review_type = 'written' and title is not null and content is not null)
    or (review_type = 'video' and title is not null and video_url is not null)
  )
);

create table if not exists public.reviewer_badges (
  id uuid primary key default gen_random_uuid(),
  reviewer_id uuid not null references public.profiles(id) on delete cascade,
  reviewed_user_id uuid not null references public.profiles(id) on delete cascade,
  review_id uuid not null references public.reviews(id) on delete cascade unique,
  created_at timestamptz not null default now()
);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  type text not null check (type in ('review', 'follow', 'milestone', 'badge', 'comment', 'like', 'message')),
  title text not null,
  message text not null,
  data jsonb,
  read boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.conversations (
  id uuid primary key default gen_random_uuid(),
  participant1_id uuid not null references public.profiles(id) on delete cascade,
  participant2_id uuid not null references public.profiles(id) on delete cascade,
  last_message_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (participant1_id, participant2_id),
  constraint conversations_ordered_pair check (participant1_id < participant2_id)
);

create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations(id) on delete cascade,
  sender_id uuid not null references public.profiles(id) on delete cascade,
  receiver_id uuid not null references public.profiles(id) on delete cascade,
  content text not null,
  message_type text not null default 'text' check (message_type in ('text', 'image', 'video', 'audio')),
  media_url text,
  read boolean not null default false,
  read_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint messages_no_self_send check (sender_id <> receiver_id)
);

create table if not exists public.blocked_users (
  id uuid primary key default gen_random_uuid(),
  blocker_id uuid not null references public.profiles(id) on delete cascade,
  blocked_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (blocker_id, blocked_id),
  constraint blocked_users_no_self_block check (blocker_id <> blocked_id)
);

create table if not exists public.stories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  video_url text,
  image_url text,
  caption text,
  expires_at timestamptz not null default (now() + interval '24 hours'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint stories_media_required check (video_url is not null or image_url is not null)
);

create table if not exists public.story_views (
  id uuid primary key default gen_random_uuid(),
  story_id uuid not null references public.stories(id) on delete cascade,
  viewer_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (story_id, viewer_id)
);

create index if not exists profiles_username_trgm_idx on public.profiles using gin (username gin_trgm_ops);
create index if not exists profiles_name_trgm_idx on public.profiles using gin (name gin_trgm_ops);
create index if not exists follows_follower_id_idx on public.follows (follower_id);
create index if not exists follows_following_id_idx on public.follows (following_id);
create index if not exists reviews_reviewer_id_idx on public.reviews (reviewer_id);
create index if not exists reviews_reviewed_user_id_idx on public.reviews (reviewed_user_id);
create index if not exists reviews_feed_idx on public.reviews (created_at desc, reviewed_user_id, review_type);
create index if not exists reviewer_badges_reviewer_id_idx on public.reviewer_badges (reviewer_id);
create index if not exists reviewer_badges_reviewed_user_id_idx on public.reviewer_badges (reviewed_user_id);
create index if not exists notifications_user_read_idx on public.notifications (user_id, read, created_at desc);
create index if not exists conversations_participant1_id_idx on public.conversations (participant1_id);
create index if not exists conversations_participant2_id_idx on public.conversations (participant2_id);
create index if not exists conversations_last_message_at_idx on public.conversations (last_message_at desc);
create index if not exists messages_conversation_created_idx on public.messages (conversation_id, created_at);
create index if not exists messages_receiver_read_idx on public.messages (receiver_id, read);
create index if not exists blocked_users_blocker_id_idx on public.blocked_users (blocker_id);
create index if not exists blocked_users_blocked_id_idx on public.blocked_users (blocked_id);
create index if not exists stories_user_id_idx on public.stories (user_id);
create index if not exists stories_expires_at_idx on public.stories (expires_at);
create index if not exists story_views_story_id_idx on public.story_views (story_id);
create index if not exists story_views_viewer_id_idx on public.story_views (viewer_id);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_profiles_updated_at on public.profiles;
create trigger set_profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

drop trigger if exists set_reviews_updated_at on public.reviews;
create trigger set_reviews_updated_at
  before update on public.reviews
  for each row execute function public.set_updated_at();

drop trigger if exists set_conversations_updated_at on public.conversations;
create trigger set_conversations_updated_at
  before update on public.conversations
  for each row execute function public.set_updated_at();

drop trigger if exists set_messages_updated_at on public.messages;
create trigger set_messages_updated_at
  before update on public.messages
  for each row execute function public.set_updated_at();

drop trigger if exists set_stories_updated_at on public.stories;
create trigger set_stories_updated_at
  before update on public.stories
  for each row execute function public.set_updated_at();

create or replace function public.handle_new_user()
returns trigger
security definer
set search_path = public
language plpgsql
as $$
begin
  insert into public.profiles (id, username, name, full_name)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'username', split_part(new.email, '@', 1)),
    new.raw_user_meta_data->>'name',
    coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name')
  )
  on conflict (id) do nothing;
  return new;
exception
  when others then
    raise warning 'Error creating profile for user %: %', new.id, sqlerrm;
    return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

create or replace function public.get_follower_count(profile_id uuid)
returns integer
language sql
stable
as $$
  select count(*)::integer
  from public.follows
  where following_id = profile_id;
$$;

create or replace function public.has_reviewer_badge(profile_id uuid)
returns boolean
language sql
stable
as $$
  select public.get_follower_count(profile_id) >= 50000;
$$;

create or replace function public.can_message_between(sender_id uuid, receiver_id uuid)
returns boolean
language sql
stable
as $$
  select sender_id <> receiver_id
    and not exists (
      select 1
      from public.blocked_users
      where (blocker_id = sender_id and blocked_id = receiver_id)
         or (blocker_id = receiver_id and blocked_id = sender_id)
    );
$$;

create or replace function public.get_or_create_conversation(other_user_id uuid)
returns uuid
security definer
set search_path = public
language plpgsql
as $$
declare
  me uuid := auth.uid();
  p1 uuid;
  p2 uuid;
  conversation_id uuid;
begin
  if me is null then
    raise exception 'not authenticated';
  end if;

  if other_user_id is null or me = other_user_id then
    raise exception 'invalid conversation participant';
  end if;

  if not public.can_message_between(me, other_user_id) then
    raise exception 'messaging is blocked for these users';
  end if;

  if me < other_user_id then
    p1 := me;
    p2 := other_user_id;
  else
    p1 := other_user_id;
    p2 := me;
  end if;

  insert into public.conversations (participant1_id, participant2_id)
  values (p1, p2)
  on conflict (participant1_id, participant2_id)
  do update set updated_at = public.conversations.updated_at
  returning id into conversation_id;

  return conversation_id;
end;
$$;

create or replace function public.get_conversation_summaries()
returns table (
  id uuid,
  other_user_id uuid,
  other_user_name text,
  other_username text,
  other_avatar_url text,
  last_message text,
  last_message_at timestamptz,
  unread_count integer
)
security definer
set search_path = public
language sql
stable
as $$
  with me as (
    select auth.uid() as id
  )
  select
    c.id,
    case when c.participant1_id = me.id then c.participant2_id else c.participant1_id end as other_user_id,
    p.name as other_user_name,
    p.username as other_username,
    p.avatar_url as other_avatar_url,
    lm.content as last_message,
    c.last_message_at,
    (
      select count(*)::integer
      from public.messages m
      where m.conversation_id = c.id
        and m.receiver_id = me.id
        and m.read = false
    ) as unread_count
  from public.conversations c
  cross join me
  join public.profiles p
    on p.id = case when c.participant1_id = me.id then c.participant2_id else c.participant1_id end
  left join lateral (
    select content
    from public.messages m
    where m.conversation_id = c.id
    order by m.created_at desc
    limit 1
  ) lm on true
  where me.id is not null
    and (c.participant1_id = me.id or c.participant2_id = me.id)
  order by c.last_message_at desc;
$$;

create or replace function public.update_conversation_timestamp()
returns trigger
language plpgsql
as $$
begin
  update public.conversations
  set last_message_at = now(), updated_at = now()
  where id = new.conversation_id;
  return new;
end;
$$;

drop trigger if exists on_message_sent on public.messages;
create trigger on_message_sent
  after insert on public.messages
  for each row execute function public.update_conversation_timestamp();

create or replace function public.create_review_notification()
returns trigger
security definer
set search_path = public
language plpgsql
as $$
declare
  reviewer_name text;
begin
  select coalesce(name, username, 'Someone')
  into reviewer_name
  from public.profiles
  where id = new.reviewer_id;

  insert into public.notifications (user_id, type, title, message, data)
  values (
    new.reviewed_user_id,
    'review',
    'New Review',
    reviewer_name || ' reviewed you',
    jsonb_build_object('review_id', new.id, 'review_type', new.review_type, 'reviewer_id', new.reviewer_id)
  );

  return new;
end;
$$;

drop trigger if exists on_review_created_notify on public.reviews;
create trigger on_review_created_notify
  after insert on public.reviews
  for each row execute function public.create_review_notification();

create or replace function public.mark_story_viewed(story_id uuid, viewer_id uuid)
returns void
security definer
set search_path = public
language plpgsql
as $$
begin
  if auth.uid() is null or auth.uid() <> viewer_id then
    raise exception 'not authorized';
  end if;

  insert into public.story_views (story_id, viewer_id)
  values (story_id, viewer_id)
  on conflict (story_id, viewer_id) do nothing;
end;
$$;

create or replace view public.review_feed
with (security_invoker = true)
as
select
  r.id,
  r.reviewer_id,
  r.reviewed_user_id,
  r.review_type,
  r.rating,
  r.title,
  r.content,
  r.video_url,
  r.thumbnail_url,
  r.duration,
  r.images,
  r.likes,
  r.comments,
  r.views,
  r.created_at,
  r.updated_at,
  reviewer.name as reviewer_name,
  reviewer.username as reviewer_username,
  reviewer.avatar_url as reviewer_avatar_url,
  reviewed.name as reviewed_name,
  reviewed.username as reviewed_username
from public.reviews r
join public.profiles reviewer on reviewer.id = r.reviewer_id
join public.profiles reviewed on reviewed.id = r.reviewed_user_id;

create or replace view public.story_feed
with (security_invoker = true)
as
select
  s.id,
  s.user_id,
  s.video_url,
  s.image_url,
  s.caption,
  (select count(*)::integer from public.story_views sv where sv.story_id = s.id) as views,
  s.expires_at,
  s.created_at,
  p.name as user_name,
  p.avatar_url as user_avatar_url
from public.stories s
join public.profiles p on p.id = s.user_id
where s.expires_at > now();

alter table public.profiles enable row level security;
alter table public.follows enable row level security;
alter table public.reviews enable row level security;
alter table public.reviewer_badges enable row level security;
alter table public.notifications enable row level security;
alter table public.conversations enable row level security;
alter table public.messages enable row level security;
alter table public.blocked_users enable row level security;
alter table public.stories enable row level security;
alter table public.story_views enable row level security;

drop policy if exists "Public profiles are viewable by everyone" on public.profiles;
drop policy if exists "Users can insert their own profile" on public.profiles;
drop policy if exists "Users can update their own profile" on public.profiles;
drop policy if exists "Follows are viewable by everyone" on public.follows;
drop policy if exists "Users can follow others" on public.follows;
drop policy if exists "Users can unfollow" on public.follows;
drop policy if exists "Reviews are viewable by everyone" on public.reviews;
drop policy if exists "Users can create reviews" on public.reviews;
drop policy if exists "Users can update their own reviews" on public.reviews;
drop policy if exists "Badges are viewable by everyone" on public.reviewer_badges;
drop policy if exists "Notifications are viewable by owner" on public.notifications;
drop policy if exists "Users can update their own notifications" on public.notifications;
drop policy if exists "Users can view their conversations" on public.conversations;
drop policy if exists "Users can create conversations" on public.conversations;
drop policy if exists "Users can view their messages" on public.messages;
drop policy if exists "Users can send messages" on public.messages;
drop policy if exists "Users can update their received messages" on public.messages;
drop policy if exists "Users can view their blocks" on public.blocked_users;
drop policy if exists "Users can block others" on public.blocked_users;
drop policy if exists "Users can unblock" on public.blocked_users;

drop policy if exists profiles_select_public on public.profiles;
drop policy if exists profiles_insert_own on public.profiles;
drop policy if exists profiles_update_own on public.profiles;
create policy profiles_select_public on public.profiles for select using (true);
create policy profiles_insert_own on public.profiles for insert to authenticated with check ((select auth.uid()) = id);
create policy profiles_update_own on public.profiles for update to authenticated using ((select auth.uid()) = id) with check ((select auth.uid()) = id);

drop policy if exists follows_select_public on public.follows;
drop policy if exists follows_insert_own on public.follows;
drop policy if exists follows_delete_own on public.follows;
create policy follows_select_public on public.follows for select using (true);
create policy follows_insert_own on public.follows for insert to authenticated with check ((select auth.uid()) = follower_id);
create policy follows_delete_own on public.follows for delete to authenticated using ((select auth.uid()) = follower_id);

drop policy if exists reviews_select_public on public.reviews;
drop policy if exists reviews_insert_own on public.reviews;
drop policy if exists reviews_update_own on public.reviews;
drop policy if exists reviews_delete_own on public.reviews;
create policy reviews_select_public on public.reviews for select using (true);
create policy reviews_insert_own on public.reviews for insert to authenticated with check ((select auth.uid()) = reviewer_id);
create policy reviews_update_own on public.reviews for update to authenticated using ((select auth.uid()) = reviewer_id) with check ((select auth.uid()) = reviewer_id);
create policy reviews_delete_own on public.reviews for delete to authenticated using ((select auth.uid()) = reviewer_id);

drop policy if exists reviewer_badges_select_public on public.reviewer_badges;
create policy reviewer_badges_select_public on public.reviewer_badges for select using (true);

drop policy if exists notifications_select_own on public.notifications;
drop policy if exists notifications_update_own on public.notifications;
create policy notifications_select_own on public.notifications for select to authenticated using ((select auth.uid()) = user_id);
create policy notifications_update_own on public.notifications for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

drop policy if exists conversations_select_participants on public.conversations;
drop policy if exists conversations_insert_participant on public.conversations;
create policy conversations_select_participants on public.conversations for select to authenticated
  using ((select auth.uid()) = participant1_id or (select auth.uid()) = participant2_id);
create policy conversations_insert_participant on public.conversations for insert to authenticated
  with check ((select auth.uid()) = participant1_id or (select auth.uid()) = participant2_id);

drop policy if exists messages_select_participants on public.messages;
drop policy if exists messages_insert_sender on public.messages;
drop policy if exists messages_update_receiver on public.messages;
create policy messages_select_participants on public.messages for select to authenticated
  using ((select auth.uid()) = sender_id or (select auth.uid()) = receiver_id);
create policy messages_insert_sender on public.messages for insert to authenticated
  with check (
    (select auth.uid()) = sender_id
    and public.can_message_between(sender_id, receiver_id)
    and exists (
      select 1
      from public.conversations c
      where c.id = conversation_id
        and sender_id in (c.participant1_id, c.participant2_id)
        and receiver_id in (c.participant1_id, c.participant2_id)
    )
  );
create policy messages_update_receiver on public.messages for update to authenticated
  using ((select auth.uid()) = receiver_id)
  with check ((select auth.uid()) = receiver_id);

drop policy if exists blocked_users_select_own on public.blocked_users;
drop policy if exists blocked_users_insert_own on public.blocked_users;
drop policy if exists blocked_users_delete_own on public.blocked_users;
create policy blocked_users_select_own on public.blocked_users for select to authenticated using ((select auth.uid()) = blocker_id);
create policy blocked_users_insert_own on public.blocked_users for insert to authenticated with check ((select auth.uid()) = blocker_id);
create policy blocked_users_delete_own on public.blocked_users for delete to authenticated using ((select auth.uid()) = blocker_id);

drop policy if exists stories_select_visible on public.stories;
drop policy if exists stories_insert_own on public.stories;
drop policy if exists stories_delete_own on public.stories;
create policy stories_select_visible on public.stories for select to authenticated
  using (
    expires_at > now()
    and (
      user_id = (select auth.uid())
      or exists (
        select 1 from public.follows f
        where f.follower_id = (select auth.uid())
          and f.following_id = stories.user_id
      )
      or exists (
        select 1 from public.profiles p
        where p.id = stories.user_id and p.is_public = true
      )
    )
  );
create policy stories_insert_own on public.stories for insert to authenticated with check ((select auth.uid()) = user_id);
create policy stories_delete_own on public.stories for delete to authenticated using ((select auth.uid()) = user_id);

drop policy if exists story_views_select_own on public.story_views;
drop policy if exists story_views_insert_own on public.story_views;
create policy story_views_select_own on public.story_views for select to authenticated using ((select auth.uid()) = viewer_id);
create policy story_views_insert_own on public.story_views for insert to authenticated with check ((select auth.uid()) = viewer_id);

grant usage on schema public to anon, authenticated;
grant select on public.profiles, public.follows, public.reviews, public.reviewer_badges, public.review_feed, public.story_feed to anon, authenticated;
grant select, insert, update on public.profiles to authenticated;
grant select, insert, delete on public.follows to authenticated;
grant select, insert, update, delete on public.reviews to authenticated;
grant select, update on public.notifications to authenticated;
grant select, insert on public.conversations to authenticated;
grant select, insert, update on public.messages to authenticated;
grant select, insert, delete on public.blocked_users to authenticated;
grant select, insert, delete on public.stories to authenticated;
grant select, insert on public.story_views to authenticated;
grant execute on function public.get_follower_count(uuid) to anon, authenticated;
grant execute on function public.has_reviewer_badge(uuid) to anon, authenticated;
grant execute on function public.get_or_create_conversation(uuid) to authenticated;
grant execute on function public.get_conversation_summaries() to authenticated;
grant execute on function public.mark_story_viewed(uuid, uuid) to authenticated;

do $$
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime')
    and not exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'public'
        and tablename = 'messages'
    ) then
    alter publication supabase_realtime add table public.messages;
  end if;
end $$;
