import SwiftUI

struct ReviewFeedCard: View {
    let review: ReviewFeedItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                AvatarView(urlString: review.reviewerAvatarURL, size: 44)

                VStack(alignment: .leading, spacing: 3) {
                    Text(review.reviewerDisplayName)
                        .font(.headline)
                        .foregroundStyle(AppTheme.text)

                    Text("Reviewed \(review.reviewedDisplayName) • \(DateParser.relative(review.createdAt))")
                        .font(.caption)
                        .foregroundStyle(AppTheme.muted)
                }

                Spacer()

                Image(systemName: review.reviewType.systemImage)
                    .foregroundStyle(review.reviewType == .star ? AppTheme.gold : AppTheme.primary)
            }

            switch review.reviewType {
            case .star:
                StarRatingView(rating: review.rating ?? 0, size: 24)
                if let content = review.content.nilIfBlank {
                    Text(content)
                        .foregroundStyle(AppTheme.text)
                }
            case .written:
                if let title = review.title.nilIfBlank {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(AppTheme.text)
                }
                if let content = review.content.nilIfBlank {
                    Text(content)
                        .foregroundStyle(AppTheme.muted)
                        .lineLimit(5)
                }
            case .video:
                if let thumbnail = review.thumbnailURL.nilIfBlank {
                    AsyncImage(url: URL(string: thumbnail)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Rectangle().fill(AppTheme.elevatedSoft)
                    }
                    .frame(height: 190)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .overlay {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 54))
                            .foregroundStyle(.white.opacity(0.86))
                    }
                }
                Text(review.title.nilIfBlank ?? "Video review")
                    .font(.headline)
                    .foregroundStyle(AppTheme.text)
            }

            HStack(spacing: 18) {
                Label("\(review.likes)", systemImage: "heart")
                Label("\(review.comments)", systemImage: "bubble.right")
                if review.reviewType == .video {
                    Label("\(review.views)", systemImage: "eye")
                }
            }
            .font(.caption)
            .foregroundStyle(AppTheme.muted)
        }
        .appCard()
    }
}
