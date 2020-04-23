//
//  RunsShellCommand.swift
//  Files
//
//  Created by Vishal Singh on 24/04/20.
//

import Foundation
import ShellOut

public protocol AnyShellCommand {
    
    var command: String { get }
    var arguments: [String] { get }
    var successMessage: String? { get }

    func execute(onSuccess: ((String) -> Void)?, onFailure: ((ShellOutError) -> Void)?)
}

public extension AnyShellCommand {
    
    func execute(onSuccess: ((String) -> Void)? = nil, onFailure: ((ShellOutError) -> Void)? = nil) {
        do {
            let output = try shellOut(to: command, arguments: arguments)
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
