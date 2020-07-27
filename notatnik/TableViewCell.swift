//
//  TableViewCell.swift
//  notatnik
//
//  Created by Kuba on 19/04/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var miniView: UIVisualEffectView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
     //   miniView.layer.cornerRadius = miniView.frame.size.height / 5
        miniView.layer.cornerRadius = 20
        miniView.clipsToBounds = true
        //miniView.backgroundColor = UIColor.clear
        
        
        
      // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
