//
//  Logging.swift
//  rcloneosx
//
//  Created by Thomas Evensen on 20.11.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//
// swiftlint:disable line_length

import Foundation

enum Fileerrortype {
    case openlogfile
    case writelogfile
    case profilecreatedirectory
    case profiledeletedirectory
}

// Protocol for reporting file errors
protocol Fileerror: class {
    func errormessage(errorstr: String, errortype: Fileerrortype)
}

protocol Reportfileerror {
    var errorDelegate: Fileerror? { get }
}

extension Reportfileerror {
    weak var errorDelegate: Fileerror? {
        return ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
    }
    
    func error(error: String, errortype: Fileerrortype) {
        self.errorDelegate?.errormessage(errorstr: error, errortype: errortype)
    }
}

protocol Fileerrormessage {
    func errordescription(errortype: Fileerrortype) -> String
}

extension Fileerrormessage {
    func errordescription(errortype: Fileerrortype) -> String {
        switch errortype {
        case .openlogfile:
            guard ViewControllerReference.shared.fileURL != nil else {
                return "No existing logfile, creating a new one"
            }
            return "No existing logfile, creating a new one: " + String(describing: ViewControllerReference.shared.fileURL!)
        case .writelogfile:
            return "Could not write to logfile"
        case .profilecreatedirectory:
            return "Could not create profile directory"
        case .profiledeletedirectory:
            return "Could not delete profile directory"
        }
    }
}

class Logging: Reportfileerror {

    var outputprocess: OutputProcess?
    var log: String?
    var filename: String?
    var fileURL: URL?

    private func write() {
        do {
            try self.log!.write(to: self.fileURL!, atomically: true, encoding: String.Encoding.utf8)
        } catch let e {
            let error = e as NSError
            self.error(error: error.description, errortype: .writelogfile)
        }
    }

    private func read() {
        do {
            self.log = try String(contentsOf: self.fileURL!, encoding: String.Encoding.utf8)
        } catch let e {
            let error = e as NSError
            self.error(error: error.description, errortype: .openlogfile)
        }
    }

    private func logg() {
        let currendate = Date()
        let dateformatter = Tools().setDateformat()
        let date = dateformatter.string(from: currendate)
        if ViewControllerReference.shared.fulllogging {
            self.read()
            let tmplogg: String = "\n" + "-------------------------------------------\n" + date + "\n"
                + "-------------------------------------------\n"
            if self.log == nil {
                self.log = tmplogg + self.outputprocess!.getOutput()!.joined(separator: "\n")
            } else {
                self.log = self.log! + tmplogg  + self.outputprocess!.getOutput()!.joined(separator: "\n")
            }
            self.write()
        } else if ViewControllerReference.shared.minimumlogging {
            self.read()
            var tmplogg = [String]()
            var startindex = self.outputprocess!.getOutput()!.count - 8
            if startindex < 0 { startindex = 0 }
            tmplogg.append("\n")
            tmplogg.append("-------------------------------------------")
            tmplogg.append(date)
            tmplogg.append("-------------------------------------------")
            tmplogg.append("\n")
            for i in startindex ..< self.outputprocess!.getOutput()!.count {
                tmplogg.append(self.outputprocess!.getOutput()![i])
            }
            if self.log == nil {
                self.log = tmplogg.joined(separator: "\n")
            } else {
                self.log = self.log! + tmplogg.joined(separator: "\n")
            }
            self.write()
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    init(outputprocess: OutputProcess?) {
        self.outputprocess = outputprocess
        self.filename = ViewControllerReference.shared.logname
        let DocumentDirURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        self.fileURL = DocumentDirURL?.appendingPathComponent(self.filename!).appendingPathExtension("txt")
        ViewControllerReference.shared.fileURL = self.fileURL
        self.logg()
    }
}
