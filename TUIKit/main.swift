//
//          File:   main.swift
//    Created by:   African Swift

import Darwin
import Foundation

//// WWDC 2016 Logo Example
//Example_WWDCLogo.demo()
//
//// Fig Font Example

//for i in 1...20 {
//  try Example_Figfont.demo()
//}


//for i in 0...100
//{
//  print(Ansi.Window.Report.state())
//  
//  print(Ansi.Window.Report.position())
//
//  print(Ansi.Window.Report.pixelSize())
//
//  print(Ansi.Window.Report.characterTextAreaSize())
//  
//  print(Ansi.Window.Report.characterScreenSize())
//  
//  print(Ansi.Cursor.Report.status())
//}


guard var win = TUIWindow() else { exit(1) }

print(win.origin, win.size)

win.move(x: 50, y: 50)




//Ansi.Window.resize(width: 60, height: 36).stdout()

//Ansi.Window.move(x: 10, y: 10).stdout()

//print("characterScreenSize")
//Ansi.Window.Report.characterScreenSize().stdout()
//print()

//print("characterTextAreaSize")
//Ansi.Window.Report.characterTextAreaSize().stdout()

//print(TUIScreen.size)

//print("characterTextAreaSize")
//Ansi.Window.Report.characterTextAreaSize().stdout()

//
//print("pixelSize")
//Ansi.Window.Report.pixelSize().stdout()
//
//print("position")
//Ansi.Window.Report.position().stdout()


//Ansi.Window.resize(width: 200, height: 200).stdout()


//Ansi.Window.Report.position().stdout()
