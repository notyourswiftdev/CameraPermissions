//
//  ViewController.swift
//  CameraPermissions
//
//  Created by Aaron Cleveland on 4/7/21.
//

import UIKit

class ViewController: UIViewController {
    
    let chooseImageViewHeight: CGFloat = 80
    
    let chooseImageTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose an Image"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    let chooseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.blue.cgColor
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(chooseImageTitle)
        NSLayoutConstraint.activate([
            chooseImageTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            chooseImageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(chooseImageView)
        NSLayoutConstraint.activate([
            chooseImageView.centerYAnchor.constraint(equalTo: chooseImageTitle.centerYAnchor),
            chooseImageView.centerXAnchor.constraint(equalTo: chooseImageTitle.centerXAnchor),
            chooseImageView.heightAnchor.constraint(equalToConstant: chooseImageViewHeight),
            chooseImageView.widthAnchor.constraint(equalToConstant: chooseImageViewHeight)
        ])
    }


}

