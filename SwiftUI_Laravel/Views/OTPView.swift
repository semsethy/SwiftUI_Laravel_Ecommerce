//
//  OTPView.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 11/4/25.
//

import SwiftUI

struct OTPView: View {
    @Environment(\.dismiss) var dismiss
    @State private var otpValues: [String] = ["", "", "", "", "", ""]
    @FocusState private var focusedField: Int?
    @State private var email: String = "sethyrisk@gmail.com"
    @State private var loginMessage: String = ""
    @State private var navigateToResetPassword = false
    var otp: String {
        otpValues.joined()
    }

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
                    Image("vecteezy_man-entering-security-password_4689193-1").resizable().frame(maxHeight: 300)
                    Text("Enter OTP")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
                    
                    Text("An 6 digit code has been sent to: \(email).").foregroundColor(Color(UIColor(white: 0.4, alpha: 1)))
                    HStack(spacing: 15) {
                        ForEach(0..<6, id: \.self) { index in
                            OTPTextBox(index: index, otpValues: $otpValues, focusedField: _focusedField)
                        }
                    }
                    .onAppear {
                        focusedField = 0
                    }


                    
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
                    NavigationLink(destination: ResetPasswordView(otp: otp).navigationBarHidden(true), isActive: $navigateToResetPassword) {
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
    OTPView()
}
