//
//  PreviewViewController.swift
//  NutriFitness
//
//  Created by Luke Liu on 2019-10-26.
//  Copyright © 2019 Luke Liu. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
    }
    
    @IBAction func saveButton(_ sender: Any) {
    }
    

}
