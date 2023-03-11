//
//  TBUIGoalCell.swift
//  Task Blotter
//
//  Created by Paul Sons on 3/4/23.
//

import UIKit

// https://developer.apple.com/documentation/uikit/views_and_controls/table_views/configuring_the_cells_for_your_table#3108689
class TBUIGoalCell: UITableViewCell {
    
    // these Outlets are needed by the delegate
    @IBOutlet weak var goalNameLabel: UILabel!
    @IBOutlet weak var objectiveSummary: UILabel!
    @IBOutlet weak var goalGrip: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
