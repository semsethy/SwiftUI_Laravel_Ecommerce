//
//  RegisterView.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 11/4/25.
//


import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true
    @State private var loginMessage: String = ""
    @State private var navigateToHome = false
    @State private var navigateToLogin = false
    @State private var tabSelection = 1
    @State private var showAlert = false
    @State private var alertMessage = ""

    
    var termsText: some View {
        Text("By signing up, you're agreeing to our ")
            .foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
        +
        Text("Terms & Conditions")
            .foregroundColor(.blue)
            .underline()
        +
        Text(" and ")
            .foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
        +
        Text("Privacy Policy")
            .foregroundColor(.blue)
            .underline()
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                ScrollView(showsIndicators: false){
                    Image("vecteezy_man-is-touching-multiple-high-tech-screens_4689204").resizable().frame(maxHeight: 200)
                    Text("Sign up")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
                    
                    
                    Text("Username:").frame(maxWidth: .infinity, alignment: .leading).foregroundColor(Color(UIColor(white: 0.2, alpha: 1)))
                    TextField("your username here", text: $username)
                        .autocapitalization(.none)
                        .frame(height: 20)
                        .keyboardType(.default)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    Text("Email:").frame(maxWidth: .infinity, alignment: .leading).foregroundColor(Color(UIColor(white: 0.2, alpha: 1)))
                    TextField("your email here", text: $email)
                        .autocapitalization(.none)
                        .frame(height: 20)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    Text("Password:").frame(maxWidth: .infinity, alignment: .leading).foregroundColor(Color(UIColor(white: 0.2, alpha: 1)))
                    ZStack(alignment: .trailing) {
                        Group {
                            if isSecure {
                                SecureField("your password here", text: $password).frame(height: 20)
                            } else {
                                TextField("your password here", text: $password).frame(height: 20)
                            }
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)

                        Button(action: {
                            isSecure.toggle()
                        }) {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 15)
                    }
                    termsText
                        .font(.system(size: 14))
                        .multilineTextAlignment(.leading)
                        .padding([.top, .bottom], 10)
                        

                    Button(action: {
                        handleRegister()
//                        navigateToHome = true
                    }) {
                        Text("Continue")
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
                    HStack{
                        Text("Already have an account?")
                            .foregroundColor(Color(UIColor(white: 0.4, alpha: 1)))
                        Button {
                            navigateToLogin = true
                        } label: {
                            Text("Login")
                                .foregroundColor(.blue)
                                .bold()
                                .font(.system(size: 16))
                        }
                    }
                    .padding()
                    NavigationLink(destination: LoginView().navigationBarHidden(true), isActive: $navigateToLogin) {
                        EmptyView()
                    }.hidden()
                    CrossDissolvePresenter(content: MainView(selection: $tabSelection), isPresented: $navigateToHome)
                        .frame(width: 0, height: 0)
                }
                .contentShape(Rectangle()) // Makes the whole area tappable
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Success!"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func handleRegister() {
        let url = URL(string: "http://127.0.0.1:8000/api/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = ["name": username, "email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error during registration: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.alertMessage = "Registration failed: \(error.localizedDescription)"
                    self.showAlert = true
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.alertMessage = "Invalid response from server"
                    self.showAlert = true
                }
                return
            }

            if httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    self.alertMessage = "Registration successful! Please log in."
                    self.showAlert = true
                    self.navigateToLogin = true
                }
            } else {
                DispatchQueue.main.async {
                    self.alertMessage = "Registration failed. Status code: \(httpResponse.statusCode)"
                    self.showAlert = true
                }
            }
        }
        
        task.resume()
    }

}

#Preview {
    RegisterView()
}
