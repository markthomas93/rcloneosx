//
//  ViewControllerNew.swift
//
//  Created by Thomas Evensen on 13/02/16.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//

import Foundation
import Cocoa

class ViewControllerNewConfigurations: NSViewController, SetConfigurations, VcSchedule, Delay {

    var storageapi: PersistentStorageAPI?
    var newconfigurations: NewConfigurations?
    var tabledata: [NSMutableDictionary]?
    let copycommand: String = ViewControllerReference.shared.copy
    let movecommand: String = ViewControllerReference.shared.move
    let synccommand: String = ViewControllerReference.shared.sync
    let verbose: String = "--verbose"
    let dryrun: String = "--dry-run"
    let checkcommand: String = ViewControllerReference.shared.check
    var outputprocess: OutputProcess?
    var rclonecommand: String?
    var diddissappear: Bool = false

    @IBOutlet weak var viewParameter4: NSTextField!
    @IBOutlet weak var viewParameter5: NSTextField!
    @IBOutlet weak var localCatalog: NSTextField!
    @IBOutlet weak var offsiteCatalog: NSTextField!
    @IBOutlet weak var backupID: NSTextField!
    @IBOutlet weak var empty: NSTextField!
    @IBOutlet weak var profilInfo: NSTextField!
    @IBOutlet weak var newTableView: NSTableView!
    @IBOutlet weak var cloudService: NSComboBox!

    @IBAction func cleartable(_ sender: NSButton) {
        self.newconfigurations = nil
        self.newconfigurations = NewConfigurations()
        globalMainQueue.async(execute: { () -> Void in
            self.newTableView.reloadData()
            self.setFields()
        })
    }

    @IBOutlet weak var copyradio: NSButton!
    @IBOutlet weak var syncradio: NSButton!
    @IBOutlet weak var moveradio: NSButton!
    @IBOutlet weak var checkradio: NSButton!

    @IBAction func choosecommand(_ sender: NSButton) {
        if self.copyradio.state == .on {
            self.rclonecommand = self.copycommand
        } else if self.syncradio.state == .on {
            self.rclonecommand = self.synccommand
        } else if self.moveradio.state == .on {
            self.rclonecommand = self.movecommand
        } else if self.checkradio.state == .on {
            self.rclonecommand = self.checkcommand
        }
    }

    // Userconfiguration button
    @IBAction func userconfiguration(_ sender: NSButton) {
        globalMainQueue.async(execute: { () -> Void in
            self.presentAsSheet(self.viewControllerUserconfiguration!)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.newconfigurations = NewConfigurations()
        self.newTableView.delegate = self
        self.newTableView.dataSource = self
        self.localCatalog.toolTip = "By using Finder drag and drop filepaths."
        self.offsiteCatalog.toolTip = "By using Finder drag and drop filepaths."
        ViewControllerReference.shared.setvcref(viewcontroller: .vcnewconfigurations, nsviewcontroller: self)
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        guard self.diddissappear == false else { return }
        self.loadCloudServices()
        if let profile = self.configurations!.getProfile() {
            self.storageapi = PersistentStorageAPI(profile: profile)
        } else {
            self.storageapi = PersistentStorageAPI(profile: nil)
        }
        self.setFields()
        self.rclonecommand = self.synccommand
        self.syncradio.state = .on
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        self.diddissappear = true
    }

    private func loadCloudServices() {
        guard ViewControllerReference.shared.norclone == false else {
            return
        }
        self.outputprocess = nil
        self.outputprocess = OutputProcess()
        _ = GetCloudServices(outputprocess: self.outputprocess)
        self.cloudService.removeAllItems()
        self.delayWithSeconds(0.5) {
            self.cloudService.addItems(withObjectValues: self.outputprocess!.trimoutput(trim: .three)!)
        }
    }

    private func setFields() {
        self.viewParameter4.stringValue = self.verbose
        self.localCatalog.stringValue = ""
        self.offsiteCatalog.stringValue = ""
        self.cloudService.stringValue = ""
        self.backupID.stringValue = ""
        self.empty.isHidden = true
        self.syncradio.state = .on
    }

    @IBAction func addConfig(_ sender: NSButton) {
        guard self.cloudService.stringValue.isEmpty == false else {
            self.empty.isHidden = false
            return
        }
        let dict: NSMutableDictionary = [
            "task": self.rclonecommand ?? "",
            "backupID": self.backupID.stringValue,
            "localCatalog": self.localCatalog.stringValue,
            "offsiteCatalog": self.offsiteCatalog.stringValue,
            "offsiteServer": self.cloudService.stringValue,
            "parameter1": self.rclonecommand ?? ViewControllerReference.shared.copy,
            "parameter2": self.verbose,
            "dryrun": self.dryrun,
            "dateRun": ""]
        dict.setValue("no", forKey: "batch")
        dict.setValue(self.localCatalog.stringValue, forKey: "localCatalog")
        dict.setValue(self.offsiteCatalog.stringValue, forKey: "offsiteCatalog")
        self.configurations!.addNewConfigurations(dict)
        self.newconfigurations?.appendnewConfigurations(dict: dict)
        self.tabledata = self.newconfigurations!.getnewConfigurations()
        globalMainQueue.async(execute: { () -> Void in
            self.newTableView.reloadData()
        })
        self.setFields()
    }
}

extension ViewControllerNewConfigurations: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.newconfigurations?.newConfigurationsCount() ?? 0
    }

}

extension ViewControllerNewConfigurations: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard self.newconfigurations?.getnewConfigurations() != nil else {
            return nil
        }
        let object: NSMutableDictionary = self.newconfigurations!.getnewConfigurations()![row]
        return object[tableColumn!.identifier] as? String
    }

    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        self.tabledata![row].setObject(object!, forKey: (tableColumn?.identifier)! as NSCopying)
    }
}

extension ViewControllerNewConfigurations: DismissViewController {

    func dismiss_view(viewcontroller: NSViewController) {
        self.dismiss(viewcontroller)
    }
}

extension ViewControllerNewConfigurations: SetProfileinfo {
    func setprofile(profile: String, color: NSColor) {
        globalMainQueue.async(execute: { () -> Void in
            self.profilInfo.stringValue = profile
            self.profilInfo.textColor = color
        })
    }
}
