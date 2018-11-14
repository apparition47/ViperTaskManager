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
            let classString = String(describing: type(of: self))
            return classString
        }
    }
    override var nibBundle: Bundle? {
        get {
            return Bundle.main
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kTaskTableViewCellReuseIdentifier)
        
        self.navigationController?.isToolbarHidden = false
        
        self.navigationItem.rightBarButtonItems = []
        self.navigationItem.rightBarButtonItems!.append(self.editButtonItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = project.name
        
        
        self.presenter.fetchSortBy(projectId: project.projectId) { (sortBy) in
            self.presenter.fetchTasks(projectId: self.project.projectId) { (result: [Task]?) -> Void in
                self.displayTasks(result: result!, sortBy: sortBy)
            }
        }
    }
    
    func displayTasks(result: [Task], sortBy: String) {
        let sortedTasks: [Task]
        if (sortBy == "title") {
            sortedTasks = result.sorted { $0.title < $1.title }
        } else {
            sortedTasks = result.sorted { $0.deadline.compare($1.deadline) == .orderedAscending }
        }
        
        self.tasks = sortedTasks
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTaskTableViewCellReuseIdentifier, for: indexPath) as! TaskTableViewCell
        cell.task = self.tasks[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.tasks[indexPath.row]
        
        self.presenter.selectTask(task: task)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            switch indexPath.section {
            case 0:
                let task = self.tasks[indexPath.row]
                self.presenter.removeTask(task: task) { (error) -> Void in
                    if error == nil {
                        self.tasks.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    } else {
                        print("delete task error")
                    }
                }
                
            default:
                fatalError("Wrong section")
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    @IBAction func done(sender: AnyObject) {
        self.presenter.done()
    }
    
    @IBAction func sortBy(sender: AnyObject) {
        self.presenter.fetchSortBy(projectId: project.projectId) { (result) in
            let alert = UIAlertController(title: "Sort By: \(result)",
                message: "Tasks lists can be sorted by title or deadline.",
                preferredStyle: UIAlertController.Style.alert)
            
            let title = UIAlertAction(title: "title",
                                      style: UIAlertAction.Style.default) { (action: UIAlertAction) in
                                        let newProject = Project(projectId: self.project.projectId, name: self.project.name, sortBy: "title", tasks: self.project.tasks)
                                        self.presenter.updateProjectInPersistentStore(project: newProject)
                                        self.displayTasks(result: self.project.tasks, sortBy: "title")
                                        
            }
            
            let deadline = UIAlertAction(title: "deadline",
                                         style: UIAlertAction.Style.default) { (action: UIAlertAction) in
                                            let newProject = Project(projectId: self.project.projectId, name: self.project.name, sortBy: "deadline", tasks: self.project.tasks)
                                            self.presenter.updateProjectInPersistentStore(project: newProject)
                                            self.displayTasks(result: self.project.tasks, sortBy: "deadline")
            }
            
            let cancel = UIAlertAction(title: "Cancel",
                                       style: UIAlertAction.Style.cancel,
                                       handler: nil)
            
            alert.addAction(title)
            alert.addAction(deadline)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func editProjectName(sender: AnyObject) {
        let alert = UIAlertController(title: "New Project",
                                      message: "Type in a name",
                                      preferredStyle: UIAlertController.Style.alert)
        
        let ok = UIAlertAction(title: "OK",
                               style: UIAlertAction.Style.default) { (action: UIAlertAction) in
                                
                                if let alertTextField = alert.textFields?.first, alertTextField.text != nil {
                                    
                                    print("And the text is... \(alertTextField.text!)!")
                                    
                                    let newProject = Project(projectId: self.project.projectId, name: alertTextField.text!, sortBy: self.project.sortBy, tasks: self.project.tasks)
                                    
                                    self.presenter.updateProject(project: newProject, callback: { (result, error) in
                                        if (error == nil) {
                                            self.title = result?.name
                                        } else {
                                            print("failed to update project name")
                                        }
                                    })
                                }
        }
        
        let cancel = UIAlertAction(title: "Cancel",
                                   style: UIAlertAction.Style.cancel,
                                   handler: nil)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = ""
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addTask(sender: AnyObject) {
        let alert = UIAlertController(title: "New Task",
                                      message: "Type in a title",
                                      preferredStyle: UIAlertController.Style.alert)
        
        let ok = UIAlertAction(title: "OK",
                               style: UIAlertAction.Style.default) { (action: UIAlertAction) in
                                
                                if let alertTextField = alert.textFields?.first, alertTextField.text != nil {
                                    
                                    print("And the text is... \(alertTextField.text!)!")
                                    // presents detail view if successful
                                    self.presenter.addNewTask(projectId: self.project.projectId, title: alertTextField.text!)
                                }
        }
        
        let cancel = UIAlertAction(title: "Cancel",
                                   style: UIAlertAction.Style.cancel,
                                   handler: nil)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = ""
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension AddTableViewController: AddInterfaceProtocol {
    
}
