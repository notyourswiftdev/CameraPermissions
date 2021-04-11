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
    let imagePicker = ImagePickerController()
    
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
    
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var pictureSelectionTapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImageAlertAction))
    lazy var filterImageSelectionTapGesture = UITapGestureRecognizer(target: self, action: #selector(filterImageAlertAction))
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Filter Image", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.isHidden = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        configureUI()
        checkCameraAuthorization()
        
        imagePicker.delegate = self
    }
    
    // MARK: - Helper Functions -
    func configureUI() {
        constraints()
        thumbnailImageView.addGestureRecognizer(pictureSelectionTapGesture)
        mainImageView.addGestureRecognizer(filterImageSelectionTapGesture)
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
    
    func presentCamera() {
        if !(ImagePickerController.isSourceTypeAvailable(.camera)) {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func presentGallery() {
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
    @objc func chooseImageAlertAction() {
        checkCameraAuthorization()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        if mainImageView.image != nil {
            alert.addAction(UIAlertAction(title: "Choose Filter", style: .default, handler: { (_) in
                print("Open FilterViewController with Image")
            }))
        }
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (_) in
            self.presentCamera()
        }))
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { (_) in
            self.presentGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func filterImageAlertAction() {
        if mainImageView.image != nil {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Choose Filter", style: .default, handler: { (_) in
                print("Open FilterViewController with Image")
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func filterButtonAction() {
        print("Open FilterViewController with Image")
    }
}

extension ViewController {
    func constraints() {
        view.addSubview(thumbnailImageView)
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: standardPadding),
            thumbnailImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: standardPadding),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: thumbnailSize),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: thumbnailSize)
        ])
        
        view.addSubview(chooseImageLabel)
        NSLayoutConstraint.activate([
            chooseImageLabel.centerXAnchor.constraint(equalTo: thumbnailImageView.centerXAnchor),
            chooseImageLabel.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor)
        ])
        
        view.addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 20),
            mainImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainImageView.heightAnchor.constraint(equalToConstant: mainImageSize)
        ])
        
        view.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: standardPadding),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardPadding),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardPadding)
        ])
    }
}

extension ViewController: ImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photo = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        thumbnailImageView.image = photo
        mainImageView.image = photo
        
        chooseImageLabel.isHidden = true
        filterButton.isHidden = false
        dismiss(animated: true, completion: nil)
    }
}

