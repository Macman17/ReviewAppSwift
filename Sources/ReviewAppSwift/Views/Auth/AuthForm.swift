import SwiftUI

struct AuthForm: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @State private var isSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var name = ""

    var body: some View {
        VStack(spacing: 14) {
            Picker("Mode", selection: $isSignUp) {
                Text("Sign In").tag(false)
                Text("Sign Up").tag(true)
            }
            .pickerStyle(.segmented)

            VStack(spacing: 10) {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                if isSignUp {
                    TextField("Username", text: $username)
                        .textFieldStyle(.roundedBorder)

                    TextField("Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                }
            }

            if let error = sessionStore.errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(AppTheme.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button {
                Task {
                    if isSignUp {
                        await sessionStore.signUp(
                            email: email,
                            password: password,
                            username: username,
                            name: name
                        )
                    } else {
                        await sessionStore.signIn(email: email, password: password)
                    }
                }
            } label: {
                Text(isSignUp ? "Create Account" : "Sign In")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.primary)
            .disabled(email.nilIfBlank == nil || password.nilIfBlank == nil || sessionStore.isLoading)
        }
        .appCard()
    }
}
