//
//  UIImage+ScaledMethod.swift
//  SpaceSwift
//
//  Created by Gerrit Grunwald on 26.12.19.
//  Copyright © 2019 Gerrit Grunwald. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    func scale(with size: CGSize) -> UIImage? {
        var scaledImageRect      = CGRect.zero
    
        let aspectWidth:CGFloat  = size.width / self.size.width
        let aspectHeight:CGFloat = size.height / self.size.height
        let aspectRatio:CGFloat  = min(aspectWidth, aspectHeight)
    
        scaledImageRect.size.width  = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x    = (size.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y    = (size.height - scaledImageRect.size.height) / 2.0
    
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
    
        self.draw(in: scaledImageRect)
    
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return scaledImage
    }
}
