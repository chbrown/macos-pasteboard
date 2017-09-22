#!/usr/bin/env swift
import Foundation
import Cocoa

let newline = Data(bytes: [0x0A] as [UInt8])

/**
Write the given string to STDERR.

Writing to STDERR takes a bit of boilerplate, compared to print().

- parameter str: native string to write encode in utf-8.

- parameter appendNewline: whether or not to write a newline (U+000A) after the given string (defaults to true)
*/
func printErr(_ str: String, appendNewline: Bool = true) {
  let handle = FileHandle.standardError
  if let data = str.data(using: String.Encoding.utf8) {
    handle.write(data)
    if appendNewline {
      handle.write(newline)
    }
  }
}

// CommandLine.arguments[0] is the fullpath to this file
// CommandLine.arguments[1] should be the desired type
let args = CommandLine.arguments.dropFirst()
// while `args` has dropped the script's own filename, and the count is
// correct, it's only a slice, and the indexing is the same as for the
// original CommandLine.arguments array
let type = args.isEmpty ? "public.utf8-plain-text" : args[1]
let pasteboard = NSPasteboard.general

if let string = pasteboard.string(forType: NSPasteboard.PasteboardType(rawValue: type)) {
  print(string, terminator: "")
} else {
  printErr("Could not access pasteboard as String")
  printErr("The available types are:")
  let types = pasteboard.types!
  for type in types {
    printErr("\t\(type)")
  }
}
