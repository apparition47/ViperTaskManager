//
//  DetailViewController.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - VIPER Properties
    var presenter: DetailPresenterProtocol!
    
    var task: Task?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var deadlineDatePicker: UIDatePicker!
    @IBOutlet weak var progressButton: UIButton!
    @IBOutlet weak var done: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        activityIndicatorView.color = MaterialColor.cyanColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let task = task {
            progressButton.setTitle(task.completed ? "Finished" : "Unfinshed", forState: .Normal)
            titleTextField.text = task.title
            deadlineDatePicker.date = task.deadline
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(sender: AnyObject) {
        let newTask = Task(taskId: task!.taskId, projectId: task!.projectId, title: titleTextField.text!, deadline: deadlineDatePicker.date, completed: progressButton.titleLabel?.text == "Finished" ? true : false)
        self.presenter.done(newTask)
    }
    
    @IBAction func toggleCompletion(sender: AnyObject) {
        progressButton.setTitle(progressButton.titleLabel?.text == "Finished" ? "Unfinished" : "Finished", forState: .Normal)
    }
}

extension DetailViewController: DetailInterfaceProtocol {

}
