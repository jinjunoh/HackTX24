import SwiftUI
import FirebaseCore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Request notification permissions
        requestNotificationPermissions()
        
        // Set UNUserNotificationCenter delegate
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

    // Request permission to show notifications
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permissions granted.")
            } else if let error = error {
                print("Failed to request notifications permission: \(error)")
            }
        }
    }

    // Debug log when a notification is delivered
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification received with title: \(notification.request.content.title) and body: \(notification.request.content.body)")
        
        // Present the notification as a banner even when the app is in the foreground
        completionHandler([.banner, .sound])
    }
}

@main
struct HackTX24App: App {
    // Register AppDelegate for Firebase setup and notification handling
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // State variable to control login sheet presentation
    @State private var isLoggedIn = false
    @State private var showLoginSheet = true // Used to control sheet presentation

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .onAppear {
                        // Schedule a notification on app launch or wherever needed
                        scheduleMotivationalNotification()
                    }
                    .sheet(isPresented: $showLoginSheet) {
                        LoginSignupView(isLoggedIn: $isLoggedIn, showLoginSheet: $showLoginSheet)
                            .interactiveDismissDisabled(true) // Prevents swiping down to dismiss
                    }
            }
        }
    }

    // Schedule a local notification
    func scheduleMotivationalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Keep Learning!"
        content.body = "Translate a word to boost your language skills!"
        content.sound = .default

        // Trigger the notification 10 seconds after the app appears
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled with title: \(content.title) and body: \(content.body)")
            }
        }
    }
}
