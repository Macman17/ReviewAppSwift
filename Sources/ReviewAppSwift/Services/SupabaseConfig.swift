import Foundation

enum SupabaseConfig {
    private static let bundledURL = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String
    private static let bundledPublishableKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_PUBLISHABLE_KEY") as? String
    private static let bundledAnonKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String

    static let url = URL(string: urlString)!

    private static let urlString = ProcessInfo.processInfo.environment["SUPABASE_URL"]
        ?? bundledURL
        ?? "https://mieedpiarvpcndbuccfl.supabase.co"

    static let publishableKey = ProcessInfo.processInfo.environment["SUPABASE_PUBLISHABLE_KEY"]
        ?? ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"]
        ?? bundledPublishableKey
        ?? bundledAnonKey
        ?? "sb_publishable_f1lc7cc1QDtGipsINC_mVA_esXD4wkG"
}
