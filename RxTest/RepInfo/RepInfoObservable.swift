//
//  RepInfoObservable.swift
//  RxTest
//
//  Created by Mikhail Ivanov on 20.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

class RepInfoObservable {
    
    private let repositoryInfo: RepoInfo

    
    init(_ rep: RepoInfo) {
        self.repositoryInfo = rep
    }
    
    public func getContent(path: String) -> Single<[RepContent]> {
        Single<[RepContent]>.create { single in
            
            guard let url = URL(string: "https://api.github.com/repos/\(self.repositoryInfo.authorRepo)/\(self.repositoryInfo.nameRepo)/contents/\(path)")
            else {
                single(.failure(GitHubError.notValideURL))
                return Disposables.create { }
            }
            
            
            var request = URLRequest(url: url)
            request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    single(.failure(error))
                    return
                }
                
                guard let data = data else {
                    single(.failure(GitHubError.notData))
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                guard let model = try? decoder.decode([RepContent].self, from: data) else {
                    single(.failure(GitHubError.parseDataError))
                    return
                }
                single(.success(model))
                
            }
            
            task.resume()
            return Disposables.create { task.cancel() }
        }.observe(on: MainScheduler.instance)
    }
}
