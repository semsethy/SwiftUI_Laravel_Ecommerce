import SwiftUI
import KeychainAccess

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true
    @State private var loginMessage: String = ""
    @State private var navigateToHome = false
    @State private var navigateToRegister = false
    @State private var navigateToForgotPassword = false
    private let keychain = Keychain(service: "com.yourapp")
    let authManager = AuthManager()
    var onLoginSuccess: (() -> Void)? = nil
    @State private var tabSelection = 1

    var body: some View {
        NavigationStack{
            VStack(spacing: 14) {
                ScrollView(showsIndicators: false){
                    Image("vecteezy_mobile-device-security-with-password_").resizable().frame(maxHeight: 200)
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
                    
                    
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
                    HStack{
                        Spacer()
                        Button {
                            navigateToForgotPassword = true
                        } label: {
                            Text("Forgot Password?").font(.system(size: 16)).foregroundColor(.blue).bold()
                        }
                    }
     
                    Button(action: {
                        login()
                        
                    }) {
                        Text("Login")
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
                        VStack{
                            Divider().background(.secondary)
                        }
                        Text(" OR ").bold().foregroundStyle(.secondary).font(.system(size: 14))
                        VStack{
                            Divider().background(.secondary)
                        }
                    }
                    Button(action: {
                        login()
                    }) {
                        ZStack(alignment: .leading){
                            Text("Login With Google")
                                .foregroundColor(Color(UIColor(white: 0.4, alpha: 1)))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(10)
                            Image("Google__G__logo.svg")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(.leading, 20)
                                .font(.system(size: 16))
                        }
                    }
                    HStack{
                        Text("Don't have an account?")
                            .foregroundColor(Color(UIColor(white: 0.4, alpha: 1)))
                        Button {
                            navigateToRegister = true
                        } label: {
                            Text("Register")
                                .foregroundColor(.blue)
                                .bold()
                                .font(.system(size: 16))
                        }

                    }
                    .padding()
                    NavigationLink(destination: RegisterView().navigationBarHidden(true), isActive: $navigateToRegister) {
                        EmptyView()
                    }.hidden()
                    NavigationLink(destination: ForgotPasswordView().navigationBarHidden(true), isActive: $navigateToForgotPassword) {
                        EmptyView()
                    }.hidden()
                    CrossDissolvePresenter(content: MainView(selection: $tabSelection), isPresented: $navigateToHome)
    //                    .frame(width: 0, height: 0)
                }
                .contentShape(Rectangle()) // Makes the whole area tappable
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .padding()
        }
    }

    func login() {
        // Make an API call to login
        let url = URL(string: "http://127.0.0.1:8000/api/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.loginMessage = "Login failed"
                }
                return
            }
            
            if let data = data,
               let response = try? JSONDecoder().decode(LoginResponse.self, from: data),
               response.status == true {
                
                try? keychain.set(response.token, key: "auth_token")
                DispatchQueue.main.async {
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    onLoginSuccess?()
                }
            } else {
                DispatchQueue.main.async {
                    self.loginMessage = "Invalid credentials"
                }
            }
        }
        
        task.resume()
    }

}


struct LoginResponse: Codable {
    var status: Bool
    var token: String
}

#Preview {
    LoginView()
}
