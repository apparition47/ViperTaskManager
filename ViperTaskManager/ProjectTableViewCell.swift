//
//  AddTableViewCell.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 02/03/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    var project: Project? {
        didSet {
            if let project = project {
                nameLabel.text = project.name
                unfinishedTasksLabel.text = "\(project.getUnfinishedTaskCount()) / \(project.tasks.count)"
            }
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unfinishedTasksLabel: UILabel!
    
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
        
        project = nil
    }
}
