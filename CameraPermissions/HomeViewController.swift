//
//  HomeViewController.swift
//  CameraPermissions
//
//  Created by Aaron Cleveland on 4/7/21.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - PROPERTIES -
    let imagePicker = ImagePickerController()
    let filterImageViewController = FilterImageViewController()
    
    var stockImagesArray = (0...30).compactMap { (UIImage(named: "pic\($0)"))}
    
    let thumbnailSize: CGFloat = 80
    let mainImageSize: CGFloat = 200
    let standardPadding: CGFloat = 20
    
    lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: thumbnailSize, height: thumbnailSize)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
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
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 10
        button.isHidden = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var chooseImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Camera or Photo Library", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(chooseImageButtonAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LIFECYCLES -
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // Remove navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // Adds navigation when view is disappeared
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - HELPER FUNCTIONS -
    func configureUI() {
        view.backgroundColor = UIColor(named: "Background")
        constraints()
        checkCameraAuthorization()
        delegates()
        configureLongPressGesture()
    }
    
    func delegates() {
        imagePicker.pickerDelegate = self
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
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
    
    // MARK: - PRESENTS CAMERA OR PHOTO LIBRARY OR EDIT IMAGE VIEW CONTROLLER -
    func presentCamera() {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func presentGallery() {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func presentFilterImageViewController() {
        filterImageViewController.filterImageView.image = mainImageView.image
        navigationController?.pushViewController(self.filterImageViewController, animated: true)
    }
    
    // MARK: - CAMERA PERMISSIONS HELPER FUNCTIONS -
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (cameraGranted) in
            guard cameraGranted == true else { return }
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
    
    // MARK: - UIGestures -
    private func configureLongPressGesture() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(photosCellLongPressGesture(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        photoCollectionView.addGestureRecognizer(longPressedGesture)
    }
    
    // MARK: - ACTIONS -
    @objc func chooseImageButtonAction() {
        checkCameraAuthorization()
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (_) in
            if !ImagePickerController.isSourceTypeAvailable(.camera) {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.imagePicker.pickerController(.camera)
            }
        }))
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { (_) in
            if !ImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let alert = UIAlertController(title: "Warning", message: "We can't access your photo library", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            } else {
                self.imagePicker.pickerController(.photoLibrary)
            }
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func filterButtonAction() {
        self.presentFilterImageViewController()
    }
    
    @objc func photosCellLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }
        
        let loc = gestureRecognizer.location(in: photoCollectionView)
        if let indexPath = photoCollectionView.indexPathForItem(at: loc) {
            mainImageView.image = stockImagesArray[indexPath.item]
        }
    }
}

// MARK: - EXTENSIONS -
extension HomeViewController {
    func constraints() {
        view.addSubview(photoCollectionView)
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: standardPadding),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        view.addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: standardPadding),
            mainImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardPadding),
            mainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardPadding),
            mainImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2)
        ])
        
        view.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: standardPadding),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardPadding),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardPadding)
        ])
        
        view.addSubview(chooseImageButton)
        NSLayoutConstraint.activate([
            chooseImageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardPadding),
            chooseImageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardPadding),
            chooseImageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -standardPadding)
        ])
    }
}

extension HomeViewController: ImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photo = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        mainImageView.image = photo
        filterButton.isHidden = false
        dismiss(animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stockImagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier, for: indexPath) as! PhotosCollectionViewCell
        let stockImage = stockImagesArray[indexPath.item]
        DispatchQueue.main.async {
            cell.thumbnailImageView.image = stockImage
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Replace with a guard let if we use network calls, right now we have the images in the assets folder.
        mainImageView.image = stockImagesArray[indexPath.item]
        filterButton.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Took away the leading and trailing constraint on the collectionview itself. added an edge inset here to give a better look to the view.
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}

