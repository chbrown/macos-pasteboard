#!/usr/bin/env swift
import Foundation
import Cocoa

let newline = NSData(bytes: [0x0A] as [UInt8], length: 1)
func printErr(str: String, appendNewline: Bool = true) {
  let handle = NSFileHandle.fileHandleWithStandardError()
  if let data = str.dataUsingEncoding(NSUTF8StringEncoding) {
    handle.writeData(data)
    if appendNewline {
      handle.writeData(newline)
    }
  }
}

// Process.arguments[0] is the fullpath to this file
// Process.arguments[1] should be the desired type
let args = Process.arguments.dropFirst()
// while `args` has dropped the script's own filename, and the count is
// correct, it's only a slice, and the indexing is the same as for the
// original Process.arguments array
let type = args.isEmpty ? "public.utf8-plain-text" : args[1]
let pasteBoard = NSPasteboard.generalPasteboard()

if let string = pasteBoard.stringForType(type) {
  print(string, terminator:"")
} else {
  printErr("Could not access pasteboard as String")
  printErr("The available types are:")
  let types = pasteBoard.types!
  for type in types {
    printErr("\t\(type)")
  }
}
