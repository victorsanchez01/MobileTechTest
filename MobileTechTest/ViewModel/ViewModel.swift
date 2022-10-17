//
//  ViewModel.swift
//  Zemoga
//
//  Created by victor.sanchez on 6/10/22.
//

import RxCocoa
import RxSwift
import UIKit

class ViewModel {
    
    var comments = BehaviorSubject(value: [Comment]())
   
    func fetchComments(commentId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(commentId)")
        let task = URLSession.shared.dataTask(with: url!) { (data,response,error) in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            do {
                let responseData = try JSONDecoder().decode([Comment].self, from: data)
                self.comments.on(.next(responseData))
                completion(.success(true))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
