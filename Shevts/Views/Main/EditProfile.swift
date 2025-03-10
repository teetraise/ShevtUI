import SwiftUI
import Combine

struct EditProfileView: View {
    // Binding to control showing this view
    @Binding var isPresented: Bool
    
    // Form field states
    @State private var username: String = ""
    @State private var handle: String = ""
    @State private var bio: String = "Travel enthusiast and food lover. Always looking for new experiences and hidden gems around the world."
    @State private var email: String = ""
    
    // Image upload states
    @State private var selectedImage: UIImage? = nil
    
    // UserDataStore for accessing current user data
    @ObservedObject private var userDataStore = UserDataStore.shared
    
    // Profile update manager
    @StateObject private var updateManager = ProfileUpdateManager()
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: Constants.Colors.background)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header with close button
                    HStack {
                        // Close button
                        Button(action: {
                            // Close the view
                            isPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        // Title
                        Text("Edit Profile")
                            .font(.custom(Constants.Fonts.medium, size: 20))
                        
                        Spacer()
                        
                        // Empty space for balance
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(.clear)
                    }
                    .padding(.top, 16)
                    
                    // Avatar section
                    VStack(spacing: 16) {
                        // Avatar with edit button
                        ImagePickerButton(selectedImage: $selectedImage)
                            .padding(.top, 16)
                        
                        // Show upload progress if uploading
                        if updateManager.isUploading {
                            ProgressView(value: updateManager.uploadProgress, total: 1.0)
                                .progressViewStyle(LinearProgressViewStyle())
                                .frame(width: 100)
                        }
                        
                        // Show error message if any
                        if let error = updateManager.errorMessage {
                            Text(error)
                                .font(.custom(Constants.Fonts.regular, size: 14))
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Form fields
                    VStack(spacing: 20) {
                        // Name field
                        inputField(title: "Name", text: $username)
                        
                        // Username field
                        inputField(title: "Username", text: $handle, prefix: "@")
                        
                        // Bio field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bio")
                                .font(.custom(Constants.Fonts.medium, size: 16))
                                .foregroundColor(.black)
                            
                            TextEditor(text: $bio)
                                .font(.custom(Constants.Fonts.regular, size: 16))
                                .padding(12)
                                .frame(height: 100)
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        // Email field (readonly)
                        inputField(title: "Email", text: $email, isEditable: false)
                    }
                    
                    // Save button
                    Button(action: {
                        saveProfile()
                    }) {
                        Text("Save Changes")
                            .font(.custom(Constants.Fonts.medium, size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(hex: Constants.Colors.accent))
                            .cornerRadius(10)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                    .disabled(updateManager.isUploading)
                }
                .padding(.horizontal, 26)
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            loadUserData()
        }
    }
    
    // Helper functions
    // Input field style remains the same...
    
    // Load user data
    private func loadUserData() {
        if let user = userDataStore.currentUser {
            username = user.username
            handle = user.username.lowercased()
            email = user.email
            
            // Load avatar image
            if !user.avatarURL.isEmpty {
                updateManager.loadUserAvatar(from: user.avatarURL) { image in
                    self.selectedImage = image
                }
            }
        }
    }
    
    // Save profile changes
    private func saveProfile() {
        updateManager.errorMessage = nil
        
        // If image was changed, upload it first
        if let newImage = selectedImage, let user = userDataStore.currentUser,
           // Check if image is different from the current avatar
           !ImageService.shared.isImageFromURL(newImage, urlString: user.avatarURL) {
            
            updateManager.uploadImage(newImage) { result in
                switch result {
                case .success(let imageURL):
                    updateUserProfile(avatarURL: imageURL)
                case .failure(let error):
                    updateManager.errorMessage = "Failed to upload image: \(error.localizedDescription)"
                }
            }
        } else {
            // No image change, just update profile
            updateUserProfile()
        }
    }
    
    // Update user profile
    private func updateUserProfile(avatarURL: String? = nil) {
        guard userDataStore.currentUser != nil else {
            updateManager.errorMessage = "User data not found"
            return
        }
        
        updateManager.updateUserProfile(
            username: username,
            avatarURL: avatarURL
        ) { result in
            switch result {
            case .success(let updatedUser):
                // Update the user in the store
                UserDataStore.shared.saveCurrentUser(updatedUser)
                
                // Close the edit view
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isPresented = false
                }
                
            case .failure(let error):
                updateManager.errorMessage = "Failed to update profile: \(error.localizedDescription)"
            }
        }
    }
    
    // Input field style
    private func inputField(title: String, text: Binding<String>, prefix: String = "", isEditable: Bool = true) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom(Constants.Fonts.medium, size: 16))
                .foregroundColor(.black)
            
            HStack(spacing: 0) {
                if !prefix.isEmpty {
                    Text(prefix)
                        .font(.custom(Constants.Fonts.regular, size: 16))
                        .foregroundColor(.gray)
                }
                
                if isEditable {
                    TextField("", text: text)
                        .font(.custom(Constants.Fonts.regular, size: 16))
                } else {
                    Text(text.wrappedValue)
                        .font(.custom(Constants.Fonts.regular, size: 16))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

class ProfileUpdateManager: ObservableObject {
    @Published var isUploading = false
    @Published var uploadProgress = 0.0
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadUserAvatar(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        ImageService.shared.loadImage(from: urlString)
            .receive(on: DispatchQueue.main)
            .sink { image in
                completion(image)
            }
            .store(in: &cancellables)
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        isUploading = true
        uploadProgress = 0.2
        
        UserService.shared.uploadAvatar(image: image)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] result in
                    if case .failure(let error) = result {
                        completion(.failure(error))
                    }
                    self?.uploadProgress = 1.0
                },
                receiveValue: { [weak self] imageURL in
                    self?.uploadProgress = 0.8
                    completion(.success(imageURL))
                }
            )
            .store(in: &cancellables)
    }
    
    func updateUserProfile(username: String, avatarURL: String? = nil, completion: @escaping (Result<User, Error>) -> Void) {
        isUploading = true
        uploadProgress = avatarURL != nil ? 0.9 : 0.3
        
        UserService.shared.updateProfile(
            username: username,
            avatarURL: avatarURL
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] result in
                self?.isUploading = false
                if case .failure(let error) = result {
                    completion(.failure(error))
                }
            },
            receiveValue: { [weak self] updatedUser in
                self?.uploadProgress = 1.0
                completion(.success(updatedUser))
            }
        )
        .store(in: &cancellables)
    }
}
