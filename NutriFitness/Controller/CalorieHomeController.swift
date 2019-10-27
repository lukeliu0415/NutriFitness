//
//  CalorieHomeController.swift
//  NutriFitness
//
//  Created by Alan Yan on 2019-10-26.
//  Copyright © 2019 Luke Liu. All rights reserved.
//

import UIKit

class CalorieHomeController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.title = "Nutrition"
        self.performSegue(withIdentifier: "toOnboard", sender: self)
    }
}
