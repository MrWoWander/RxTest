//
//  MainViewController.swift.swift
//  RxTest
//
//  Created by Mikhail Ivanov on 19.10.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class GitHubRepoViewController: UITableViewController {
    
    private var observable: GitHubObservable!
    
    private let search = UISearchController()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Main Screen"
        
        tableView.tableHeaderView = search.searchBar
        tableView.register(UINib(nibName: "GitHubTableViewCell", bundle: nil),
                           forCellReuseIdentifier: GitHubTableViewCell.idCell)
        
        tableView.dataSource = nil
        
        setTableViewRx()
    }
    
    private func setTableViewRx() {
        let searchObservable = search.searchBar.rx
            .text.orEmpty
            .asObservable()
        
        self.observable = GitHubObservable(searchResult: searchObservable)
        
        observable.searchResult?
            .drive(tableView.rx.items(cellIdentifier: GitHubTableViewCell.idCell,
                                      cellType: GitHubTableViewCell.self)) { _, repo, cell in
                
                cell.nameLabel.text = repo.nameRepo
                cell.authorRepoLabel.text = repo.authorRepo
                
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe {
            print($0)
        }.disposed(by: disposeBag)
        
        tableView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
    }
}

extension GitHubRepoViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
