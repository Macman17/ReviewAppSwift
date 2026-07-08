import SwiftUI

struct AvatarView: View {
    let urlString: String?
    let size: CGFloat

    var body: some View {
        AsyncImage(url: URL(string: urlString ?? "")) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            ZStack {
                Circle().fill(AppTheme.elevatedSoft)
                Image(systemName: "person.fill")
                    .foregroundStyle(AppTheme.muted)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}
