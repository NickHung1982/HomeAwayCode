//
//  DetailViewController+navbar.swift
//  HomeAwayCode
//
//  Created by Nick on 9/28/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import Foundation
import UIKit

//actions for navbar
extension DetailViewController {
    @IBAction func clickBackToMain(_ sender: Any) {
         _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickSaveFav(_ sender: Any) {
        if (self.viewModel.isFav) {
           self.viewModel.isFav = false
           _ = Helper.removeFavID(String(self.viewModel.item.id))
        }else{
            self.viewModel.isFav = true
           _ = Helper.addFavID(String(self.viewModel.item.id))
        }
        print(Helper.readFavList()!)
        checkFavStatus()
    }
}
