import SwiftUI

struct LoginSignupView: View {
    @Binding var isLoggedIn: Bool
    @Binding var showLoginSheet: Bool
    
    @State private var showLogin = false
    @State private var showSignUp = false
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var loginError: String? // State variable to hold any login error messages
    
    // Automatically fetch the device language
    private let deviceLanguage: String = {
        let preferredLanguageCode = Locale.preferredLanguages.first ?? "en"
        let language = Locale(identifier: preferredLanguageCode).localizedString(forLanguageCode: preferredLanguageCode) ?? NSLocalizedString("unknown_language", comment: "Unknown language")
        
        return language.capitalized // Capitalize the first letter for display
    }()

    // List of words in different languages
    private let words = ["Bienvenue", "Hola", "Welcome", "Willkommen", "Benvenuto", "欢迎", "Добро пожаловать", "स्वागत है"]

    var body: some View {
        VStack(spacing: 20) {
            if isLoggedIn {
                profileView // Show profile view if logged in
            } else if !showLogin && !showSignUp {
                initialView // Show initial view (Login/Signup options) if not logged in
            } else if showLogin {
                loginView // Show login form
            } else if showSignUp {
                signUpView // Show signup form
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.8), Color.black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        )
    }
    
    // Profile view when the user is logged in
    private var profileView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Welcome, \(username)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            
            // Profile actions
            Button(action: logout) {
                Text("Logout")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
    
    private var initialView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("app_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding(.bottom, 10)
            
            Text(NSLocalizedString("welcome", comment: "Welcome greeting"))
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .padding(.bottom, 10)
            
            Text(NSLocalizedString("subtitle", comment: "Subtitle"))
                .font(.body)
                .foregroundColor(Color.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            AnimatedWordsView(words: words)
                .frame(height: 30)
                .padding(.bottom, 30)
            
            Button(action: {
                withAnimation {
                    showSignUp = true
                }
            }) {
                Text(NSLocalizedString("create_account", comment: "Sign up button"))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: .pink.opacity(0.4), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, 40)
            
            Button(action: {
                withAnimation {
                    showLogin = true
                }
            }) {
                Text(NSLocalizedString("login", comment: "Log in button"))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, 40)
            .padding(.top, 10)
            
            Spacer()
        }
    }
    
    private var loginView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text(NSLocalizedString("login", comment: "Login title"))
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            
            TextField(NSLocalizedString("username_placeholder", comment: "Username or email placeholder"), text: $username)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.white)
                .padding(.horizontal, 40)
            
            SecureField(NSLocalizedString("password_placeholder", comment: "Password placeholder"), text: $password)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.white)
                .padding(.horizontal, 40)
            
            if let error = loginError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: login) {
                Text(NSLocalizedString("login", comment: "Log in button"))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            HStack {
                Text(NSLocalizedString("don_t_have_account", comment: "Prompt for sign up"))
                    .foregroundColor(Color.white.opacity(0.8))
                Button(action: {
                    withAnimation {
                        showLogin = false
                        showSignUp = true
                    }
                }) {
                    Text(NSLocalizedString("signup", comment: "Sign up link"))
                        .foregroundColor(Color.pink)
                        .fontWeight(.bold)
                }
            }
            .padding(.bottom, 20)
        }
        .transition(.opacity)
    }
    
    private var signUpView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text(NSLocalizedString("signup", comment: "Sign up title"))
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            
            TextField(NSLocalizedString("username_placeholder", comment: "Username placeholder"), text: $username)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.white)
                .padding(.horizontal, 40)
            
            TextField(NSLocalizedString("email_placeholder", comment: "Email placeholder"), text: $email)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.white)
                .padding(.horizontal, 40)
            
            SecureField(NSLocalizedString("password_placeholder", comment: "Password placeholder"), text: $password)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.white)
                .padding(.horizontal, 40)
            
            // Language display (non-interactive)
            Text(String(format: NSLocalizedString("language_display", comment: "Language display"), deviceLanguage))
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.1))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal, 40)
            
            Divider()
                .background(Color.white.opacity(0.3))
                .padding(.horizontal, 80)
            
            Button(action: createAccount) {
                Text(NSLocalizedString("signup", comment: "Sign up button"))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
            
            Spacer()
        }
        .transition(.opacity)
    }

    // Handle login logic here
    private func login() {
        guard !username.isEmpty && !password.isEmpty else {
            loginError = "Username and password cannot be empty."
            return
        }
        
        // Check if credentials are in Keychain
        if let savedPassword = KeychainHelper.getPassword(for: username),
           savedPassword == password {
            isLoggedIn = true
            showLoginSheet = false
            print("Logged in as user: \(username)")
        } else {
            // If credentials do not match, set error message
            loginError = "Invalid username or password."
        }
    }
    
    // Handle account creation logic here
    private func createAccount() {
        guard !username.isEmpty, !email.isEmpty, email.contains("@"), !password.isEmpty else {
            print("Please enter a valid username, email, and password.")
            return
        }
        
        // Perform account creation actions (e.g., save to Keychain, update state)
        KeychainHelper.savePassword(password, for: username)
        UserDefaults.standard.set(username, forKey: "savedUsername")
        
        isLoggedIn = true
        showLoginSheet = false
        print("Account created for user: \(username)")
    }

    // Handle logout and clear saved credentials
    private func logout() {
        if let savedUsername = UserDefaults.standard.string(forKey: "savedUsername") {
            KeychainHelper.removePassword(for: savedUsername)
        }
        
        UserDefaults.standard.removeObject(forKey: "savedUsername")
        
        isLoggedIn = false
        showLoginSheet = true
        username = ""
        password = ""
        
        print("Logged out successfully.")
    }
}


// Animated view for displaying words in different languages with a continuous sliding and fading effect at the edges
struct AnimatedWordsView: View {
    let words: [String]
    @State private var animate = false

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let wordSpacing: CGFloat = 50  // Adjust spacing between words
            let totalWidth = CGFloat(words.count) * (screenWidth / 3) + CGFloat(words.count - 1) * wordSpacing

            HStack(spacing: wordSpacing) {
                ForEach(words + words, id: \.self) { word in  // Duplicate the words array for a seamless loop
                    Text(word)
                        .font(.headline)
                        .foregroundColor(Color.white.opacity(0.8))
                        .fixedSize()  // Ensure each word displays fully without truncation
                }
            }
            .frame(width: totalWidth, alignment: .leading)
            .offset(x: animate ? -totalWidth / 2 : 0)  // Start moving from center to the left
            .onAppear {
                withAnimation(Animation.linear(duration: Double(words.count) * 2).repeatForever(autoreverses: false)) {
                    animate = true
                }
            }
            .mask(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.black.opacity(0), location: 0.0),
                        .init(color: Color.black, location: 0.1),
                        .init(color: Color.black, location: 0.9),
                        .init(color: Color.black.opacity(0), location: 1.0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
        }
        .frame(height: 30) // Restrict the height for the words animation
    }
}
