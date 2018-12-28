//
//  rcloneParameters.swift
//  rcloneOSX
//
//  Created by Thomas Evensen on 03/10/2016.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//

import Foundation

final class RcloneParameters {

    // Tuple for rclone argument and value
    typealias Argument = (String, Int)
    // Static initial arguments, DO NOT change order
    private let rcloneArguments: [Argument] = [
        ("user", 1),
        ("delete", 0),
        ("--backup-dir", 1),
        ("--bwlimit", 1),
        ("--transfers", 1),
        ("--exclude", 1),
        ("--exclude-from", 1),
        ("--no-traverse", 0),
        ("--no-gzip-encoding", 0),
        ("--suffix", 1)]

    let backupString = "--backup-dir"
    let suffixString = "\"$day\""
    private var comboBoxValues: [String]?
    private var config: Configuration?

    func getComboBoxValues() -> [String] {
        return self.comboBoxValues ?? [""]
    }

    func getRcloneParameter(indexComboBox: Int, value: String?) -> String {
        guard  indexComboBox < self.rcloneArguments.count && indexComboBox > -1 else { return "" }
        switch self.rcloneArguments[indexComboBox].1 {
        case 0:
            if self.rcloneArguments[indexComboBox].0 == self.rcloneArguments[1].0 {
                return ""
            } else {
                return  self.rcloneArguments[indexComboBox].0
            }
        case 1:
            guard value != nil else { return "" }
            if self.rcloneArguments[indexComboBox].0 != self.rcloneArguments[0].0 {
                return self.rcloneArguments[indexComboBox].0 + "=" + value!
            } else {
                return value!
            }
        default:
            return  ""
        }
    }

    // Returns Int value of argument
    private func indexofrcloneparameter (_ argument: String) -> Int {
        var index: Int = -1
        loop : for i in 0 ..< self.rcloneArguments.count where argument == self.rcloneArguments[i].0 {
            index = i
            break loop
        }
        return index
    }

    // Split an rclone argument into argument and value
    private func split (_ str: String) -> [String] {
        let argument: String?
        let value: String?
        var split = str.components(separatedBy: "=")
        argument = String(split[0])
        if split.count > 1 {
            value = String(split[1])
        } else {
            value = argument
        }
        return [argument!, value!]
    }

    func indexandvaluercloneparameter(_ parameter: String?) -> (Int, String) {
        guard parameter != nil else { return (0, "") }
        let splitstr: [String] = self.split(parameter!)
        guard splitstr.count > 1 else { return (0, "")}
        let argument = splitstr[0]
        let value = splitstr[1]
        var returnvalue: String?
        var returnindex: Int?
        if argument != value && self.indexofrcloneparameter(argument) >= 0 {
            returnvalue = value
            returnindex =  self.indexofrcloneparameter(argument)
        } else {
            if self.indexofrcloneparameter(splitstr[0]) >= 0 {
                returnvalue = "\"" + argument + "\" " + "no arguments"
            } else {
                if argument == value {
                    returnvalue = value
                } else {
                    returnvalue = argument + "=" + value
                }
            }
            if argument != value && self.indexofrcloneparameter(argument) >= 0 {
                returnindex =  self.indexofrcloneparameter(argument)
            } else {
                if self.indexofrcloneparameter(splitstr[0]) >= 0 {
                    returnindex = self.indexofrcloneparameter(argument)
                } else {
                    returnindex = 0
                }
            }
        }
        return (returnindex!, returnvalue!)
    }

    func getParameter (rcloneparameternumber: Int) -> (Int, String) {
        var indexandvalue: (Int, String)?
        guard self.config != nil else { return (0, "")}
        switch rcloneparameternumber {
        case 8:
           indexandvalue = self.indexandvaluercloneparameter(self.config!.parameter8)
        case 9:
            indexandvalue = self.indexandvaluercloneparameter(self.config!.parameter9)
        case 10:
            indexandvalue = self.indexandvaluercloneparameter(self.config!.parameter10)
        case 11:
            indexandvalue = self.indexandvaluercloneparameter(self.config!.parameter11)
        case 12:
            indexandvalue = self.indexandvaluercloneparameter(self.config!.parameter12)
        case 13:
            indexandvalue = self.indexandvaluercloneparameter(self.config!.parameter13)
        case 14:
            indexandvalue = self.indexandvaluercloneparameter(self.config!.parameter14)
        default:
            return (0, "")
        }
        return indexandvalue!
    }

    init(config: Configuration) {
        self.config = config
        // Set string array for Comboboxes
        self.comboBoxValues = nil
        self.comboBoxValues = [String]()
        for i in 0 ..< self.rcloneArguments.count {
            self.comboBoxValues!.append(self.rcloneArguments[i].0)
        }
    }
}
