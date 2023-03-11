//
//  TBUIObjectiveCell.swift
//  Task Blotter
//
//  Created by Paul Sons on 3/10/23.
//

import UIKit

class TBUIObjectiveCell: UITableViewCell {
    
    // these Outlets are needed by the delegate
    @IBOutlet weak var objectiveNameLabel: UILabel!
    @IBOutlet weak var taskSummary: UILabel!
    @IBOutlet weak var objectiveGrip: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
