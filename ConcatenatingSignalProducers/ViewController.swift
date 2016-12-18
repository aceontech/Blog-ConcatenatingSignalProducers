//
//  ViewController.swift
//  ConcatenatingSignalProducers
//
//  Created by Alex on 05/12/16.
//  www.jarroo.com
//

import UIKit
import ReactiveSwift

extension SignalProducer {
    
    static func flatten(_ strategy: FlattenStrategy, producers:[SignalProducer<Value,Error>]) -> SignalProducer<Value,Error> {
        let p = SignalProducer<SignalProducer<Value,Error>,Error>(values: producers)
        return p.flatten(strategy)
    }
}

struct User {
    let name:String
    let avatarUrl:String
}

class APIClient {
    
    enum APIError : Error {
    }
    
    func getAvatar(url:String) -> SignalProducer<UIImage,APIError> {
        return SignalProducer(value: #imageLiteral(resourceName: "trumpsticker"))
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = APIClient()
        
        let users = [
            User(name: "User 1", avatarUrl: "http://www.trump.net/sticker1.png"),
            User(name: "User 2", avatarUrl: "http://www.trump.net/sticker2.png"),
            User(name: "User 3", avatarUrl: "http://www.trump.net/sticker3.png"),
            User(name: "User 4", avatarUrl: "http://www.trump.net/sticker4.png"),
            User(name: "User 5", avatarUrl: "http://www.trump.net/sticker5.png"),
        ]
        
        let getAvatars = users.map { client.getAvatar(url: $0.avatarUrl) }
        
        SignalProducer
            .flatten(.concat, producers: getAvatars)
            .startWithResult { result in
                switch result {
                case let .failure(error): print("An error occurred: \(error)")
                case let .success(image): print("Successfully fetched image: \(image)")
                }
            }
    }
}
