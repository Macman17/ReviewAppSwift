import Foundation

enum SupabaseConfig {
    private static let bundledURL = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String
    private static let bundledAnonKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String

    static let url = URL(
        string: ProcessInfo.processInfo.environment["SUPABASE_URL"]
            ?? bundledURL
            ?? "https://ytmzgtjjkiqoayzhsolq.supabase.co"
    )!

    static let anonKey = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"]
        ?? bundledAnonKey
        ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl0bXpndGpqa2lxb2F5emhzb2xxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg0NDcxMDIsImV4cCI6MjA4NDAyMzEwMn0.IwcAnDhJuJUS_GkgsUFlhZY1OS08TtVci514qBCJ3dw"
}
