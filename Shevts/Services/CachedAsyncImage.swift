//
//  CachedAsyncImage.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import SwiftUI
import Combine

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    @StateObject private var loader = ImageLoader()
    private let urlString: String?
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    init(urlString: String?,
         @ViewBuilder content: @escaping (Image) -> Content,
         @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.urlString = urlString
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                content(Image(uiImage: image))
            } else {
                placeholder()
            }
        }
        .onAppear {
            loader.load(from: urlString)
        }
        .onDisappear {
            loader.cancel()
        }
    }
    
    class ImageLoader: ObservableObject {
        @Published var image: UIImage?
        private var cancellable: AnyCancellable?
        
        func load(from urlString: String?) {
            guard let urlString = urlString, !urlString.isEmpty else { return }
            
            cancellable = ImageService.shared.loadImage(from: urlString)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] image in
                    self?.image = image
                }
        }
        
        func cancel() {
            cancellable?.cancel()
        }
    }
}

// Extension to make it easier to use
extension CachedAsyncImage where Content == Image {
    init(urlString: String?,
         @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.init(urlString: urlString,
                  content: { image in image.resizable() },
                  placeholder: placeholder)
    }
}
