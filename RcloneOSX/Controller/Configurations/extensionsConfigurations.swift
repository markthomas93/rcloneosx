//
//  extensionsConfigurations.swift
//  rcloneosx
//
//  Created by Thomas Evensen on 24.08.2018.
//  Copyright © 2018 Thomas Evensen. All rights reserved.
//

import Foundation
import Cocoa

// Protocol for returning object Configurations
protocol GetConfigurationsObject: class {
    func getconfigurationsobject() -> Configurations?
    func createconfigurationsobject(profile: String?) -> Configurations?
    func reloadconfigurationsobject()
}

protocol SetConfigurations {
    var configurationsDelegate: GetConfigurationsObject? { get }
    var configurations: Configurations? { get }
}

extension SetConfigurations {
    weak var configurationsDelegate: GetConfigurationsObject? {
        return ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
    }
    var configurations: Configurations? {
        return self.configurationsDelegate?.getconfigurationsobject()
    }
}

// Protocol for doing a refresh of tabledata
protocol Reloadandrefresh: class {
    func reloadtabledata()
}

protocol ReloadTable {
    var reloadDelegateMain: Reloadandrefresh? { get }
    var reloadDelegateSchedule: Reloadandrefresh? { get }
    var reloadDelegateBatch: Reloadandrefresh? { get }
    var reloadDelegateLogData: Reloadandrefresh? { get }
    func reloadtable(vcontroller: ViewController)
}

extension ReloadTable {
    weak var reloadDelegateMain: Reloadandrefresh? {
        return ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
    }
    weak var reloadDelegateSchedule: Reloadandrefresh? {
        return ViewControllerReference.shared.getvcref(viewcontroller: .vctabschedule) as? ViewControllertabSchedule
    }
    weak var reloadDelegateBatch: Reloadandrefresh? {
        return ViewControllerReference.shared.getvcref(viewcontroller: .vcbatch) as? ViewControllerBatch
    }
    weak var reloadDelegateLogData: Reloadandrefresh? {
        return ViewControllerReference.shared.getvcref(viewcontroller: .vcloggdata) as? ViewControllerLoggData
    }
    
    func reloadtable(vcontroller: ViewController) {
        if vcontroller == .vctabmain {
            self.reloadDelegateMain?.reloadtabledata()
        } else if vcontroller == .vctabschedule {
            self.reloadDelegateSchedule?.reloadtabledata()
        } else if vcontroller == .vcbatch {
            self.reloadDelegateBatch?.reloadtabledata()
        } else {
            self.reloadDelegateLogData?.reloadtabledata()
        }
    }
}

// Used to select argument
enum ArgumentsRclone {
    case arg
    case argdryRun
    case arglistfiles
    case argrestore
    case argrestoredryRun
    case argrestoreDisplaydryRun
}

// Enum which resource to return
enum ResourceInConfiguration {
    case remoteCatalog
    case localCatalog
    case offsiteServer
    case task
    case backupid
    case offsiteusername
}
