//
//  CustomImagePicker.swift
//  CameraPermissions
//
//  Created by Aaron Cleveland on 4/11/21.
//

import Foundation
import UIKit

protocol PickerControllerDelegate: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentCamera()
    func presentGallery()
}

class CustomImagePicker: UIImagePickerController {
    
    weak var pickerDelegate: PickerControllerDelegate?
    
    func pickerController(_ sourceType: UIImagePickerController.SourceType) {
        self.sourceType = sourceType
        allowsEditing = false
        self.delegate = pickerDelegate
        
        switch sourceType {
        case .camera:
            pickerDelegate?.presentCamera()
        case .photoLibrary:
            pickerDelegate?.presentGallery()
        default:
            break
        }
    }
}
