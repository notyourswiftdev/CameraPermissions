//
//  ViewController.swift
//  CameraPermissions
//
//  Created by Aaron Cleveland on 4/7/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: - Properties -
    let imagePicker = UIImagePickerController()
    
    let chooseImageViewHeight: CGFloat = 100
    
    lazy var chooseImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose an Image"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var chooseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.blue.cgColor
        return imageView
    }()
    
    lazy var pictureSelectionTapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImageAction))
    
    lazy var largerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.blue.cgColor
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        checkCameraAuthorization()
    }
    
    // MARK: - Helper Functions -
    func configureUI() {
        constraints()
        chooseImageView.addGestureRecognizer(pictureSelectionTapGesture)
    }
    
    func checkCameraAuthorization() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .notDetermined:
            requestCameraPermission()
        case .authorized:
            return
        case .denied, .restricted:
            alertCameraAccessNeeded()
        @unknown default:
            fatalError()
        }
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (cameraGranted) in
            guard cameraGranted == true else { return }
        }
    }
    
    func openCamera() {
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        let alert = UIAlertController(title: "Need Camera Access", message: "Camera access is required to make full use of this app.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions -
    @objc func chooseImageAction() {
        checkCameraAuthorization()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController {
    func constraints() {
        view.addSubview(chooseImageLabel)
        NSLayoutConstraint.activate([
            chooseImageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            chooseImageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(chooseImageView)
        NSLayoutConstraint.activate([
            chooseImageView.centerYAnchor.constraint(equalTo: chooseImageLabel.centerYAnchor),
            chooseImageView.centerXAnchor.constraint(equalTo: chooseImageLabel.centerXAnchor),
            chooseImageView.heightAnchor.constraint(equalToConstant: chooseImageViewHeight),
            chooseImageView.widthAnchor.constraint(equalToConstant: chooseImageViewHeight)
        ])
        
        view.addSubview(largerImageView)
        NSLayoutConstraint.activate([
            largerImageView.topAnchor.constraint(equalTo: chooseImageView.bottomAnchor, constant: 10),
            largerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            largerImageView.heightAnchor.constraint(equalToConstant: 150),
            largerImageView.widthAnchor.constraint(equalToConstant: 150),
        ])
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photo = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        chooseImageView.image = photo
        largerImageView.image = photo
        dismiss(animated: true, completion: nil)
    }
}

