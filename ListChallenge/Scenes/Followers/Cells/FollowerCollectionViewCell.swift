//
//  FollowerCollectionViewCell.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 03/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import UIKit

class FollowerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindViewModel(_ viewModel: FollowerItemViewModel) {
        self.lblName.text = "\(viewModel.user.firstName) \(viewModel.user.lastName)"
    }
}
