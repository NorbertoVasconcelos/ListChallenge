//
//  FollowerCollectionViewCell.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 03/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import UIKit
import Kingfisher

class FollowerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgUser: UIImageView! {
        didSet {
            imgUser.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bindViewModel(_ viewModel: FollowerItemViewModel) {
        if let profilePicURL = URL(string: viewModel.user.profilePicture ?? "https://www.ischool.berkeley.edu/sites/default/files/default_images/avatar.jpeg") {
            self.imgUser.kf.setImage(with: profilePicURL)
        }
        self.lblName.text = "\(viewModel.user.firstName) \(viewModel.user.lastName)"
        self.lblRole.text = viewModel.user.primaryPosition?.name.uppercased()
    }
}
