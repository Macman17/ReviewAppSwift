# ReviewApp Swift

Native SwiftUI port of the original Expo ReviewApp. The app uses Supabase for auth, profiles, follows, reviews, stories, notifications, and messaging.

The app is organized as Model-View-ViewModel. See `ARCHITECTURE.md` for the dependency rules and source layout.

## Requirements

- Xcode 16.4 or newer
- Swift 6.1 or newer
- iOS 16 or newer
- Supabase project with the SQL in `Supabase/schema.sql` applied

## Backend Setup

1. Open your Supabase project SQL editor.
2. Run `Supabase/schema.sql`.
3. In Supabase Authentication settings, decide whether email confirmation should be required.
4. If using Realtime for messages, confirm the `messages` table is enabled in Realtime publication. The SQL attempts to add it when the publication exists.

## Running

Open `ReviewAppSwift.xcodeproj` in Xcode and run the `ReviewAppSwift` scheme on an iOS simulator. The project wrapper builds a normal `ReviewAppSwift.app` bundle and links Supabase through Xcode's Swift Package support.

The Swift package is still present for source organization and command-line build checks. It declares:

```swift
.package(url: "https://github.com/supabase/supabase-swift.git", from: "2.0.0")
```

The app reads Supabase config from either environment variables, `Info.plist`, or the current fallback values in `SupabaseConfig.swift`:

- `SUPABASE_URL`
- `SUPABASE_PUBLISHABLE_KEY`
- `SUPABASE_ANON_KEY`

For production, set those values in your app target configuration instead of relying on the fallback.

## What Was Ported

- Supabase email/password sign in and sign up
- Profile loading, editing, search, follower/following counts
- Star, written, and video reviews persisted to Postgres
- Timeline feed through `review_feed`
- Stories through `stories`, `story_views`, and `story_feed`
- One-to-one conversations and messages through hardened RPC functions
- Notifications table and review notification trigger
