import SwiftUI

struct WelcomeAuthView: View {
    var body: some View {
        ZStack {
            Image("StartBackground", bundle: AppResources.bundle)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            LinearGradient(
                colors: [.black.opacity(0.75), .black.opacity(0.25), .black.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    Image("Logo", bundle: AppResources.bundle)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 170, height: 170)
                        .padding(.top, 52)

                    VStack(spacing: 8) {
                        Text("Review App")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundStyle(.white)

                        Text("Make sure you full picture!!")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.muted)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    AuthForm()
                }
                .frame(maxWidth: 420)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 22)
                .padding(.bottom, 32)
            }
        }
    }
}
