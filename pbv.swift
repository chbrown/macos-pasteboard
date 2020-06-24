#!/usr/bin/env swift
import Foundation
import Cocoa

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
Read Data from NSPasteboard.

- parameter pasteboard: specific pasteboard to read from
- parameter dataTypeName: name of pasteboard data type to read as

- throws: `NSError` if data cannot be read as given dataType
*/
func pasteboardData(_ pasteboard: NSPasteboard, dataTypeName: String) throws -> Data {
  let dataType = NSPasteboard.PasteboardType(rawValue: dataTypeName)
  if let string = pasteboard.string(forType: dataType) {
    let data = string.data(using: .utf8)!  // supposedly force-unwrapping using UTF-8 never fails
    return data
  }
  if let data = pasteboard.data(forType: dataType) {
    return data
  }
  throw NSError(
    domain: "pbv",
    code: 0,
    userInfo: [
      NSLocalizedDescriptionKey: "Could not access pasteboard contents as String or Data for type: '\(dataTypeName)'"
    ]
  )
}

/**
Read Data from NSPasteboard, trying each dataType in turn.

- parameter pasteboard: specific pasteboard to read from
- parameter dataTypeNames: names of pasteboard data type to try reading as

- throws: `NSError` if data cannot be read as _any_ of the given dataTypes
*/
func bestPasteboardData(_ pasteboard: NSPasteboard, dataTypeNames: [String]) throws -> Data {
  for dataTypeName in dataTypeNames {
    if let data = try? pasteboardData(pasteboard, dataTypeName: dataTypeName) {
      return data
    }
  }
  let dataTypeNamesJoined = dataTypeNames.map { "'\($0)'" }.joined(separator: ", ")
  throw NSError(
    domain: "pbv",
    code: 0,
    userInfo: [
      NSLocalizedDescriptionKey: "Could not access pasteboard contents as String or Data for types: \(dataTypeNamesJoined)"
    ]
  )
}

func printTypes(_ pasteboard: NSPasteboard) {
  printErr("Available types for the '\(pasteboard.name.rawValue)' pasteboard:")
  // Apple documentation says `types` "is an array NSString objects",
  // but that's wrong: they are PasteboardType structures.
  if let types = pasteboard.types {
    for type in types {
      printErr("  \(type.rawValue)")
    }
  } else {
    printErr("  (not available)")
  }
}

func printBestPasteboard(_ pasteboard: NSPasteboard, dataTypeNames: [String]) {
  do {
    let data = try bestPasteboardData(pasteboard, dataTypeNames: dataTypeNames)
    FileHandle.standardOutput.write(data)
    exit(0)
  } catch {
    printErr(error.localizedDescription)
    printTypes(pasteboard)
    exit(1)
  }
}

func printUsage(_ pasteboard: NSPasteboard) {
  let command = CommandLine.arguments.first ?? "pbv"
  printErr("Usage: \(command) [dataType [dataType [...]]] [-h|--help]\n")
  printTypes(pasteboard)
}

// CommandLine.arguments[0] is the fullpath to this file
// CommandLine.arguments[1+] should be the desired type(s)
let args = CommandLine.arguments.dropFirst()
if args.contains("-h") || args.contains("--help") {
  printUsage(NSPasteboard.general)
  exit(0)
}

// (main)
let types = args.isEmpty ? ["public.utf8-plain-text"] : Array(args)
printBestPasteboard(NSPasteboard.general, dataTypeNames: types)
