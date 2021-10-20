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

class MainViewController: UITableViewController {
    
    private var observable: MainObservable!
    
    private let search = UISearchController()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Main Screen"
        
        tableView.tableHeaderView = search.searchBar
        tableView.register(UINib(nibName: "GitHubTableViewCell", bundle: nil), forCellReuseIdentifier: GitHubTableViewCell.idCell)
        
        tableView.dataSource = nil
        
        setTableViewRx()
    }
    
    private func setTableViewRx() {
        let searchObservable = search.searchBar.rx
            .text.orEmpty
            .asObservable()
        
        self.observable = MainObservable(searchResult: searchObservable)
        
        observable.searchResult?
            .drive(tableView.rx.items) { tableView, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                
                let cell = tableView.dequeueReusableCell(withIdentifier: GitHubTableViewCell.idCell, for: indexPath) as! GitHubTableViewCell
                print("1")
                cell.nameLabel.text = element.nameRepo
                cell.authorRepoLabel.text = element.authorRepo
                
                return cell
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe {
            print($0)
        }.disposed(by: disposeBag)
        
        tableView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
    }
}

extension MainViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
