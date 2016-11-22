//
//  DetailViewController.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 02/03/16.
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
    
//    override var nibName: String? {
//        get {
//            let classString = String(self.dynamicType)
//            return classString
//        }
//    }
//    override var nibBundle: NSBundle? {
//        get {
//            return NSBundle.mainBundle()
//        }
//    }
    
    
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
//            if task.isLocationEnable() == false {
//                self.weatherContainerView.hidden = true
//                self.activityIndicatorView.hidden = false
//                self.presenter.getDetailTask(task)
//            } else {
//                self.weatherContainerView.hidden = true
//                self.activityIndicatorView.hidden = false
//                self.presenter.getWeatherForTask(task)
//            }
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
    
//    func showEmpty() {
//        self.task = nil
//    }
//    
//    func showTask(task: Task) {
//        self.task = task
    
//        self.weatherContainerView.hidden = true
//        self.activityIndicatorView.hidden = false
        
//        self.presenter.getWeatherForTask(task)
//    }
    
//    func showWeatherForTask(weather: [Weather], task: Task) {
//        self.weatherContainerView.hidden = false
//        self.activityIndicatorView.hidden = true
//        
//        if weather.count > 0 {
//            let currentWeather = weather[0]
//            self.weatherLabel.text = currentWeather.tempString
//
//            let request = NSURLRequest(URL: NSURL(string: "http://openweathermap.org/img/w/\(currentWeather.icon).png")!)
//            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { [weak self] (response, data, error) -> Void in
//                if error == nil {
//                    guard let data = data else { return }
//                    let image = UIImage(data: data)
//                    self?.weatherIconImageView.image = image
//                } else {
//                    // Handle error
//                }
//            })
//        }
//        self.task = task
//    }
}
