//
//  ViewController.swift
//  ConcatenatingSignalProducers
//
//  Created by Alex on 05/12/16.
//  Copyright © 2016 Jarroo. All rights reserved.
//

import UIKit
import ReactiveSwift

extension SignalProducer {
    
    static func flatten(_ strategy: FlattenStrategy, producers:[SignalProducer<Value,Error>]) -> SignalProducer<Value,Error> {
        let p = SignalProducer<SignalProducer<Value,Error>,Error>(values: producers)
        return p.flatten(strategy)
    }
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
        let getAvatars = [
            client.getAvatar(url: "http://www.trump.net/sticker1.png"),
            client.getAvatar(url: "http://www.trump.net/sticker2.png"),
            client.getAvatar(url: "http://www.trump.net/sticker3.png"),
            client.getAvatar(url: "http://www.trump.net/sticker4.png"),
            client.getAvatar(url: "http://www.trump.net/sticker5.png"),
        ]
        
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
