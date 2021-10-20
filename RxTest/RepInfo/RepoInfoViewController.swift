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
    
    let dispose = DisposeBag()
    
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
        
        self.view.backgroundColor = .systemBackground
        
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
        
        contentStack()
    }
    
    func set(repoInfo: RepoInfo) {
        self.repoInfo = repoInfo
    }
    
    
    func contentStack() {
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .top
        stack.spacing = 20
        self.view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.topAnchor.constraint(equalTo: self.authorStack.bottomAnchor, constant: 50).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        stack.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor).isActive = true
        
        let contentLabel = UILabel()
        contentLabel.text = "Content:"
        contentLabel.textAlignment = .right
        contentLabel.font = .preferredFont(forTextStyle: .title3)
        
        contentLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3).isActive = true
        
        stack.addArrangedSubview(contentLabel)

        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        
        stack.addArrangedSubview(scroll)

        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
//        verticalStack.spacing = 10

        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        scroll.addSubview(verticalStack)
        
        verticalStack.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        verticalStack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor).isActive = true
        verticalStack.trailingAnchor.constraint(equalTo: scroll.trailingAnchor).isActive = true
        verticalStack.bottomAnchor.constraint(equalTo: scroll.bottomAnchor).isActive = true
//        verticalStack.widthAnchor.constraint(equalTo: scroll.widthAnchor).isActive = true

        for i in 1...100 {
            let contentLabel = UILabel()
            contentLabel.text = String(i)

            verticalStack.addArrangedSubview(contentLabel)
        }
        

//        let observable = RepInfoObservable(repoInfo)
//
//        observable.getContent().subscribe(onSuccess: { repContnets in
//            repContnets.forEach {
//                let contentLabel = UILabel()
//                contentLabel.text = String($0.name)
//
//                verticalStack.addArrangedSubview(contentLabel)
//
//            }
//
//        }).disposed(by: dispose)
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
