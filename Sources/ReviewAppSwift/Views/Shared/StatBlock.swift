import SwiftUI

struct StatBlock: View {
    let value: Int
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("\(value)")
                .font(.headline)
                .foregroundStyle(AppTheme.text)
            Text(label)
                .font(.caption)
                .foregroundStyle(AppTheme.muted)
        }
    }
}
