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
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(nameLabel)
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
            authorStack.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(authorStack)
        }
    }
    
    var contentStack: UIStackView! {
        didSet {
            contentStack.axis = .horizontal
            contentStack.alignment = .top
            contentStack.spacing = 20
            contentStack.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(contentStack)
        }
    }
    
    var contentScrollView: UIScrollView! {
        didSet {
            contentScrollView.showsHorizontalScrollIndicator = false
            contentScrollView.translatesAutoresizingMaskIntoConstraints = false
            
            contentStack.addArrangedSubview(contentScrollView)
        }
    }
    
    var contentStackScrollView: UIStackView! {
        didSet {
            contentStackScrollView.axis = .vertical
            contentStackScrollView.spacing = 10
            
            contentStackScrollView.translatesAutoresizingMaskIntoConstraints = false
            
            contentScrollView.addSubview(contentStackScrollView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        nameLabelLayout()
        authorStackLayout()
        
        contentStackLayout()
        contentScrollViewLayout()
        contentVerticalStackScrollViewLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        setTopBar()
        setContentStack()
    }
    
    func set(repoInfo: RepoInfo) {
        self.repoInfo = repoInfo
    }
    
    func setTopBar() {
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
    
    func setContentStack() {
        self.contentStack = UIStackView()
        
        let contentLabel = UILabel()
        contentLabel.text = "Content:"
        contentLabel.textAlignment = .right
        contentLabel.font = .preferredFont(forTextStyle: .title3)
        
        contentStack.addArrangedSubview(contentLabel)
        contentLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        
        contentScrollView = UIScrollView()
        contentStackScrollView = UIStackView()
        
        let observable = RepInfoObservable(repoInfo)
        
        observable.getContent().subscribe(onSuccess: {[weak self] repContent in
            repContent.forEach {
                let contentLabel = UILabel()
                contentLabel.text = String($0.name)
                contentLabel.numberOfLines = 2
                
                self?.contentStackScrollView.addArrangedSubview(contentLabel)
            }
            
        }).disposed(by: dispose)
    }
}

// MARK: View contraint`s
extension RepoInfoViewController {
    
    private func nameLabelLayout() {
        nameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    }
    
    private func authorStackLayout() {
        authorStack.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 2).isActive = true
        authorStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func authorImageViewLayout() {
        authorImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
        authorImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    private func contentStackLayout() {
        contentStack.topAnchor.constraint(equalTo: self.authorStack.bottomAnchor, constant: 50).isActive = true
        contentStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        contentStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    }
    
    private func contentScrollViewLayout() {
        contentScrollView.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor).isActive = true
        contentScrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
    }
    
    private func contentVerticalStackScrollViewLayout() {
        contentStackScrollView.topAnchor.constraint(equalTo: contentScrollView.topAnchor).isActive = true
        contentStackScrollView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor).isActive = true
        contentStackScrollView.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor).isActive = true
        contentStackScrollView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor).isActive = true
    }
}
