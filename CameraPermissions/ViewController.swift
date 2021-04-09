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
    var imageSelection = UIImage()
    let photoPicker = UIImagePickerController()
    
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
    }
    
    // MARK: - Helper Functions -
    func configureUI() {
        constraints()
        // adds gesture to imageview
        chooseImageView.addGestureRecognizer(pictureSelectionTapGesture)
    }
    
    func checkCameraAuthorization() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .notDetermined:
            requestCameraPermission()
        case .authorized:
            presentCamera()
        case .denied, .restricted:
            alertCameraAccessNeeded()
        }
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (cameraGranted) in
            guard cameraGranted == true else { return }
            self.presentCamera()
        }
    }
    
    func presentCamera() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.photoPicker.sourceType = .photoLibrary
            self.photoPicker.allowsEditing = false
            self.photoPicker.delegate = self
            self.present(self.photoPicker, animated: true, completion: nil)
        }
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
        if photoPicker.sourceType == .photoLibrary {
            checkCameraAuthorization()
        } else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Oops!", message: "Couldn't access a camera at this time. Can you check that your device has a camera?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
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

