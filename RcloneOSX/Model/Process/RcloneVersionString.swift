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

    private func rcloneversion() -> Bool? {
        if let rcloneversionshort = ViewControllerReference.shared.rcloneversionshort {
            if rcloneversionshort == "rclone v1.43" ||
                rcloneversionshort == "rclone v1.43.1" ||
                rcloneversionshort == "rclone v1.44" {
                return true
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

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
                if ViewControllerReference.shared.rclone143 == nil {
                    ViewControllerReference.shared.rclone143 = self.rcloneversion()
                }
                weak var shortstringDelegate: RcloneChanged?
                shortstringDelegate = ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
                shortstringDelegate?.rclonechanged()
            }
        }
    }
}
