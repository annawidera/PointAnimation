//
//  ViewController.swift
//  PointAnimation
//
//  Created by Ania Widera on 03.11.2016.
//  Copyright © 2016 Ania Widera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTapped(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

