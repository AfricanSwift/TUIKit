//
//          File:   Example+Figfont.swift
//    Created by:   African Swift

import Foundation

public extension Example
{
  public struct Figfont
  {
    public static func demo() throws
    {
      Ansi.Cursor.position().stdout()
      let path = "Whimsy.flf"
      guard let test = try Figlet(fontFile: path) else {
        exit(1)
      }
      
      for _ in 0...5
      {
        for line in test.drawText(text: "Figfont")
        {
          print(Example.WWDC.generateRandomColor() + line)
        }
        print("".resetall)
      }
      Thread.sleep(forTimeInterval: 1)
    }
  }
}
