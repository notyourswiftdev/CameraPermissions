//
//  ViewController.swift
//  CameraPermissions
//
//  Created by Aaron Cleveland on 4/7/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let chooseImageViewHeight: CGFloat = 80
    
    let imagePicker = UIImagePickerController()
    let chooseImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose an Image"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var  chooseImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.blue.cgColor
        
        let tapGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(chooseImageAction))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        delegates()
    }
    
    // MARK: - Helper Functions -
    func delegates() {
        imagePicker.delegate = self
    }
    
    func imagePickerSelection() {
        imagePicker.isEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Actions -
    @objc func chooseImageAction() {
        imagePickerSelection()
    }
}

extension ViewController {
    func configureUI() {
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

