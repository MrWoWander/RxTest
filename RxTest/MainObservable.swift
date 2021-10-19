//
//  MainObservable.swift
//  RxTest
//
//  Created by Mikhail Ivanov on 19.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

class MainObservable {
    
    var searchResult: Driver<[GitHubItemModel]>?
    
    init(searchResult: Observable<String>) {
        self.searchResult = self.getSearch(searchResult: searchResult)
    }
    
    private func getSearch(searchResult: Observable<String>) -> Driver<[GitHubItemModel]> {
        searchResult
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: "")
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .flatMapLatest {[unowned self] text in
                self.gitHubSearch(search: text).asDriver(onErrorJustReturn: [GitHubItemModel(name: "Что-то не так")])
            }
    }
    
    private func gitHubSearch(search: String) -> Single<[GitHubItemModel]> {
        
        return Single<[GitHubItemModel]>.create { single in
            
            guard let url = URL(string: "https://api.github.com/search/repositories?q=\(search)")
            else {
                single(.failure(GitHubError.notValideURL))
                return Disposables.create { }
            }
            
            var request = URLRequest(url: url)
            request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let data = data else {
                    single(.failure(GitHubError.notData))
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                guard let model = try? decoder.decode(GitHubModel.self, from: data) else {
                    single(.failure(GitHubError.parseDataError))
                    return
                }
                
                single(.success(model.items))
                
            }
            
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}

enum GitHubError: Error {
    case notValideURL
    case notData
    case parseDataError
}
