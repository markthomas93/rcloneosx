//
//  Verifyrclonepath.swift
//
//  Created by Thomas Evensen on 22.07.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//
//  SwiftLint: OK 31 July 2017
//  swiftlint:disable line_length

import Foundation

enum RclonecommandDisplay {
    case sync
    case restore
}

protocol Setinfoaboutrclone: class {
    func setinfoaboutrclone()
}

final class Verifyrclonepath: SetConfigurations {

    weak var verifyrcloneDelegate: Setinfoaboutrclone?

    // Function to verify full rclonepath
    func verifyrclonepath() {
        let fileManager = FileManager.default
        let path: String?
        // If not in /usr/bin or /usr/local/bin
        // rclonePath is set if none of the above
        if let rclonePath = ViewControllerReference.shared.rclonePath {
            path = rclonePath + ViewControllerReference.shared.rclone
        } else if ViewControllerReference.shared.rcloneopt {
            path = "/usr/local/bin/" + ViewControllerReference.shared.rclone
        } else {
            path = "/usr/bin/" + ViewControllerReference.shared.rclone
        }
        guard ViewControllerReference.shared.rcloneopt == true else {
            ViewControllerReference.shared.norclone = false
            self.verifyrcloneDelegate?.setinfoaboutrclone()
            return
        }
        if fileManager.fileExists(atPath: path!) == false {
            ViewControllerReference.shared.norclone = true
        } else {
            ViewControllerReference.shared.norclone = false
        }
        self.verifyrcloneDelegate?.setinfoaboutrclone()
    }

    // Display the correct command to execute, used for displaying the commands only
    func displayrclonecommand(index: Int, display: RclonecommandDisplay) -> String {
        var str: String?
        let config = self.configurations!.getargumentAllConfigurations()[index]
        str = self.rclonepath() + " "
        switch display {
        case .sync:
            if let count = config.argdryRunDisplay?.count {
                for i in 0 ..< count {
                    str = str! + config.argdryRunDisplay![i]
                }
            }
        case .restore:
            if let count = config.restoredryRunDisplay?.count {
                for i in 0 ..< count {
                    str = str! + config.restoredryRunDisplay![i]
                }
            }
        }
        return str ?? ""
    }

    // Function returns the correct path for rclone according to configuration set by user or default value.
    func rclonepath() -> String {
        if ViewControllerReference.shared.rcloneopt {
            if ViewControllerReference.shared.rclonePath == nil {
                return ViewControllerReference.shared.usrlocalbinrclone
            } else {
                return ViewControllerReference.shared.rclonePath! + ViewControllerReference.shared.rclone
            }
        } else {
            return ViewControllerReference.shared.usrbinrclone
        }
    }

    func norclone() {
        if let rclone = ViewControllerReference.shared.rclonePath {
            Alerts.showInfo("ERROR: no rclone in " + rclone)
        } else {
            Alerts.showInfo("ERROR: no rclone in /usr/local/bin")
        }
    }

    init() {
        self.verifyrcloneDelegate = ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
    }
}
