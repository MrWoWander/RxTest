//
//  MainViewController.swift.swift
//  RxTest
//
//  Created by Mikhail Ivanov on 19.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UITableViewController {
    
    private var observable: MainObservable!
    
    private let search = UISearchController()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Main Screen"
        
        tableView.tableHeaderView = search.searchBar
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.dataSource = nil
        
        setTableViewRx()
    }
    
    private func setTableViewRx() {
        let searchObservable = search.searchBar.rx
            .text.orEmpty
            .asObservable()
        
        self.observable = MainObservable(searchResult: searchObservable)
        
        observable.searchResult?
            .drive(tableView.rx.items(cellIdentifier: "cell",
                                      cellType: UITableViewCell.self))
        { _, repo, cell in
            
            cell.textLabel?.text = repo.name
            
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe {
            print($0)
        }.disposed(by: disposeBag)
    }
}

