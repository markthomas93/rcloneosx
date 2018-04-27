//
//  ArgumentsOneConfiguration.swift
//
//  Created by Thomas Evensen on 09/02/16.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//
//  swiftlint OK - 17 July 2017
//  swiftlint:disable line_length

import Foundation

// Struct for to store info for ONE configuration.
// Struct is storing rsync arguments for real run, dryrun
// and a version to show in view of both

struct ArgumentsOneConfiguration {

    var config: Configuration?
    var arg: [String]?
    var argdryRun: [String]?
    var argDisplay: [String]?
    var argdryRunDisplay: [String]?
    var argslistRemotefiles: [String]?
    var argsRestorefiles: [String]?
    var argsRestorefilesdryRun: [String]?
    var argsRestorefilesdryRunDisplay: [String]?

    init(config: Configuration) {
        // The configuration
        self.config = config
        // All arguments for rsync is computed, two sets. One for dry-run and one for real run.
        // the parameter forDisplay = true computes arguments to display in view.
        self.arg = RcloneProcessArguments().argumentsRclone(config, dryRun: false, forDisplay: false)
        self.argDisplay = RcloneProcessArguments().argumentsRclone(config, dryRun: false, forDisplay: true)
        self.argdryRun = RcloneProcessArguments().argumentsRclone(config, dryRun: true, forDisplay: false)
        self.argdryRunDisplay = RcloneProcessArguments().argumentsRclone(config, dryRun: true, forDisplay: true)
        self.argslistRemotefiles = RcloneProcessArguments().argumentsRclonelistfile(config)
        self.argsRestorefiles = RcloneProcessArguments().argumentsRclonerestore(config, dryRun: false, forDisplay: false)
        self.argsRestorefilesdryRun = RcloneProcessArguments().argumentsRclonerestore(config, dryRun: true, forDisplay: false)
        self.argsRestorefilesdryRunDisplay = RcloneProcessArguments().argumentsRclonerestore(config, dryRun: true, forDisplay: true)
    }
}
