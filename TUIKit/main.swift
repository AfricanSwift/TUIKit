//
//          File:   main.swift
//    Created by:   African Swift

import Darwin
import Foundation

Ansi.Set.cursorOff().stdout()

//// WWDC 2016 Logo Example
//Example.WWDC.demo()
//Ansi.Display.Erase.all().stdout()
//
//// Fig Font Example
//try Example.Figfont.demo()
//Ansi.Display.Erase.all().stdout()
//
//// Demo of line graphics
//Example.LineGraphics.demo()
//Ansi.Display.Erase.all().stdout()
//
//// Random views
//Example.RandomViews.demo()

for p in stride(from: 0.001, to: 1.0, by: 0.001)
{
  Ansi.Cursor.position(row: 1, column: 1).stdout()
  for style in TUIProgressStyle.allCases
  {
    var bar = TUIProgress(style: style, percent: round(p * 10) / 10, status: "hello world... \(p)".foreground(.white))
    bar.draw()
    print("")
  }
  Thread.sleep(forTimeInterval: 0.01)
//  Ansi.Display.Erase.all().stdout()
//  Ansi.Cursor.position().stdout()
}


Ansi.Set.cursorOn().stdout()
