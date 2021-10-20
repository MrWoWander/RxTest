//
//  RepoInfoViewController.swift
//  RxTest
//
//  Created by Mikhail Ivanov on 20.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

class RepoInfoViewController: UIViewController {
    
    var repoInfo: RepoInfo!
    
    var nameLabel: UILabel! {
        didSet {
            nameLabel.text = repoInfo.nameRepo
            nameLabel.textAlignment = .center
            nameLabel.font = .preferredFont(forTextStyle: .largeTitle)
            
            nameLabelLayout()
        }
    }
    var authorLabel: UILabel! {
        didSet {
            authorLabel.text = repoInfo.authorRepo
            authorLabel.textAlignment = .center
            authorLabel.textColor = .systemGray
            authorLabel.font = .preferredFont(forTextStyle: .callout)
        }
    }
    
    var authorImage: WebImageView!
    
    var authorStack: UIStackView! {
        didSet {
            authorStack.axis = .horizontal
            authorStack.alignment = .center
            authorStack.spacing = 5
            authorStack.distribution = .fill
            
            authorStackLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        nameLabel = UILabel()
        authorLabel = UILabel()
        authorImage = WebImageView()
        
        authorStack = UIStackView()
        
        authorStack.addArrangedSubview(authorImage)
        authorStack.addArrangedSubview(authorLabel)
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.heightAnchor.constraint(equalToConstant: 35).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        authorStack.insertArrangedSubview(activityIndicator, at: 0)
        
        authorImage.set(imageURL: repoInfo.autorImage) {[weak self] in
            activityIndicator.stopAnimating()
            self?.authorImageViewLayout()
            self?.authorStack.removeArrangedSubview(activityIndicator)
        }
        
        activityIndicator.startAnimating()
    }
    
    func set(repoInfo: RepoInfo) {
        self.repoInfo = repoInfo
        
    }
    
}

// MARK: View contraint`s
extension RepoInfoViewController {
    
    private func nameLabelLayout() {
        self.view.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    }
    
    private func authorStackLayout() {
        self.view.addSubview(authorStack)
        
        authorStack.translatesAutoresizingMaskIntoConstraints = false
        
        authorStack.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 2).isActive = true
        authorStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func authorImageViewLayout() {
        authorImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
        authorImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
}
