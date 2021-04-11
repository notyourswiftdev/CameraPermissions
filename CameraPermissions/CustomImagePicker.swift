//
//  CustomImagePicker.swift
//  CameraPermissions
//
//  Created by Aaron Cleveland on 4/11/21.
//

import Foundation
import UIKit

protocol PickerControllerDelegate: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentGallery()
    func presentCamera()
}

class CustomImagePicker: UIImagePickerController {
    
    weak var pickerDelegate: PickerControllerDelegate?
    
    func openGallery() {
        self.sourceType = .photoLibrary
        self.allowsEditing = false
        pickerDelegate?.presentGallery()
        self.delegate = pickerDelegate
    }
    
    func openCamera() {
        self.sourceType = .camera
        self.allowsEditing = false
        pickerDelegate?.presentCamera()
        self.delegate = pickerDelegate
    }
}
