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
    
    // MARK: Property
    private var repoInfo: RepoInfo!
    
    private let dispose = DisposeBag()
    
    private lazy var observable = RepInfoObservable(repoInfo)
    
    private var lastPath: String = ""
    
    // MARK: UI property
    private var nameLabel: UILabel! {
        didSet {
            nameLabel.text = repoInfo.nameRepo
            nameLabel.textAlignment = .center
            nameLabel.font = .preferredFont(forTextStyle: .largeTitle)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(nameLabel)
        }
    }
    
    private var authorLabel: UILabel! {
        didSet {
            authorLabel.text = repoInfo.authorRepo
            authorLabel.textAlignment = .center
            authorLabel.textColor = .systemGray
            authorLabel.font = .preferredFont(forTextStyle: .callout)
        }
    }
    
    private var authorImage: WebImageView!
    
    private var authorStack: UIStackView! {
        didSet {
            authorStack.axis = .horizontal
            authorStack.alignment = .center
            authorStack.spacing = 5
            authorStack.distribution = .fill
            authorStack.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(authorStack)
        }
    }
    
    private var contentStack: UIStackView! {
        didSet {
            contentStack.axis = .horizontal
            contentStack.alignment = .top
            contentStack.spacing = 20
            contentStack.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(contentStack)
        }
    }
    
    private var contentScrollView: UIScrollView! {
        didSet {
            contentScrollView.showsHorizontalScrollIndicator = false
            contentScrollView.translatesAutoresizingMaskIntoConstraints = false
            
            contentStack.addArrangedSubview(contentScrollView)
        }
    }
    
    private var contentStackScrollView: UIStackView! {
        didSet {
            contentStackScrollView.axis = .vertical
            contentStackScrollView.spacing = 10
            contentStackScrollView.translatesAutoresizingMaskIntoConstraints = false
            
            contentScrollView.addSubview(contentStackScrollView)
        }
    }
    
    // MARK: UI constraint property
    private var scrollViewPortraitOrientation: [NSLayoutConstraint]!
    private var scrollViewLandscapeOrientation: [NSLayoutConstraint]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        setTopBar()
        setContentStack()
        
        // Set constraint
        nameLabelLayout()
        authorStackLayout()
        
        contentStackLayout()
        contentScrollViewLayout()
        contentVerticalStackScrollViewLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let orientation = self.windowInterfaceOrientation else {return}
        
        coordinator.animate {[weak self] _ in
            
            guard let self = self else { return }
            
            if orientation.isLandscape {
                NSLayoutConstraint.deactivate(self.scrollViewLandscapeOrientation)
                NSLayoutConstraint.activate(self.scrollViewPortraitOrientation)
            } else {
                NSLayoutConstraint.deactivate(self.scrollViewPortraitOrientation)
                NSLayoutConstraint.activate(self.scrollViewLandscapeOrientation)
            }
        }
    }
    
    /// Transferring data from another controller
    func setup(repoInfo: RepoInfo) {
        self.repoInfo = repoInfo
    }
}

// MARK: Customizing UI elements
extension RepoInfoViewController {
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
        
        getContent()
    }
    
    /// Getting the contents of the repository
    func getContent(path: String = "") {
        
        if !contentStackScrollView.arrangedSubviews.isEmpty {
            contentStackScrollView.removeAllArrangedSubviews()
        }
        
        observable.getContent(path: path).subscribe(onSuccess: {[weak self] repContent in
            
            guard let self = self else {return}
            
            let dirContent: [RepContent] = repContent.filter { $0.type == .directory}
            let fileContent: [RepContent] = repContent.filter { $0.type == .file}
            
            dirContent.forEach { dirRepo in
                let button = UIButton()
                
                button.setTitle(dirRepo.name, for: .normal)
                button.contentHorizontalAlignment = .left
                button.titleLabel?.numberOfLines = 2
                button.setTitleColor(.systemBlue, for: .normal)
                
                button.rx.tap.subscribe(onNext:  {
                    self.getContent(path: dirRepo.path)
                }).disposed(by: self.dispose)
                
                self.contentStackScrollView.addArrangedSubview(button)
                
                if let font = button.titleLabel?.font {
                    let height = dirRepo.name.height(width: self.contentStackScrollView.frame.width, font:font)
                    
                    button.heightAnchor.constraint(equalToConstant: height).isActive = true
                }
            }
            
            fileContent.forEach {
                let contentLabel = UILabel()
                contentLabel.text = $0.name
                contentLabel.numberOfLines = 2
                
                self.contentStackScrollView.addArrangedSubview(contentLabel)
            }
            
        }).disposed(by: dispose)
    }
}

// MARK: View contraint`s
extension RepoInfoViewController {
    
    /// Getting device orientation
    private var windowInterfaceOrientation: UIInterfaceOrientation? {
        let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        return scene?.window?.windowScene?.interfaceOrientation
    }
    
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
        
        scrollViewPortraitOrientation = [
            contentScrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.7)
        ]
        
        scrollViewLandscapeOrientation = [
            contentScrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6)
        ]
        
        guard let orientation = self.windowInterfaceOrientation else {return}
        
        if orientation.isPortrait {
            NSLayoutConstraint.activate(self.scrollViewPortraitOrientation)
        } else {
            NSLayoutConstraint.activate(self.scrollViewLandscapeOrientation)
        }
    }
    
    private func contentVerticalStackScrollViewLayout() {
        contentStackScrollView.topAnchor.constraint(equalTo: contentScrollView.topAnchor).isActive = true
        contentStackScrollView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor).isActive = true
        contentStackScrollView.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor).isActive = true
        contentStackScrollView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor).isActive = true
    }
}
