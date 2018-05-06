//
//  RcloneSize.swift
//  rcloneosx
//
//  Created by Thomas Evensen on 01.05.2018.
//  Copyright © 2018 Thomas Evensen. All rights reserved.
//

import Foundation

struct Size: Decodable {
    let count: Int
    let bytes: Int
}

class RcloneSize: SetConfigurations {

    init(index: Int, outputprocess: OutputProcess?) {
        let taskDelegate = ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
        let cloudservice = self.configurations!.getConfigurations()[index].offsiteServer
        let remotepath = self.configurations!.getConfigurations()[index].offsiteCatalog
        let remotetolist = cloudservice + ":" + remotepath + "/"
        let arguments = ["size", remotetolist, "--json"]
        let process = Rclone(arguments: arguments)
        process.executeProcess(outputprocess: outputprocess)
        taskDelegate?.getProcessReference(process: process.getProcess()!)
    }
}
