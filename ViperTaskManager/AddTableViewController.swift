//
//  AddTableViewController.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit


class AddTableViewController: UITableViewController {
    
    let kTaskTableViewCellReuseIdentifier = "TaskTableViewCellReuseIdentifier"
    
    
    // MARK: VIPER Properties
    var presenter: AddPresenterProtocol!

    var project: Project!
    var tasks: [Task] = []
    
    override var nibName: String? {
        get {
            let classString = String(self.dynamicType)
            return classString
        }
    }
    override var nibBundle: NSBundle? {
        get {
            return NSBundle.mainBundle()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: "TaskTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: kTaskTableViewCellReuseIdentifier)
        
        self.navigationController?.toolbarHidden = false
        
        self.navigationItem.rightBarButtonItems = []
        self.navigationItem.rightBarButtonItems!.append(self.editButtonItem())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = project.name
        
        
        self.presenter.fetchSortBy(project.projectId) { (sortBy) in
            self.presenter.fetchTasks(self.project.projectId) { (result: [Task]?) -> Void in
                self.displayTasks(result!, sortBy: sortBy)
            }
        }
    }
    
    func displayTasks(result: [Task], sortBy: String) {
        let sortedTasks: [Task]
        if (sortBy == "title") {
            sortedTasks = result.sort { $0.title < $1.title }
        } else {
            sortedTasks = result.sort { $0.deadline.compare($1.deadline) == .OrderedAscending }
        }
        
        self.tasks = sortedTasks
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kTaskTableViewCellReuseIdentifier, forIndexPath: indexPath) as! TaskTableViewCell
        cell.task = self.tasks[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let task = self.tasks[indexPath.row]

        self.presenter.selectTask(task)
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            switch indexPath.section {
            case 0:
                let task = self.tasks[indexPath.row]
                self.presenter.removeTask(task) { (error) -> Void in
                    if (error == nil) {
                        self.tasks.removeAtIndex(indexPath.row)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    } else {
                        print("delete task error")
                    }
                }
        
            default:
                fatalError("Wrong section")
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    @IBAction func done(sender: AnyObject) {
        self.presenter.done()
    }
    
    @IBAction func sortBy(sender: AnyObject) {
        self.presenter.fetchSortBy(project.projectId) { (result) in
            let alert = UIAlertController(title: "Sort By: \(result)",
                                          message: "Tasks lists can be sorted by title or deadline.",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            
            let title = UIAlertAction(title: "title",
                                      style: UIAlertActionStyle.Default) { (action: UIAlertAction) in
                                        let newProject = Project(projectId: self.project.projectId, name: self.project.name, sortBy: "title", tasks: self.project.tasks)
                                        self.presenter.updateProjectInPersistentStore(newProject)
                                        self.displayTasks(self.project.tasks, sortBy: "title")
                                        
            }
            
            let deadline = UIAlertAction(title: "deadline",
                                         style: UIAlertActionStyle.Default) { (action: UIAlertAction) in
                                            let newProject = Project(projectId: self.project.projectId, name: self.project.name, sortBy: "deadline", tasks: self.project.tasks)
                                            self.presenter.updateProjectInPersistentStore(newProject)
                                            self.displayTasks(self.project.tasks, sortBy: "deadline")
            }
            
            let cancel = UIAlertAction(title: "Cancel",
                                       style: UIAlertActionStyle.Cancel,
                                       handler: nil)
            
            alert.addAction(title)
            alert.addAction(deadline)
            alert.addAction(cancel)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    @IBAction func editProjectName(sender: AnyObject) {
        let alert = UIAlertController(title: "New Project",
                                      message: "Type in a name",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "OK",
                               style: UIAlertActionStyle.Default) { (action: UIAlertAction) in
                                
            if let alertTextField = alert.textFields?.first where alertTextField.text != nil {
                
                print("And the text is... \(alertTextField.text!)!")
                
                let newProject = Project(projectId: self.project.projectId, name: alertTextField.text!, sortBy: self.project.sortBy, tasks: self.project.tasks)
                
                self.presenter.updateProject(newProject, callback: { (result, error) in
                    if (error == nil) {
                        self.title = result?.name
                    } else {
                        print("failed to update project name")
                    }
                })
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel",
                                   style: UIAlertActionStyle.Cancel,
                                   handler: nil)
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) in
            textField.placeholder = ""
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func addTask(sender: AnyObject) {
        let alert = UIAlertController(title: "New Task",
                                      message: "Type in a title",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "OK",
                               style: UIAlertActionStyle.Default) { (action: UIAlertAction) in
                                
                                if let alertTextField = alert.textFields?.first where alertTextField.text != nil {
                                    
                                    print("And the text is... \(alertTextField.text!)!")
                                    // presents detail view if successful
                                    self.presenter.addNewTask(self.project.projectId, title: alertTextField.text!)
                                }
        }
        
        let cancel = UIAlertAction(title: "Cancel",
                                   style: UIAlertActionStyle.Cancel,
                                   handler: nil)
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) in
            textField.placeholder = ""
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

extension AddTableViewController: AddInterfaceProtocol {
    
}
