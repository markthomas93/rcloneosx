//
//  userconfiguration.swift
//  rcloneOSXver30
//
//  Created by Thomas Evensen on 24/08/2016.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//
// swiftlint:disable line_length cyclomatic_complexity

import Foundation

// Reading userconfiguration from file into rcloneOSX
final class Userconfiguration {

    weak var rclonechangedDelegate: RcloneChanged?

    private func readUserconfiguration(dict: NSDictionary) {
        // Detailed logging
        if let detailedlogging = dict.value(forKey: "detailedlogging") as? Int {
            if detailedlogging == 1 {
                ViewControllerReference.shared.detailedlogging = true
            } else {
                ViewControllerReference.shared.detailedlogging = false
            }
        }
        // Optional path for rclone
        if let rclonePath = dict.value(forKey: "rclonePath") as? String {
            ViewControllerReference.shared.rclonePath = rclonePath
        }
        // Temporary path for restores single files or directory
        if let restorePath = dict.value(forKey: "restorePath") as? String {
            ViewControllerReference.shared.restorePath = restorePath
        } else {
            ViewControllerReference.shared.restorePath = NSHomeDirectory() + "/tmp/"
        }
        // Operation object
        // Default is dispatch
        if let operation = dict.value(forKey: "operation") as? String {
            switch operation {
            case "dispatch":
                ViewControllerReference.shared.operation = .dispatch
            case "timer":
                ViewControllerReference.shared.operation = .timer
            default:
                ViewControllerReference.shared.operation = .dispatch
            }
        }
        // Mark tasks
        if let marknumberofdayssince = dict.value(forKey: "marknumberofdayssince") as? String {
            if Double(marknumberofdayssince)! > 0 {
                let oldmarknumberofdayssince = ViewControllerReference.shared.marknumberofdayssince
                ViewControllerReference.shared.marknumberofdayssince = Double(marknumberofdayssince)!
                if oldmarknumberofdayssince != ViewControllerReference.shared.marknumberofdayssince {
                    weak var reloadconfigurationsDelegate: Createandreloadconfigurations?
                    reloadconfigurationsDelegate = ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
                    reloadconfigurationsDelegate?.createandreloadconfigurations()
                }
            }
        }
    }

    init (userconfigrcloneOSX: [NSDictionary]) {
        if userconfigrcloneOSX.count > 0 {
            self.readUserconfiguration(dict: userconfigrcloneOSX[0])
        }
        // If userconfiguration is read from disk update info in main view
        self.rclonechangedDelegate = ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
        self.rclonechangedDelegate?.rclonechanged()
        // Check for rclone
        Tools().verifyrclonepath()
        _ = RcloneVersionString()
    }
}
