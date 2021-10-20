//
//  GitHubTableViewCell.swift
//  RxTest
//
//  Created by Mikhail Ivanov on 20.10.2021.
//

import UIKit

class GitHubTableViewCell: UITableViewCell {
    
    static let idCell = "GitHubTableViewCell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorRepoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        print("2")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
