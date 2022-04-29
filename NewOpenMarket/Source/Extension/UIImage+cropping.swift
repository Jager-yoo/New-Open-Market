//
//  UIImage+cropping.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/30.
//

import UIKit

extension UIImage {
    
    func cropAsSquare() -> CGImage? {
        let shorterLength = min(self.size.width, self.size.height)
        
        let xOffset = (self.size.width - shorterLength) / 2
        let yOffset = (self.size.height - shorterLength) / 2
        let centerSquareRect = CGRect(x: xOffset, y: yOffset, width: shorterLength, height: shorterLength)
        
        guard let croppedImage = self.cgImage?.cropping(to: centerSquareRect) else {
            return nil
        }
        
        return croppedImage
    }
}
