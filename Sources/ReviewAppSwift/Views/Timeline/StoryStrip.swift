import SwiftUI

struct StoryStrip: View {
    let stories: [Story]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                Button {} label: {
                    VStack(spacing: 7) {
                        ZStack(alignment: .bottomTrailing) {
                            Circle()
                                .fill(AppTheme.elevatedSoft)
                                .frame(width: 66, height: 66)
                                .overlay {
                                    Image(systemName: "camera.fill")
                                        .foregroundStyle(.white)
                                }

                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                                .foregroundStyle(AppTheme.primary)
                                .background(Circle().fill(.black))
                        }

                        Text("My Story")
                            .font(.caption2)
                            .foregroundStyle(AppTheme.text)
                    }
                }
                .buttonStyle(.plain)

                ForEach(stories) { story in
                    VStack(spacing: 7) {
                        AvatarView(urlString: story.userAvatarURL, size: 66)
                            .overlay {
                                Circle()
                                    .stroke(AppTheme.primary, lineWidth: 3)
                            }

                        Text(story.userName.nilIfBlank ?? "Story")
                            .font(.caption2)
                            .foregroundStyle(AppTheme.text)
                            .lineLimit(1)
                            .frame(width: 76)
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .appCard()
    }
}
