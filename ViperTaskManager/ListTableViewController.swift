//
//  ListTableViewController.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftFetchedResultsController


class ListTableViewController: UITableViewController {
    let kProjectTableViewCellReuseIdentifier = "ProjectTableViewCellReuseIdentifier"
    
    // MARK: - VIPER Properties
    var presenter: ListPresenterProtocol!


    var projectFetchedResultsController: FetchedResultsController<ProjectEntity>!
    var projects: [Project] = []
    
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

        tableView.register(UINib(nibName: "ProjectTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kProjectTableViewCellReuseIdentifier)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
//        self.navigationItem.rightBarButtonItems!.append(self.editButtonItem())
        self.navigationItem.rightBarButtonItems = []
        self.navigationItem.rightBarButtonItems!.append(self.editButtonItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presenter.fetchProjects() { (result: [Project]) -> Void in
            self.projects = result
            self.tableView.reloadData()
        }
        
        // TODO refactor to comply with VIPER
        //        let realm = try! Realm()
        //        let predicate = NSPredicate(format: "projectId != %@", "0")
        //        let fetchRequest = FetchRequest<TaskEntity>(realm: realm, predicate: predicate)
        //        let sortDescriptor = SortDescriptor(property: "name", ascending: true)
        //        fetchRequest.sortDescriptors = [sortDescriptor]
        //        self.taskFetchedResultsController = FetchedResultsController<TaskEntity>(fetchRequest: fetchRequest, sectionNameKeyPath: nil, cacheName: nil)
        //        self.taskFetchedResultsController!.delegate = self
        //        self.taskFetchedResultsController!.performFetch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        switch section {
        case 0:
            return projects.count
        default:
            fatalError("Wrong section")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Project List"
        default:
            fatalError("Wrong section")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: kProjectTableViewCellReuseIdentifier, for: indexPath) as! ProjectTableViewCell
            cell.project = projects[indexPath.row]
            return cell
        default:
            fatalError("Wrong indexPath")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let project = projects[indexPath.row]
            self.presenter.showDetailProject(project: project)
        default:
            fatalError("Wrong section")
        }
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
                let project = projects[indexPath.row]
                self.presenter.removeProject(project: project) { (error) -> Void in
                    if (error == nil) {
                        self.projects.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    } else {
                        print("delete project error")
                    }
                }
                

            default:
                fatalError("Wrong section")
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }

    @IBAction func add(sender: AnyObject) {
        let alert = UIAlertController(title: "New Project",
                                      message: "Type in a name",
                                      preferredStyle: UIAlertController.Style.alert)
        
        let ok = UIAlertAction(title: "OK",
                               style: UIAlertAction.Style.default) { (action: UIAlertAction) in
                                
                                if let alertTextField = alert.textFields?.first, alertTextField.text != nil {
                
                print("And the text is... \(alertTextField.text!)!")
                                    self.presenter.addNewProject(name: alertTextField.text!)
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

extension ListTableViewController: ListInterfaceProtocol {
    
}

extension ListTableViewController: AddViewControllerDelegate {
    
    func addViewControllerDidSelectProject(project: Project) {
        projects.append(project)
        self.tableView.reloadData()
    }
}
