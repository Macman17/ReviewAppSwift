import SwiftUI

struct StarRatingView: View {
    let rating: Int
    let size: CGFloat

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .font(.system(size: size))
                    .foregroundStyle(index <= rating ? AppTheme.gold : AppTheme.muted.opacity(0.45))
            }
        }
    }
}

struct StarPicker: View {
    @Binding var rating: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...5, id: \.self) { index in
                Button {
                    rating = index
                } label: {
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .font(.system(size: 36))
                        .foregroundStyle(index <= rating ? AppTheme.gold : AppTheme.muted.opacity(0.45))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
