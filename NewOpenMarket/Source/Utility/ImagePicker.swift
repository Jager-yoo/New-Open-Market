//
//  ImagePicker.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/15.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImages: [UIImage]
    
    // Use a Coordinator to act as your PHPickerViewControllerDelegate
    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        private let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // 이 코드는 메서드의 상단부에 있어야 함
            // 왜냐면, 사용자가 사진을 선택하거나, 아니면 [취소] 버튼을 눌렀을 때 모두 이 메서드가 호출되거든. guard문 아래에 있으면 dismiss 되질 않음
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    guard let convertedAsUIImage = image as? UIImage else { return }
                    self.parent.selectedImages.append(convertedAsUIImage)
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration() // photoLibrary: .shared()
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // 내용 없음
    }
}
