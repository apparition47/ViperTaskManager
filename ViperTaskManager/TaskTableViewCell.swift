//
//  WeatherTableViewCell.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 03/03/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    var task: Task? {
        didSet {
            if let task = task {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = .MediumStyle
                dateFormatter.timeStyle = .MediumStyle
                deadlineLabel.text = dateFormatter.stringFromDate(task.deadline)
                
                titleLabel.text = task.title
                progressLabel.text = task.completed ? "finished" : "unfinished"
            } else {
                deadlineLabel.text = nil
                titleLabel.text = nil
                progressLabel.text = nil
            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let selectedBackgroundView = UIView(frame: CGRect.zero)
        selectedBackgroundView.backgroundColor = MaterialColor.lightBlueColor()
        self.selectedBackgroundView = selectedBackgroundView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    override func prepareForReuse() {
        super.prepareForReuse()
        
        task = nil
    }
}
