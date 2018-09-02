//
//  RcloneVersionString.swift
//  rcloneosx
//
//  Created by Thomas Evensen on 27.12.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//
// swiftlint:disable line_length

import Foundation

final class RcloneVersionString: ProcessCmd {

    init () {
        super.init(command: nil, arguments: ["--version"])
        let outputprocess = OutputProcess()
        if ViewControllerReference.shared.norclone == false {
            self.updateDelegate = nil
            self.executeProcess(outputprocess: outputprocess)
            self.delayWithSeconds(0.25) {
                guard outputprocess.getOutput() != nil else { return }
                guard outputprocess.getOutput()!.count > 0 else { return }
                ViewControllerReference.shared.rcloneversionshort = outputprocess.getOutput()![0]
                ViewControllerReference.shared.rcloneversionstring = outputprocess.getOutput()!.joined(separator: "\n")
                if let rcloneversionshort = ViewControllerReference.shared.rcloneversionshort {
                    if rcloneversionshort == "rclone v1.43" {
                        ViewControllerReference.shared.rclone143 = true
                    } else {
                        ViewControllerReference.shared.rclone143 = false
                    }
                } else {
                    ViewControllerReference.shared.rclone143 = false
                }
                weak var shortstringDelegate: RcloneChanged?
                shortstringDelegate = ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
                shortstringDelegate?.rclonechanged()
            }
        }
    }
}
