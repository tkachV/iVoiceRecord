//
//  AppDelegate.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/3/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let appCoordinator = AppCoordinator(window: window)
        
        self.window = window
        self.appCoordinator = appCoordinator
        
        /* START APPLICATION WORKFLOW. */
        appCoordinator.startApplicationWorkflow()
        
        return true
    }


}

