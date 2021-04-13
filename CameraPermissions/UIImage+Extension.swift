//
//  UIImage+Extension.swift
//  CameraPermissions
//
//  Created by Aaron Cleveland on 4/12/21.
//

import Foundation
import UIKit
import CoreImage

enum FilterType: String {
    case sepia = "CISepiaTone"
    case mono = "CIPhotoEffectMono"
}

extension UIImage {
    /// Adds filter image from the selected filter.
    /// - Parameter filter: Filter comes from the FilterType enum
    /// - Returns: Returns UIImage that has been processed with a new filter.
    func addFilterToImage(filter: FilterType) -> UIImage {
        let filter = CIFilter(name: filter.rawValue)
        
        // Convert UIImage to CIImage
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
        
        // Get output CIImage, render as CGImage to retain proper UIImage scale
        let ciOutput = filter?.outputImage
        
        // Be nice to move this out and make it viable to a lot more functions because it takes a lot of resources.
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        
        // Return image
        return UIImage(cgImage: cgImage!, scale: self.scale, orientation: self.imageOrientation)
    }
}

