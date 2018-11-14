//
//  AddTableViewCell.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
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
        selectedBackgroundView.backgroundColor = MaterialColor.lightBlue
        self.selectedBackgroundView = selectedBackgroundView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        project = nil
    }
}
