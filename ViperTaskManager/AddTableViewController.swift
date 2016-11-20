//
//  AddTableViewController.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 29/02/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit


class AddTableViewController: UITableViewController {
    
    let kTaskTableViewCellReuseIdentifier = "TaskTableViewCellReuseIdentifier"
    
    
    // MARK: VIPER Properties
    var presenter: AddPresenterProtocol!

    var project: Project!
    
//    let searchController = UISearchController(searchResultsController: nil)

//    var projects: [Project] = []
    
    
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

//        searchController.delegate = self
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.delegate = self
        
//        tableView.tableHeaderView = searchController.searchBar

//        definesPresentationContext = true

//        searchController.searchBar.sizeToFit()
//        searchController.active = true
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
        return project.tasks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kTaskTableViewCellReuseIdentifier, forIndexPath: indexPath) as! TaskTableViewCell
        cell.task = project.tasks[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let task = project.tasks[indexPath.row]
        
//        let alertController = UIAlertController(title: task.title, message: "Save to storage and Add to list or Add only", preferredStyle: UIAlertControllerStyle.Alert)
        
//        let saveAction =  UIAlertAction(title: "Save to storage", style: UIAlertActionStyle.Default) { [weak self] (action) -> Void in
//            self?.presenter.selectAndSaveTask(task)
//        }
//        alertController.addAction(saveAction)
        
//        let addAction = UIAlertAction(title: "Add only", style: UIAlertActionStyle.Default) { [weak self] (action) -> Void in
//            self?.presenter.selectTask(task)
//        }
//        alertController.addAction(addAction)
        
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        
//        self.presentViewController(alertController, animated: true, completion: nil)
        
        self.presenter.selectTask(task)
    }

    @IBAction func done(sender: AnyObject) {
        self.presenter.done()
    }
    
    @IBAction func sortBy(sender: AnyObject) {
//        self.presenter.cancel()
    }
    
    @IBAction func deleteProject(sender: AnyObject) {
        //        self.presenter.cancel()
    }
    
    @IBAction func editProjectName(sender: AnyObject) {
        //        self.presenter.cancel()
    }
    
    @IBAction func addTask(sender: AnyObject) {
        //        self.presenter.cancel()
    }
}

extension AddTableViewController: AddInterfaceProtocol {
    
//    func showEmpty() {
//        self.project.tasks.removeAll()
//        self.tableView.reloadData()
//    }
//    
//    func showTasks(tasks: [Task]) {
//        self.project.tasks.removeAll()
//        self.project.tasks = tasks
//        self.tableView.reloadData()
//    }
}

//extension AddTableViewController: UISearchControllerDelegate {
//    
//    func didPresentSearchController(searchController: UISearchController) {
//        searchController.searchBar.becomeFirstResponder()
//    }
//}
//
//extension AddTableViewController: UISearchBarDelegate {
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        self.presenter.cancel()
//    }
//}
//
//extension AddTableViewController: UISearchResultsUpdating {
//    
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        self.presenter.getCitiesWithName(searchController.searchBar.text!)
//    }
//}
