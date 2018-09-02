//
//  ViewControllerReference.swift
//  rcloneOSX
//
//  Created by Thomas Evensen on 05.09.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//
// swiftlint:disable cyclomatic_complexity

import Foundation
import Cocoa

enum ViewController {
    case vctabmain
    case vcloggdata
    case vcnewconfigurations
    case vctabschedule
    case vcabout
    case vcbatch
    case vcprogressview
    case vccopyfiles
    case vcquickbackup
    case vcallprofiles
    case vcestimatingtasks
    case vcremoteinfo
    case vcrestore
    case vcalloutput
}

class ViewControllerReference {

    // Creates a singelton of this class
    class var  shared: ViewControllerReference {
        struct Singleton {
            static let instance = ViewControllerReference()
        }
        return Singleton.instance
    }

    var timerTaskWaiting: Timer?
    var dispatchTaskWaiting: DispatchWorkItem?
    // Temporary storage of the first scheduled task
    var scheduledTask: NSDictionary?
    // Download URL if new version is avaliable
    var URLnewVersion: String?
    // True if rclone in /usr/local/bin
    var rcloneopt: Bool = true
    // Optional path to rclone
    var rclonePath: String?
    // No valid rclonePath - true if no valid rclone is found
    var norclone: Bool = false
    // Detailed logging
    var detailedlogging: Bool = true
    // Temporary path for restore
    var restorePath: String?
    // Kind of Operation method. eiher Timer or DispatchWork
    var operation: OperationObject = .dispatch
    // Reference to the Operation object
    // Reference is set in when Scheduled task is executed
    var completeoperation: CompleteScheduledOperation?
    // rclone command
    var rclone: String = "rclone"
    var usrbinrclone: String = "/usr/bin/rclone"
    var usrlocalbinrclone: String = "/usr/local/bin/rclone"
    var configpath: String = "/Rclone/"
    // Loggfile
    var minimumlogging: Bool = false
    var fulllogging: Bool = false
    var logname: String = "rclonelog"
    var fileURL: URL?
    // Mark number of days since last backup
    var marknumberofdayssince: Double = 5
    // Rclone version string
    var rcloneversionstring: String?
    // Rclone version short
    var rcloneversionshort: String?
    // If rclone version 1.43 or more
    var rclone143: Bool = false
    // Mac serialnumer
    var macserialnumber: String?
    // Reference to main View
    private var viewControllertabMain: NSViewController?
    // Reference to Copy files
    private var viewControllerCopyFiles: NSViewController?
    // Reference to the New tasks
    private var viewControllerNewConfigurations: NSViewController?
    // Reference to the  Schedule
    private var viewControllertabSchedule: NSViewController?
    // Which profile to use, if default nil
    private var viewControllerLoggData: NSViewController?
    // Reference to Ssh view
    private var viewControllerSsh: NSViewController?
    // Reference to About
    private var viewControllerAbout: NSViewController?
    //  Refereence to batchview
    private var viewControllerBatch: NSViewController?
    // ProgressView single task
    private var viewControllerProgressView: NSViewController?
    // Quick batch
    private var viewControllerQuickBatch: NSViewController?
    // All profiles
    private var viewControllerAllProfiles: NSViewController?
    // Estimating tasks
    private var viewControllerEstimatingTasks: NSViewController?
    // Remote info
    private var viewControllerRemoteInfo: NSViewController?
    // Restore
    private var viewControllerRestore: NSViewController?
    // Alloutput
    private var viewControllerAlloutput: NSViewController?

    func getvcref(viewcontroller: ViewController) -> NSViewController? {
        switch viewcontroller {
        case .vctabmain:
            return self.viewControllertabMain
        case .vcloggdata:
            return self.viewControllerLoggData
        case .vcnewconfigurations:
            return self.viewControllerNewConfigurations
        case .vctabschedule:
            return self.viewControllertabSchedule
        case .vcabout:
            return self.viewControllerAbout
        case .vcbatch:
            return self.viewControllerBatch
        case .vcprogressview:
            return self.viewControllerProgressView
        case .vccopyfiles:
            return self.viewControllerCopyFiles
        case .vcquickbackup:
            return self.viewControllerQuickBatch
        case .vcallprofiles:
            return self.viewControllerAllProfiles
        case .vcestimatingtasks:
            return self.viewControllerEstimatingTasks
        case .vcremoteinfo:
            return self.viewControllerRemoteInfo
        case .vcrestore:
            return self.viewControllerRestore
        case .vcalloutput:
            return self.viewControllerAlloutput
        }
    }

    func setvcref(viewcontroller: ViewController, nsviewcontroller: NSViewController) {
        switch viewcontroller {
        case .vctabmain:
            self.viewControllertabMain = nsviewcontroller
        case .vcloggdata:
            self.viewControllerLoggData = nsviewcontroller
        case .vcnewconfigurations:
            self.viewControllerNewConfigurations = nsviewcontroller
        case .vctabschedule:
            self.viewControllertabSchedule = nsviewcontroller
        case .vcabout:
            self.viewControllerAbout = nsviewcontroller
        case .vcbatch:
            self.viewControllerBatch = nsviewcontroller
        case .vcprogressview:
            self.viewControllerProgressView = nsviewcontroller
        case .vccopyfiles:
            self.viewControllerCopyFiles = nsviewcontroller
        case .vcquickbackup:
            self.viewControllerQuickBatch = nsviewcontroller
        case .vcallprofiles:
            self.viewControllerAllProfiles = nsviewcontroller
        case .vcestimatingtasks:
            self.viewControllerEstimatingTasks = nsviewcontroller
        case .vcremoteinfo:
            self.viewControllerRemoteInfo = nsviewcontroller
        case .vcrestore:
            self.viewControllerRestore = nsviewcontroller
        case .vcalloutput:
            self.viewControllerAlloutput = nsviewcontroller
        }
    }
}
