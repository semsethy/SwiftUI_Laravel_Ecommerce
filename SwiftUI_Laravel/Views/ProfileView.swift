import SwiftUI

struct ProfileScreen: View {
    var body: some View {
        NavigationView {
            ProfileView()
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var username: String = "Sem Sethy"
    @State private var email: String = "semsethy168@gmail.com"
    @State private var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode")
    @State private var showingImagePicker = false
    @State private var showLogoutAlert = false
    let keychainManager = KeychainManager()
    @State private var profileImage: Image? = Image("semsethy")
    @State private var selectedUIImage: UIImage?

    var body: some View {
        NavigationStack{
            List {
                Section {
                    HStack {
                        NavigationLink(destination: Text("Settings View")) {
                            ZStack(alignment: .bottomTrailing) {
                                profileImage?
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .shadow(radius: 10)
                                    .onTapGesture {
                                        showingImagePicker = true
                                    }
                                Button(action: {
                                    showingImagePicker = true
                                }) {
                                    Image(systemName: "camera.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.gray)
                                        .background(Color.white.opacity(1))
                                        .clipShape(Circle())
                                        .padding(8)
                                        .offset(x: 10, y: 10)
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(username)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Text(email)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                    }
                    
                    NavigationLink(destination: Text("Settings View")) {
                        Text("Achievements")
                    }
                }
                Section(header: Text("Account")) {
                    Button("Change Username") {
                        
                    }
                    
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                    .onChange(of: isDarkMode) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "isDarkMode")
                        updateAppAppearance()
                    }
                }
                
                Section(header: Text("Preferences")) {
                    NavigationLink(destination: Text("Settings View")) {
                        Label("Settings", systemImage: "gear")
                    }
                    
                    NavigationLink(destination: Text("Privacy View")) {
                        Label("Privacy", systemImage: "lock.shield")
                    }
                    
                    NavigationLink(destination: Text("Help View")) {
                        Label("Help", systemImage: "questionmark.circle")
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showLogoutAlert = true
                    } label: {
                        Label("Logout", systemImage: "arrow.backward.circle")
                    }
                }
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Profile Settings")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedUIImage, onImagePicked: { image in
                    profileImage = Image(uiImage: image)
                })
            }
            .alert(isPresented: $showLogoutAlert){
                Alert(title: Text("Logout"), message: Text("Are you sure you want to logout?"), primaryButton: .destructive(Text("Logout"), action: logout), secondaryButton: .cancel())
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }

    func updateAppAppearance() {
        if isDarkMode {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        } else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        }
    }

    func logout() {
        keychainManager.removeToken()
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        cartViewModel.clearCart()
    }
}

#Preview {
    ProfileView()
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var onImagePicked: (UIImage) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.onImagePicked(uiImage)
            }
            picker.dismiss(animated: true)
        }
    }
}

