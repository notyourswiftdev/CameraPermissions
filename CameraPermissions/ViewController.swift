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
    let imagePicker = UIImagePickerController()
    
    let chooseImageViewHeight: CGFloat = 200
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    // MARK: - Helper Functions -
    func imagePickerSelection() {
        imagePicker.delegate = self
        imagePicker.isEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func configureUI() {
        constraints()
        // adds gesture to imageview
        chooseImageView.addGestureRecognizer(pictureSelectionTapGesture)
    }
    
    // MARK: - Actions -
    @objc func chooseImageAction() {
        imagePickerSelection()
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
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {}

