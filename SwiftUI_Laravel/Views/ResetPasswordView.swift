//
//  ResetPasswordView.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 11/4/25.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State var newPass: String = ""
    @State var conPass: String = ""
    @State private var errorMessage: String = ""
    @State private var navigateToHome = false
    @State private var showAlert = false
    @State private var isPassSecure: Bool = true
    @State private var isConPassSecure: Bool = true
    @State private var tabSelection = 1
    var otp: String

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
                    Image("vecteezy_cloud-computing-modern-flat-concept-for-web-banner-design_5879539").resizable().frame(maxHeight: 300)
                    Text("Reset Your Password")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
                    Text("Password:").frame(maxWidth: .infinity, alignment: .leading).foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
                    ZStack(alignment: .trailing) {
                        Group {
                            if isPassSecure {
                                SecureField("your new password here", text: $newPass).frame(height: 20)
                            } else {
                                TextField("your new password here", text: $newPass).frame(height: 20)
                            }
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)

                        Button(action: {
                            isPassSecure.toggle()
                        }) {
                            Image(systemName: isPassSecure ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 15)
                    }
                    Text("Confirm Password:").frame(maxWidth: .infinity, alignment: .leading).foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
                    ZStack(alignment: .trailing) {
                        Group {
                            if isConPassSecure {
                                SecureField("your confirm password here", text: $conPass).frame(height: 20)
                            } else {
                                TextField("your confirm password here", text: $conPass).frame(height: 20)
                            }
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)

                        Button(action: {
                            isConPassSecure.toggle()
                        }) {
                            Image(systemName: isConPassSecure ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 15)
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
                        if newPass == conPass && !newPass.isEmpty {
                            // Simulate successful reset
                            navigateToHome = true
                        } else {
                            errorMessage = "Passwords do not match or are empty"
                            showAlert = true
                        }
                    }) {
                        Text("Submit")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding()
                CrossDissolvePresenter(content: MainView(selection: $tabSelection), isPresented: $navigateToHome)
                    .frame(width: 0, height: 0)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Warning!"), message: Text(errorMessage), dismissButton: .default(Text("Okay")))
        }
    }
     

}


#Preview {
    ResetPasswordView(otp: "")
}


