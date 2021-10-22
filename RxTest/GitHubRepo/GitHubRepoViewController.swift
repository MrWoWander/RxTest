//
//  MainViewController.swift.swift
//  RxTest
//
//  Created by Mikhail Ivanov on 19.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

class GitHubRepoViewController: UITableViewController {
    
    private var observable: GitHubObservable!
    
    private let search = UISearchController()
    private let disposeBag = DisposeBag()
    
    private var repoInfo: [RepoInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "GitHub repository"
        
        let searchObservable = search.searchBar.rx
            .text.orEmpty
            .asObservable()
        
        self.observable = GitHubObservable(searchResult: searchObservable)
        
        tableView.tableHeaderView = search.searchBar
        tableView.register(UINib(nibName: "GitHubTableViewCell", bundle: nil),
                           forCellReuseIdentifier: GitHubTableViewCell.idCell)
        
        tableView.dataSource = nil
        
        setTableViewRx()
        
        // MARK: Warning alert
        
        let alert =  UIAlertController(title: "‼️ ВНИМАНИЕ ‼️",
                                       message: "Данный репозиторий работает с API GitHub без токена пользователя. Из-за этого нельзя делать много запросов сразу. Старайтесь не спешить 😃",
                                       preferredStyle: .alert)
         
         let alertOk = UIAlertAction(title: "ОК", style: .default)
        
         alert.addAction(alertOk)
         
         present(alert, animated: true, completion: nil)
    }
    
    private func setTableViewRx() {
        
        observable.searchResult?.do(onNext: { [weak self] repoInfo in
            self?.repoInfo = repoInfo
        })
            .drive(tableView.rx.items(cellIdentifier: GitHubTableViewCell.idCell,
                                      cellType: GitHubTableViewCell.self)) { _, repo, cell in
                
                cell.nameLabel.text = repo.nameRepo
                cell.authorRepoLabel.text = repo.authorRepo
                
            }.disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected.map{ [weak self] indexPath in
            self?.repoInfo?[indexPath.row]
            
        }.subscribe {[weak self] repo in
            
            guard let repoElement = repo.element,
            let repo = repoElement else {return}
            
            self?.search.dismiss(animated: true, completion: nil)
            
            let repoInfoVC = RepoInfoViewController()
            repoInfoVC.setup(repoInfo: repo)
            
            self?.navigationController?.pushViewController(repoInfoVC, animated: true)
        }.disposed(by: disposeBag)
    }
}

extension GitHubRepoViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
