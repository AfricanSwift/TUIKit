
//          File:   Example+WWDCLogo.swift
//    Created by:   African Swift

import Darwin

public struct Example_Figfont
{
  public static func demo() throws
  {
    let path = "Whimsy.flf"
    
    guard let test = try Figlet(fontFile: path) else {
      exit(1)
    }
    
    print(
      test.drawText(text: "Figfont").joined(separator: "\n")
      .attribute(.blinkslow)
      .foreground(.red)
      .resetall)
  }
}
