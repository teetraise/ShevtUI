//
//  ImagePickerView.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import SwiftUI
import UIKit
import PhotosUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else {
                return
            }
            
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self, let image = image as? UIImage else { return }
                    self.parent.selectedImage = image
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}

// A button that shows the image picker
struct ImagePickerButton: View {
    @Binding var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        Button(action: {
            showingImagePicker = true
        }) {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        ZStack {
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(Color(hex: Constants.Colors.accent))
                                .background(Color.white.clipShape(Circle()))
                        }
                        .offset(x: 30, y: 30),
                        alignment: .bottomTrailing
                    )
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .overlay(
                        ZStack {
                            Image(systemName: "person.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(Color(hex: Constants.Colors.accent))
                                .background(Color.white.clipShape(Circle()))
                                .offset(x: 30, y: 30)
                        }
                    )
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerView(selectedImage: $selectedImage)
        }
    }
}
