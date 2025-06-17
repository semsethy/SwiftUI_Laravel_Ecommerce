//
//  ForgotPasswordView.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 11/4/25.
//


import SwiftUI


struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var loginMessage: String = ""
    @State private var navigateToResetPassword = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.backward").resizable().frame(width: 25, height: 20).foregroundColor(Color(UIColor(white: 0.4, alpha: 1)))
                    }
                    Spacer()
                }.padding(.leading)
                VStack(alignment: .leading,spacing: 14) {
                    Image("vecteezy_server-data-security-lock_").resizable().frame(maxHeight: 300)
                    Text("Forgot Your Password?")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
                    
                    Text("Don't worry! It happens. Please enter the email address associated with your account.").foregroundColor(Color(UIColor(white: 0.4, alpha: 1)))
                    
                    Text("Email:").frame(maxWidth: .infinity, alignment: .leading).foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
                    TextField("your email here", text: $email)
                        .autocapitalization(.none)
                        .frame(height: 20)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    HStack{
                        VStack{
                            Divider().background(Color(UIColor(white: 0.4, alpha: 1)))
                        }
                        Text(" Then Click On ").foregroundColor(Color(UIColor(white: 0.4, alpha: 1))).font(.system(size: 14))
                        VStack{
                            Divider().background(Color(UIColor(white: 0.4, alpha: 1)))
                        }
                    }
                    Button(action: {
                        navigateToResetPassword = true
                    }) {
                        Text("Submit")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                    if !loginMessage.isEmpty {
                        Text(loginMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    Spacer()
                    NavigationLink(destination: OTPView().navigationBarHidden(true), isActive: $navigateToResetPassword) {
                        EmptyView()
                    }.hidden()
                }
                .padding()
                
            }
        }
    }

    func handleLogin() {
        
    }
}

#Preview {
    ForgotPasswordView()
}
