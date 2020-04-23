//
//  RunsShellCommand.swift
//  Files
//
//  Created by Vishal Singh on 24/04/20.
//

import Foundation
import ShellOut

public protocol AnyShellCommand {
    
    /// the primary part of the command (the firs word of command)
    var command: String { get set }

    /// default arguments passed during execution before the additional arguments, default: empty
    var defaultArguments: [String] { get set }

    /// success message that, if not nil, gets printed by default when the command is successfully executed, default: nil
    /// if there is a custom handling for onSuccess block in execute method then this variable is not used
    var successMessage: String? { get set }

    
    /// executes the command with its default arguments + the arguments, if any provided as parameter
    /// - Parameters:
    ///   - arguments: an array of strings, default: empty
    ///   - onSuccess: for handling successful command execution, the output of the command is received on callback, default: prints the output
    ///   - onFailure: handle any failure in execution, returns the error, default: prints error message (STDERR) and output (STDOUT)
    func execute(with arguments: [String], onSuccess: ((String) -> Void)?, onFailure: ((ShellOutError) -> Void)?)
}

public extension AnyShellCommand {
    
    var defaultArguments: [String] {
        get { return [] }
        set {}
    }
    
    var successMessage: String? {
        get { return nil }
        set {}
    }
    
    func execute(with arguments: [String] = [], onSuccess: ((String) -> Void)? = nil, onFailure: ((ShellOutError) -> Void)? = nil) {
        do {
            let output = try shellOut(to: command, arguments: defaultArguments + arguments)
            if let onSuccess = onSuccess {
                onSuccess(output)
            } else {
                print(output)
                if let successMessage = successMessage {
                    print(successMessage)
                }
            }
        } catch let error {
            let error = error as! ShellOutError
            if let onFailure = onFailure {
                onFailure(error)
            } else {
                print(error.message) // Prints STDERR
                print(error.output) // Prints STDOUT
            }
        }
    }
}

enum GitCommand: AnyShellCommand {
    case createAndCheckoutNewBranch
    case deleteBranch
    
    var command: String {
        get { return "git" }
        set {}
    }
    
    var defaultArguments: [String] {
        get {
            switch self {
            case.createAndCheckoutNewBranch: return ["checkout", "-b"]
            case .deleteBranch: return ["branch", "-d"]
            }
        }
        set {}
    }
}

func demo1() {
    GitCommand.createAndCheckoutNewBranch.execute(with: ["new-branch-name"])
    GitCommand.deleteBranch.execute(with: ["some-old-branch"])
}

struct FileOperationCommand: AnyShellCommand {
    
    var command: String
}

func demo2() {
    let cDCommand = FileOperationCommand(command: "cd")

    let folderName = "new-folder"
    FileOperationCommand(command: "mkdir").execute(with: [folderName], onSuccess: { _ in
        cDCommand.execute(with: [folderName])
    }, onFailure: { _ in
        print("Failed to create new folder.")
    })
}

