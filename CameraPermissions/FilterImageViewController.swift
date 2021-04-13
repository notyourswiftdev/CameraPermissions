//
//  FilterImageViewController.swift
//  CameraPermissions
//
//  Created by Aaron Cleveland on 4/11/21.
//

import UIKit

class FilterImageViewController: UIViewController {
    
    let standardPadding: CGFloat = 20
    
    let filterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let sepiaButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sepia", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addSepiaFilter), for: .touchUpInside)
        return button
    }()
    
    let monoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Mono", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addMonoFilter), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    @objc func addSepiaFilter() {
        filterImageView.image = filterImageView.image?.addFilterToImage(filter: .sepia)
    }
    
    @objc func addMonoFilter() {
        filterImageView.image = filterImageView.image?.addFilterToImage(filter: .mono)
    }

}

extension FilterImageViewController {
    private func configureUI() {
        view.addSubview(filterImageView)
        NSLayoutConstraint.activate([
            filterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: standardPadding),
            filterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardPadding),
            filterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardPadding),
            filterImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2)
        ])
        
        view.addSubview(sepiaButton)
        NSLayoutConstraint.activate([
            sepiaButton.topAnchor.constraint(equalTo: filterImageView.bottomAnchor, constant: standardPadding),
            sepiaButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardPadding),
            sepiaButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardPadding),
            sepiaButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        view.addSubview(monoButton)
        NSLayoutConstraint.activate([
            monoButton.topAnchor.constraint(equalTo: sepiaButton.bottomAnchor, constant: standardPadding),
            monoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardPadding),
            monoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardPadding),
            monoButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
