import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    @Binding var showProfileSheet: Bool
    var onLogout: () -> Void // Logout action

    private var username: String {
        UserDefaults.standard.string(forKey: "savedUsername") ?? "Unknown User"
    }

    private var email: String {
        UserDefaults.standard.string(forKey: "savedEmail") ?? "Unknown Email" // Assuming you store the email in UserDefaults
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer() // Push the X button to the right
                Button(action: {
                    showProfileSheet = false // Dismiss the profile sheet
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.white) // Set color for the X button
                }
                .padding()
            }
            
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            // Profile Icon
            Image(systemName: "person.circle.fill") // Use the same icon as in the screenshot
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(.white)


            // User information
            VStack(alignment: .leading, spacing: 10) {
                Text("Name: \(username)")
                    .font(.title2)

                Text("Email: \(email)")
                    .font(.title2)
            }
            .padding()

            // Logout Button
            Button(action: logout) {
                Text("Logout")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .padding()
    }

    private func logout() {
        // Clear stored credentials and update state
        isLoggedIn = false
        showProfileSheet = false // Dismiss the profile sheet
        onLogout() // Call the logout action
    }
}
