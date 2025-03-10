//
//  RouteImagePicker.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import SwiftUI
import Combine

struct RouteImagePicker: View {
    @Binding var selectedImage: UIImage?
    @StateObject private var uploadManager = ImageUploadManager()
    
    @State private var showingImagePicker = false
    
    var onImageUploaded: ((String) -> Void)?
    
    var body: some View {
        VStack(spacing: 12) {
            // Image preview or placeholder
            ZStack {
                if let image = selectedImage {
                    // Show selected image
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                } else {
                    // Show placeholder
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 200)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                
                                Text("Add route image")
                                    .font(.custom(Constants.Fonts.regular, size: 16))
                                    .foregroundColor(.gray)
                            }
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
                
                // Image upload controls
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        // Add/change image button
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            Image(systemName: selectedImage == nil ? "plus.circle.fill" : "pencil.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(Color(hex: Constants.Colors.accent))
                                .background(Color.white.clipShape(Circle()))
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        .padding(16)
                    }
                }
            }
            
            // Upload progress
            if uploadManager.isUploading {
                ProgressView(value: uploadManager.uploadProgress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding(.horizontal)
            }
            
            // Error message
            if let error = uploadManager.errorMessage {
                Text(error)
                    .font(.custom(Constants.Fonts.regular, size: 14))
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            // Upload button
            if selectedImage != nil && uploadManager.imageURL == nil && !uploadManager.isUploading {
                Button(action: {
                    if let image = selectedImage {
                        uploadManager.uploadImage(image) { url in
                            onImageUploaded?(url)
                        }
                    }
                }) {
                    Text("Upload Image")
                        .font(.custom(Constants.Fonts.medium, size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color(hex: Constants.Colors.accent))
                        .cornerRadius(8)
                }
                .padding(.top, 8)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerView(selectedImage: $selectedImage)
        }
    }
}

class ImageUploadManager: ObservableObject {
    @Published var isUploading = false
    @Published var uploadProgress = 0.0
    @Published var imageURL: String?
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func uploadImage(_ image: UIImage, onComplete: @escaping (String) -> Void) {
        
        isUploading = true
        uploadProgress = 0.2
        errorMessage = nil
        
        ImageService.shared.uploadImage(image: image)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] result in
                    guard let self = self else { return }
                    if case .failure(let error) = result {
                        self.isUploading = false
                        self.errorMessage = "Failed to upload: \(error.localizedDescription)"
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.uploadProgress = 1.0
                    self.imageURL = response.imageURL
                    
                    // Notify caller
                    onComplete(response.imageURL)
                    
                    // Reset upload state
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.isUploading = false
                    }
                }
            )
            .store(in: &cancellables)
    }
}
