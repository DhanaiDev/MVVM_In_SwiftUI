//
//  ViewController.swift
//  MVVM
//
//  Created by dhanasekaran on 29/09/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        APIService.shared.fetchPublicApiList { list, error in
            print(list)
            print(error)
        }
    }


}

