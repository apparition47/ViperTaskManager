# ViperTaskManager

The app will help users manage tasks. They will be able to make projects on the app and then add tasks to them. The app will fetch data from a [server](https://github.com/Lang-8/TasksServer) and display it in-app.

Written in Swift using VIPER. Tested on Xcode 8, iOS 10.1.

## Features

- [x] Swinject - Dependency Injection
- [x] RealmSwift - Persistent Storage
- [x] SwiftFetchedResultsController (NSFetchedResultsController for Realm written in Swift)
- [x] Alamofire - Networking 
- [x] UIStoryboard + XIB
- [x] UIAppearance
- [ ] MaterialColor -> CocoaPods
- [ ] SnapKit


## How to use

1. Setup and run [TasksServer](https://github.com/Lang-8/TasksServer).
2. If intending to run TasksServer and your app on different devices, open `Constants.swift` and edit `tasksServerEndpoint = "http://<TASK SERVER URL>" + ":8090" + "/"`.
3. Ensure you have CocoaPods then `pod install`
4. Run the app.


## License

Apache 2.0