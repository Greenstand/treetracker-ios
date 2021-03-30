//
//  ProfileViewController.swift
//  TreeTracker
//
//  Created by Remi Varghese on 3/23/21.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    //MARK: - IBoutlets
    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailphoneLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBAction func changeuserButton(_ sender: UIButton) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
