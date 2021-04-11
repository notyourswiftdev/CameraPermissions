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
    
    let thumbnailSize: CGFloat = 80
    let mainImageSize: CGFloat = 200
    let standardPadding: CGFloat = 20
    
    lazy var chooseImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose \nImage"
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var chooseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var pictureSelectionTapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImageAction))
    
    lazy var largerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
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
            imagePicker.allowsEditing = false
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
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
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
        view.addSubview(chooseImageView)
        NSLayoutConstraint.activate([
            chooseImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: standardPadding),
            chooseImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: standardPadding),
            chooseImageView.heightAnchor.constraint(equalToConstant: thumbnailSize),
            chooseImageView.widthAnchor.constraint(equalToConstant: thumbnailSize)
        ])
        
        view.addSubview(chooseImageLabel)
        NSLayoutConstraint.activate([
            chooseImageLabel.centerXAnchor.constraint(equalTo: chooseImageView.centerXAnchor),
            chooseImageLabel.centerYAnchor.constraint(equalTo: chooseImageView.centerYAnchor)
        ])
        
        view.addSubview(largerImageView)
        NSLayoutConstraint.activate([
            largerImageView.topAnchor.constraint(equalTo: chooseImageView.bottomAnchor, constant: 20),
            largerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            largerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            largerImageView.heightAnchor.constraint(equalToConstant: mainImageSize)
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

