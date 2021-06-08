//
//  AnyShellCommand.swift
//
//
//  Created by Vishal Singh on 10/05/21.
//

import Files
import Foundation
import ShellOut

public protocol AnyShellCommand {
    
    /// the primary part of the command (the firs word of command)
    var command: String { get }

    /// default arguments passed during execution before the additional arguments, default: empty
    var defaultArguments: [String] { get }
    
    /// executes the command with its default arguments + the arguments, if any provided as parameter
    /// - Parameters:
    ///   - arguments: an array of strings, default: empty
    ///   - path: path at which the command needs to be executed
    func execute(with arguments: [String], atPath path: String)
}

public extension AnyShellCommand {
    
    var defaultArguments: [String] {
        return []
    }

    func execute(with arguments: [String], atPath path: String) {
        do {
            try shellOut(to: command, arguments: defaultArguments + arguments, at: path, outputHandle: .standardOutput, errorHandle: .standardError)
        } catch let error {
            error.handle()
        }
    }
}

//
//  Error+Handle.swift
//
//
//  Created by Vishal Singh on 10/05/21.
//

public extension Error {
    func handle() {
        if let error = self as? FilesError<LocationErrorReason> {
            print(error.localizedDescription)
        } else if let error = self as? FilesError<ReadErrorReason> {
            print(error.localizedDescription)
        } else if let error = self as? FilesError<WriteErrorReason> {
            print(error.localizedDescription)
        } else if let error = self as? ShellOutError {
            print(error.output) // Prints STDOUT
        }
    }
}
