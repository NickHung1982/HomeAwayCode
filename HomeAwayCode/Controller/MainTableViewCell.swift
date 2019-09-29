//
//  MainTableViewCell.swift
//  HomeAwayCode
//
//  Created by Nick on 9/28/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    static let reuseID: String = "Cell"
    @IBOutlet weak var favImageView: UIImageView!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK:-
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //need this one for lunch from code
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI(){
       thumbImageView.layer.cornerRadius = 20
       thumbImageView.layer.masksToBounds = true
    }
    
    internal func setupTextData(feed: EventItem) {
        self.titleLabel.text = feed.title
        self.locationLabel.text = feed.venue.display_location
        self.dateLabel.text = Helper.transferDateString(feed.datetime_local)
        
        if (feed.is_open) {
            self.favImageView.image = UIImage(named: "favoriteIconCheck")
        }else{
            self.favImageView.image = UIImage(named: "favoriteIcon")
        }
    }
}
