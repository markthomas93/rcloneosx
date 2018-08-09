//
//  RestoreTask.swift
//  rcloneosx
//
//  Created by Thomas Evensen on 09.08.2018.
//  Copyright © 2018 Thomas Evensen. All rights reserved.
//

import Foundation

final class RestoreTask: SetConfigurations {
    var arguments: [String]?
    init(index: Int, outputprocess: OutputProcess?, dryrun: Bool, tmprestore: Bool) {
        let taskDelegate = ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
        if dryrun {
            if tmprestore {
                self.arguments = self.configurations!.arguments4tmprestore(index: index, argtype: .argdryRun)
                self.arguments![2] = ViewControllerReference.shared.restorePath ?? ""
            } else {
                self.arguments = self.configurations!.arguments4restore(index: index, argtype: .argdryRun)
            }
        } else {
            if tmprestore {
                self.arguments = self.configurations!.arguments4tmprestore(index: index, argtype: .arg)
                let lastindex = self.arguments!.count - 1
                self.arguments![lastindex] = ViewControllerReference.shared.restorePath ?? ""
            } else {
                self.arguments = self.configurations!.arguments4restore(index: index, argtype: .arg)
            }
        }
        guard arguments != nil else { return }
        let process = Rclone(arguments: self.arguments)
        process.executeProcess(outputprocess: outputprocess)
        taskDelegate?.getProcessReference(process: process.getProcess()!)
    }
}

