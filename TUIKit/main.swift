//
//          File:   main.swift
//    Created by:   African Swift

import Darwin
import Foundation

Ansi.Set.cursorOff().stdout()
//Ansi.Set.cursorOn().stdout()

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

//let text = "a quick movement of enemy would jeopardize six gunboats, 
// all in the event the of the day's incoming action..."
let text = "ghijkl"

var bar = TUIProgress(style: .bar2, message: "Hello world!")

bar.color.complete = Ansi.Color.Foreground.color256(index: 194)

for i in 0...105
{
  bar.advance(message: "Hello world! : \(i)")
  print("\(bar.draw())\r", terminator: "")
  Ansi.flush()
  Thread.sleep(forTimeInterval: 0.01)
}
print()

Ansi.resetAll().stdout()
Ansi.Set.cursorOn().stdout()
