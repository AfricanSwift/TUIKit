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
////let text = "ghijkl"
//// Progress bar
//var f = TUIProgress(style: .bar2, percent: 0, status: text)
//
//for p in stride(from: 0.001, to: 1.01, by: 0.01)
//{
//  f.update(p, status: "\(text) \(p)")
//  Thread.sleep(forTimeInterval: 0.01)
//}
//print()

//for s in TUIBarStyle.allCases
//{
//  var bar = s.toTUIBar()
//  let count = bar.gauge.width / 2
//  
//  let complete = bar.gauge.kernFiller == nil ?
//    String(repeating: bar.gauge.complete[0], count: count) :
//    String(repeating: "\(bar.gauge.complete[0])\(bar.gauge.kernFiller ?? " ")", count: count)
//  
//  let incomplete = bar.gauge.kernFiller == nil ?
//    String(repeating: bar.gauge.incomplete, count: count) :
//    String(repeating: "\(bar.gauge.incomplete)\(bar.gauge.kernFiller ?? " ")", count: count)
//
//  let prefix = bar.prefix.character == Character(" ") ? "" : String(bar.prefix.character)
//  let infix = bar.infix.character == Character(" ") ? "" : String(bar.infix.character)
//  let suffix = bar.suffix.character == Character(" ") ? "" : String(bar.suffix.character)
//  print("\(prefix)\(complete)\(infix)\(incomplete)\(suffix)", count)
//}

//for s in TUIBarStyle.allCases
//{
//  var bar = TUIProgress2(style: s, message: "test")
//  bar.increment(by: 50)
//  print(bar.draw())
//}
var output = ""
for index in TUIBarStyle.allCases.indices
{
  var bar = TUIProgress2(style: TUIBarStyle.allCases[index], message: "test")
  bar.increment(by: 50)
//  output += bar.draw() + "\n"
  print(TUIBarStyle.allCases[index], bar.draw())
//  if index >= 25{ break }
}
//output += Ansi.resetAll().toString() + "\n"
//output += Ansi.Set.cursorOff().toString() + "\n"
//try? output.write(toFile: "test.txt", atomically: true, encoding: .utf8)


//bar = TUIProgress2(style: .bar25, message: "test")
//bar.increment(by: 50)
//print(bar.draw())
//
//bar = TUIProgress2(style: .bar26, message: "test")
//bar.increment(by: 50)
//print(bar.draw())

Ansi.resetAll().stdout()
Ansi.Set.cursorOn().stdout()
