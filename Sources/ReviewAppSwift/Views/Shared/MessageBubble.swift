import SwiftUI

struct MessageBubble: View {
    let message: Message
    let isOwn: Bool

    var body: some View {
        HStack {
            if isOwn { Spacer(minLength: 36) }

            VStack(alignment: isOwn ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(isOwn ? AppTheme.primary : AppTheme.elevatedSoft)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                Text(DateParser.relative(message.createdAt))
                    .font(.caption2)
                    .foregroundStyle(AppTheme.muted)
            }

            if !isOwn { Spacer(minLength: 36) }
        }
    }
}
