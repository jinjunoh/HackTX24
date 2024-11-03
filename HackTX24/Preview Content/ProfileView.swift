import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    @Binding var showProfileSheet: Bool
    var onLogout: () -> Void // Add this parameter

    private var username: String {
        UserDefaults.standard.string(forKey: "savedUsername") ?? "Unknown User"
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            Text("Username: \(username)")
                .font(.title2)
            
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
