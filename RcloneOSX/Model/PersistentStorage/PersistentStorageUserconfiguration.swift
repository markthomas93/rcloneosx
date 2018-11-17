//
//  PersistentStoreageUserconfiguration.swift
//  rcloneOSX
//
//  Created by Thomas Evensen on 26/10/2016.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//
// swiftlint:disable function_body_length

import Foundation

final class PersistentStorageUserconfiguration: Readwritefiles, SetConfigurations {

    /// Variable holds all configuration data
    private var userconfiguration: [NSDictionary]?

    /// Function reads configurations from permanent store
    /// - returns : array of NSDictonarys, return might be nil
    func readUserconfigurationsFromPermanentStore() -> [NSDictionary]? {
        return self.userconfiguration
    }

    // Saving user configuration
    func saveUserconfiguration () {
        var optionalpathrclone: Int?
        var detailedlogging: Int?
        var minimumlogging: Int?
        var fulllogging: Int?
        var rclonePath: String?
        var restorePath: String?
        var marknumberofdayssince: String?

        if ViewControllerReference.shared.rcloneopt {
            optionalpathrclone = 1
        } else {
            optionalpathrclone = 0
        }
        if ViewControllerReference.shared.detailedlogging {
            detailedlogging = 1
        } else {
            detailedlogging = 0
        }
        if ViewControllerReference.shared.minimumlogging {
            minimumlogging = 1
        } else {
            minimumlogging = 0
        }
        if ViewControllerReference.shared.fulllogging {
            fulllogging = 1
        } else {
            fulllogging = 0
        }
        if ViewControllerReference.shared.rclonePath != nil {
            rclonePath = ViewControllerReference.shared.rclonePath!
        }
        if ViewControllerReference.shared.restorePath != nil {
            restorePath = ViewControllerReference.shared.restorePath!
        }

        var array = [NSDictionary]()
        marknumberofdayssince = String(ViewControllerReference.shared.marknumberofdayssince)
        let dict: NSMutableDictionary = [
            "optionalpathrclone": optionalpathrclone! as Int,
            "detailedlogging": detailedlogging! as Int,
            "minimumlogging": minimumlogging! as Int,
            "fulllogging": fulllogging! as Int,
            "marknumberofdayssince": marknumberofdayssince ?? "5.0"]

        if rclonePath != nil {
            dict.setObject(rclonePath!, forKey: "rclonePath" as NSCopying)
        }
        if restorePath != nil {
            dict.setObject(restorePath!, forKey: "restorePath" as NSCopying)
        } else {
            dict.setObject("", forKey: "restorePath" as NSCopying)
        }
        switch self.configurations!.operation {
        case .dispatch:
            dict.setObject("dispatch", forKey: "operation" as NSCopying)
        case .timer:
            dict.setObject("timer", forKey: "operation" as NSCopying)
        }
        array.append(dict)
        self.writeToStore(array)
    }

    // Writing configuration to persistent store
    // Configuration is [NSDictionary]
    private func writeToStore (_ array: [NSDictionary]) {
        // Getting the object just for the write method, no read from persistent store
        _ = self.writeDatatoPersistentStorage(array, task: .userconfig)
    }

    init (readfromstorage: Bool) {
        super.init(task: .userconfig, profile: nil, configpath: ViewControllerReference.shared.configpath)
        if readfromstorage {
            self.userconfiguration = self.getDatafromfile()
        }
    }
}
