//
//  ProfileView.swift
//  HackTX24
//
//  Created by Joseph on 11/3/24.
//


import SwiftUI

struct ProfileView: View {
    // Access the dismiss environment to close the sheet
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            // Top bar with "X" button for dismissing the view
            HStack {
                Spacer()
                
                Button(action: {
                    dismiss() // Dismiss the sheet
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            Spacer()
            
            // Main content
            Text("Welcome to HackTX24!")
                .font(.headline)
                .padding()

            Text("Please log in or sign up to access your profile.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Button(action: {
                // Redirect to Login page
            }) {
                Text("Log In")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
            }

            Button(action: {
                // Redirect to Sign Up page
            }) {
                Text("Sign Up")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
