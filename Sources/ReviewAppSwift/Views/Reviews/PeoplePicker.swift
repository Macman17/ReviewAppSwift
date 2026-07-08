import SwiftUI

struct PeoplePicker: View {
    @Binding var selectedProfile: Profile?
    @StateObject private var search = PeopleSearchViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Person")
                .font(.headline)
                .foregroundStyle(AppTheme.text)

            HStack {
                TextField("Search users", text: $search.query)
                    .textFieldStyle(.roundedBorder)

                Button {
                    Task { await search.search() }
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.secondary)
            }

            if let selectedProfile {
                HStack {
                    AvatarView(urlString: selectedProfile.avatarURL, size: 34)
                    Text(selectedProfile.displayName)
                        .foregroundStyle(AppTheme.text)
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(AppTheme.primary)
                }
                .padding(.vertical, 4)
            }

            ForEach(search.results) { profile in
                Button {
                    selectedProfile = profile
                } label: {
                    HStack {
                        AvatarView(urlString: profile.avatarURL, size: 38)
                        VStack(alignment: .leading) {
                            Text(profile.displayName)
                                .foregroundStyle(AppTheme.text)
                            Text(profile.handle)
                                .font(.caption)
                                .foregroundStyle(AppTheme.muted)
                        }
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
                .padding(.vertical, 4)
            }
        }
        .appCard()
    }
}
