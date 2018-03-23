//
//  CloudServices.swift
//  rcloneosx
//
//  Created by Thomas Evensen on 09.11.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//
// swiftlint:disable
import Foundation

final class CloudServices: ProcessCmd {
    override init (command: String?, arguments: [String]?) {
        super.init(command: command, arguments: arguments)
        self.updateDelegate = nil
    }
}
