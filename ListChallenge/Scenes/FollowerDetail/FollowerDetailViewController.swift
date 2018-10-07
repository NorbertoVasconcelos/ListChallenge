//
//  FollowerDetailViewController.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 03/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FollowerDetailViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var btnClose: UIButton!
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
    
    private let disposeBag = DisposeBag()
    var viewModel: FollowerDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        container.isHidden = false
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        
        let viewDidLoad = Driver.just(())
        let close = btnClose.rx.tap.asDriver()
        
        let input = FollowerDetailViewModel.Input(trigger: viewDidLoad, close: close)
        let output = viewModel.transform(input: input)
        
        output.follower.map { self.bind($0) }
        .drive()
        .disposed(by: disposeBag)
        
        output.close.drive().disposed(by: disposeBag)
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
}
