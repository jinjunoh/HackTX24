import SwiftUI

struct LoginSignupView: View {
    @Binding var isLoggedIn: Bool
    @Binding var showLoginSheet: Bool
    
    @State private var showLogin = false
    @State private var showSignUp = false
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    
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
            if !showLogin && !showSignUp {
                initialView
            } else if showLogin {
                loginView
            } else if showSignUp {
                signUpView
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
            
            VStack(spacing: 4) {
                Text(NSLocalizedString("you_are_safe", comment: "Safety message"))
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(NSLocalizedString("read_terms", comment: "Terms and conditions link"))
                    .font(.footnote)
                    .foregroundColor(.pink.opacity(0.8))
            }
            .padding(.bottom, 20)
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
            
            Button(action: {
                isLoggedIn = true
                showLoginSheet = false
                print("Logged in as user: \(username)")
            }) {
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
            
            Button(action: {
                isLoggedIn = true
                showLoginSheet = false
                print("Account created for user: \(username)")
            }) {
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
            
            HStack {
                Text(NSLocalizedString("already_have_account", comment: "Prompt for login"))
                    .foregroundColor(Color.white.opacity(0.8))
                Button(action: {
                    withAnimation {
                        showSignUp = false
                        showLogin = true
                    }
                }) {
                    Text(NSLocalizedString("login", comment: "Log in link"))
                        .foregroundColor(Color.pink)
                        .fontWeight(.bold)
                }
            }
            .padding(.bottom, 20)
        }
        .transition(.opacity)
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
