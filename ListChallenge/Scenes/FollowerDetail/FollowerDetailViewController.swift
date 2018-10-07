//
//  FollowerDetailViewController.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 03/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import UIKit

class FollowerDetailViewController: UIViewController {

    @IBOutlet weak var imgUser: UIImageView! {
        didSet {
            imgUser.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var imgVerified: UIImageView!
    @IBOutlet weak var lblClub: UILabel!
    @IBOutlet weak var imgClub: UIImageView! {
        didSet {
            imgClub.layer.cornerRadius = 8
        }
    }
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let u = user {
            bind(u)
        }
    }
    
    func bind(_ user: User) {
        lblName.text = "\(user.firstName) \(user.lastName)"
        lblRole.text = user.primaryPosition?.name.uppercased()
        lblGender.text = user.gender?.uppercased()
        lblClub.text = user.club?.name
        if let logo = URL(string: user.club?.logoURL ?? "") {
            imgClub.kf.setImage(with: logo)
        }
        imgVerified.image = user.isVerified ? UIImage(named: "ic_verified") : UIImage(named: "ic_cross")
    }
    
    @IBAction func btnDismissPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
