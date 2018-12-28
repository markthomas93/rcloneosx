//
//  ViewControllerRcloneParameters.swift
//
//  The ViewController for rclone parameters.
//
//  Created by Thomas Evensen on 13/02/16.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//
//  swiftlint:disable line_length

import Foundation
import Cocoa

// protocol for returning if userparams is updated or not
protocol RcloneUserParams: class {
    func rcloneuserparamsupdated()
}

// Protocol for sending selected index in tableView
// The protocol is implemented in ViewControllertabMain
protocol GetSelecetedIndex: class {
    func getindex() -> Int?
}

class ViewControllerRcloneParameters: NSViewController, SetConfigurations, SetDismisser, Index {

    var storageapi: PersistentStorageAPI?
    var parameters: RcloneParameters?
    weak var userparamsupdatedDelegate: RcloneUserParams?
    var comboBoxValues = [String]()
    var diddissappear: Bool = false

    @IBOutlet weak var param1: NSTextField!
    @IBOutlet weak var param2: NSTextField!
    // user selected parameter
    @IBOutlet weak var param8: NSTextField!
    @IBOutlet weak var param9: NSTextField!
    @IBOutlet weak var param10: NSTextField!
    @IBOutlet weak var param11: NSTextField!
    @IBOutlet weak var param12: NSTextField!
    @IBOutlet weak var param13: NSTextField!
    @IBOutlet weak var param14: NSTextField!
    // Comboboxes
    @IBOutlet weak var combo8: NSComboBox!
    @IBOutlet weak var combo9: NSComboBox!
    @IBOutlet weak var combo10: NSComboBox!
    @IBOutlet weak var combo11: NSComboBox!
    @IBOutlet weak var combo12: NSComboBox!
    @IBOutlet weak var combo13: NSComboBox!
    @IBOutlet weak var combo14: NSComboBox!

    @IBAction func close(_ sender: NSButton) {
        self.dismissview(viewcontroller: self, vcontroller: .vctabmain)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.userparamsupdatedDelegate = ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        guard self.diddissappear == false else { return }
        if let profile = self.configurations!.getProfile() {
            self.storageapi = PersistentStorageAPI(profile: profile)
        } else {
            self.storageapi = PersistentStorageAPI(profile: nil)
        }
        var configurations: [Configuration] = self.configurations!.getConfigurations()
        if let index = self.index() {
            // Create RcloneParameters object and load initial parameters
            self.parameters = RcloneParameters(config: configurations[index])
            self.comboBoxValues = parameters!.getComboBoxValues()
            self.param1.stringValue = configurations[index].parameter1 ?? ""
            self.param2.stringValue = configurations[index].parameter2 ?? ""
            // There are seven user seleected rclone parameters
            self.initcombox(combobox: self.combo8, index: self.parameters!.getParameter(rcloneparameternumber: 8).0)
            self.param8.stringValue = self.parameters!.getParameter(rcloneparameternumber: 8).1
            self.initcombox(combobox: self.combo9, index: self.parameters!.getParameter(rcloneparameternumber: 9).0)
            self.param9.stringValue = self.parameters!.getParameter(rcloneparameternumber: 9).1
            self.initcombox(combobox: self.combo10, index: self.parameters!.getParameter(rcloneparameternumber: 10).0)
            self.param10.stringValue = self.parameters!.getParameter(rcloneparameternumber: 10).1
            self.initcombox(combobox: self.combo11, index: self.parameters!.getParameter(rcloneparameternumber: 11).0)
            self.param11.stringValue = self.parameters!.getParameter(rcloneparameternumber: 11).1
            self.initcombox(combobox: self.combo12, index: self.parameters!.getParameter(rcloneparameternumber: 12).0)
            self.param12.stringValue = self.parameters!.getParameter(rcloneparameternumber: 12).1
            self.initcombox(combobox: self.combo13, index: self.parameters!.getParameter(rcloneparameternumber: 13).0)
            self.param13.stringValue = self.parameters!.getParameter(rcloneparameternumber: 13).1
            self.initcombox(combobox: self.combo14, index: self.parameters!.getParameter(rcloneparameternumber: 14).0)
            self.param14.stringValue = self.parameters!.getParameter(rcloneparameternumber: 14).1
        }
        self.backupbutton.state = .off
        self.suffixbutton.state = .off
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        self.diddissappear = true
    }

    // Function for saving changed or new parameters for one configuration.
    @IBAction func update(_ sender: NSButton) {
        var configurations: [Configuration] = self.configurations!.getConfigurations()
        guard configurations.count > 0 else { return }
        if let index = self.index() {
            configurations[index].parameter8 = self.parameters!.getRcloneParameter(indexComboBox:
                self.combo8.indexOfSelectedItem, value: getValue(value: self.param8.stringValue))
            configurations[index].parameter9 = self.parameters!.getRcloneParameter(indexComboBox:
                self.combo9.indexOfSelectedItem, value: getValue(value: self.param9.stringValue))
            configurations[index].parameter10 = self.parameters!.getRcloneParameter(indexComboBox:
                self.combo10.indexOfSelectedItem, value: getValue(value: self.param10.stringValue))
            configurations[index].parameter11 = self.parameters!.getRcloneParameter(indexComboBox:
                self.combo11.indexOfSelectedItem, value: getValue(value: self.param11.stringValue))
            configurations[index].parameter12 = self.parameters!.getRcloneParameter(indexComboBox:
                self.combo12.indexOfSelectedItem, value: getValue(value: self.param12.stringValue))
            configurations[index].parameter13 = self.parameters!.getRcloneParameter(indexComboBox:
                self.combo13.indexOfSelectedItem, value: getValue(value: self.param13.stringValue))
            configurations[index].parameter14 = self.parameters!.getRcloneParameter(indexComboBox:
                self.combo14.indexOfSelectedItem, value: getValue(value: self.param14.stringValue))
            self.configurations!.updateConfigurations(configurations[index], index: index)
            self.userparamsupdatedDelegate?.rcloneuserparamsupdated()
        }
        self.dismissview(viewcontroller: self, vcontroller: .vctabmain)
    }

    // There are eight comboboxes
    // All eight are initalized during ViewDidLoad and
    // the correct index is set.
    private func initcombox (combobox: NSComboBox, index: Int) {
        combobox.removeAllItems()
        combobox.addItems(withObjectValues: self.comboBoxValues)
        combobox.selectItem(at: index)
    }

    // Returns nil or value from stringvalue (rclone parameters)
    private func getValue(value: String) -> String? {
        if value.isEmpty {
            return nil
        } else {
            return value
        }
    }

    @IBOutlet weak var backupbutton: NSButton!
    @IBAction func backup(_ sender: NSButton) {
        switch self.backupbutton.state {
        case .on:
            let hiddenID = self.configurations!.gethiddenID(index: (self.index())!)
            let remoteCatalog = self.configurations!.getResourceConfiguration(hiddenID, resource: .remoteCatalog)
            let offsiteServer = self.configurations!.getResourceConfiguration(hiddenID, resource: .offsiteServer)
            let backup = offsiteServer + ":" + remoteCatalog + "_backup"
            self.param13.stringValue = backup
            self.initcombox(combobox: self.combo13, index: (self.parameters!.indexandvaluercloneparameter("--backup-dir").0))
        case .off:
            self.initcombox(combobox: self.combo13, index: (0))
            self.param13.stringValue = ""
        default : break
        }
    }

    @IBOutlet weak var suffixbutton: NSButton!
    @IBAction func suffix(_ sender: NSButton) {
        switch self.suffixbutton.state {
        case .on:
            self.param14.stringValue = self.parameters!.suffixString
            self.initcombox(combobox: self.combo14, index: (self.parameters!.indexandvaluercloneparameter("--suffix").0))
        case .off:
            self.initcombox(combobox: self.combo14, index: (0))
            self.param14.stringValue = ""
        default : break
        }
    }

}
