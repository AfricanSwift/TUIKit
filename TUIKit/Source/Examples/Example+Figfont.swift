//
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
    
    for line in test.drawText(text: "Figfont")
    {
      print(Example_WWDCLogo.generateRandomColor() + line)
    }
    print("".resetall)
  }
}
