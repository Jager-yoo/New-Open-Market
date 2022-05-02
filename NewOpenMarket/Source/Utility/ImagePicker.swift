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
            
            // results 배열을 forEach 를 돌리면서 append 하면, 이미지 5장 제한을 넘기면서 첨부할 수 있으므로, 1장 씩 첨부 가능하도록 함
            // 아래 코드는 이미지 multi-selection 에도 대응할 수 있는 코드임. 이미지 제한 정책이 변경되어도 아래 코드는 수정할 필요 없음!
            let providers = results.compactMap { $0.itemProvider }.filter { $0.canLoadObject(ofClass: UIImage.self) }
            
            providers.forEach { provider in
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    guard let convertedAsUIImage = image as? UIImage, error == nil else { return }
                    DispatchQueue.main.async {
                        self.parent.selectedImages.append(convertedAsUIImage)
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // images 안에는 livePhotos 포함되어 있음!
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // 내용 없음
    }
}
