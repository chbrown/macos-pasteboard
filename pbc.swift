#!/usr/bin/env swift
import Cocoa
import Foundation

let newline = Data([0x0A] as [UInt8])

/**
 Write the given string to STDERR.

 - parameter str: native string to write encode in utf-8.
 - parameter appendNewline: whether or not to write a newline (U+000A) after the given string (defaults to true)
 */
func printErr(_ str: String, appendNewline: Bool = true) {
    // writing to STDERR takes a bit of boilerplate, compared to print()
    if let data = str.data(using: .utf8) {
        FileHandle.standardError.write(data)
        if appendNewline {
            FileHandle.standardError.write(newline)
        }
    }
}

/**
 Write Data from NSPasteboard.

 - parameter pasteboard: specific pasteboard to write to
 - parameter dataTypeName: name of pasteboard data type to write as

 - throws: `NSError` if data cannot be written as given dataType
 */
func writePasteboardData(_ pasteboard: NSPasteboard, values: [(NSPasteboard.PasteboardType, Data)]) throws {
    var types: [NSPasteboard.PasteboardType] = []
    for value in values {
        types.append(value.0)
    }

    pasteboard.declareTypes(types, owner: nil)
    for value in values {
        pasteboard.setData(value.1, forType: value.0)
    }
    return
}

// CLI helpers

private func basename(_ pathOption: String?) -> String? {
    if let path = pathOption {
        return URL(fileURLWithPath: path).lastPathComponent
    }
    return nil
}

private func printUsage(_ pasteboard: NSPasteboard) {
    let process = basename(CommandLine.arguments.first) ?? "pbv"
    printErr("""
    Usage: \(process) [-h|--help]
           \(process) [[dataType data] ...] dataType [data]

    Write pairs of 'dataType', 'data' to the clipboard. If the last data
    argument is left off, it will read data from stdin for that pair.

    Options:
      -h|--help    Show this help and exit

    """)
}

// CLI entry point

func main() {
    let pasteboard: NSPasteboard = .general

    // CommandLine.arguments[0] is the fullpath to this file
    // CommandLine.arguments[1] should be the desired type
    let args = Array(CommandLine.arguments.dropFirst())
    if args.contains("-h") || args.contains("--help") {
        printUsage(pasteboard)
        exit(0)
    }

    // let type = args.isEmpty ? "public.utf8-plain-text" : args[0]
    var i = 0
    var pbValues: [(NSPasteboard.PasteboardType, Data)] = []
    while i < args.count {
        let t = NSPasteboard.PasteboardType(rawValue: args[i])
        i += 1

        var d: Data;
        if i < args.count {
            d = args[i].data(using: .utf8)! // supposedly force-unwrapping using UTF-8 never fails
            i += 1
        } else {
            do {
                d = try FileHandle.standardInput.readToEnd()!
            } catch {
                printErr(error.localizedDescription)
                exit(1)
            }
        }
        pbValues.append((t, d))
    }
    do {
        try writePasteboardData(pasteboard, values: pbValues)
        exit(0)
    } catch {
        printErr(error.localizedDescription)
        exit(1)
    }
}

main()
