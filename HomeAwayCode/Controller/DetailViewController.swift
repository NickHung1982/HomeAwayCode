//
//  DetailViewController.swift
//  HomeAwayCode
//
//  Created by Nick on 9/28/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    //navbar
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    //content
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var viewModel: DetailViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = viewModel.item.title
        self.locationLabel.text = viewModel.item.venue.display_location;
        self.dateLabel.text = Helper.transferDateString(viewModel.item.datetime_local)
        
        for li in viewModel.item.performers {
            if let imgLink = li.image {
                viewModel.getImage(withURL: URL(string: imgLink)!, completion: { img in
                    DispatchQueue.main.async {
                        self.thumbImageView.image = img
                    }
                })
                break
            }
        }
        
        checkFavStatus()
    }
    
    internal func checkFavStatus() {
        if (viewModel.isFav) {
            self.favButton.setImage(UIImage(named: "favoriteIconCheck"), for: .normal)
        }else{
            self.favButton.setImage(UIImage(named: "favoriteIcon"), for: .normal)
        }
    }

}
