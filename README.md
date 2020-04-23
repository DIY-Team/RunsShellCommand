# RunsShellCommand
A library to support defining and running shell commands in swift scripts. Provides a protocol to define the command's composition and a method to execute it.

## Special Mention
The library uses John Sundell's Shellout repo as depedency for actually running the shell commands.
More info:
`https://github.com/JohnSundell/ShellOut.git`

## Usage
The library provides a protocol `AnyShellCommand`. 
Use this protocol to define the structure of your command's class, struct or enum. 

### Example 1:
```
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
```

### Example 2:
```
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

```

## Installation


### Using SwiftPM
In `Package.swift` file, define under dependencies:
`.package(url: "https://github.com/DIY-Team/RunsShellCommand", from: 0.0.1)`
dependency name: `RunsShellCommand`
