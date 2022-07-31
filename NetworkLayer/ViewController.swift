//
//  ViewController.swift
//  NetworkLayer
//
//  Created by Ali Jaber on 31/07/2022.
//

import UIKit

class ViewController: UIViewController {
    var networkManager =  HTTPClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func fireAPI() {
        Task {
            let loginResult = await networkManager.loginAPIExample()
            switch loginResult {
            case .success(let data):
                print(data)
                //DO whatever u want here
            case .failure(let error):
                print(error.customMessage)
                //Display error message
            }
        }
    }


}

