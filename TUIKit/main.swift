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


//let c = [Character("⣿")]
//let i = Character(".")
//let cBar = TUIBar(format: [.percent, .space, .text("{"),
//                           .complete(c), .incomplete(i),
//                           .text("}"), .space, .eta, .space,
//                           .elapsed, .space, .remaining, .space, .rate, .message], width: 12)

//let c: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].reversed()
//let i = Character(".")
//let cBar = TUIBar(format: [.percent, .space, .text("<"),
//                           .complete(c), .incomplete(i),
//                           .text(">"), .space, .remaining,
//                           .space, .message], width: 12)

//var bar = TUIProgress(style: .custom(bar: cBar), message: "Hello world!")
//var bar = TUIProgress(style: .bar5, message: "Hello world!")
//
////bar.color.complete = Ansi.Color.Foreground.color256(index: 194)
//bar.style.width = 10
//
//for i in 0...105
//{
//  bar.advance(message: "Hello world! : \(i)")
//  bar.draw()
//  Thread.sleep(forTimeInterval: 0.05)
//}
//print()

let animate: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
let animateFill: Character = "."

let scWidth = 10
let scanner: Character = "#"

let cyWidth = 10
let cylon: Character = "0"

let spinner: [Character] = ["/", "-", "\\",  "|", "/", "-", "\\", "|"]

var cyVal = 0
for i in 0...100
{
  
  print(animate[round(Double(i) / 100) * Double(animate.count)] )
  
  
//  let sc = (0..<cyWidth)
//    .map { $0 == i % cyWidth ? String(scanner) : "." }
//    .joined(separator: "")
//  
//  let cy = (0..<cyWidth)
//    .map { $0 == abs(cyVal - (i % cyWidth)) ? String(cylon) : "." }
//    .joined(separator: "")
//  if i % cyWidth == 9
//  {
//    cyVal = (cyVal == 9 ? 0 : 9)
//  }
//  let c = spinner.count
//  print("\(spinner[i % c])  \(cy)  \(sc)\r", terminator: "")
//  Ansi.flush()
//  Thread.sleep(forTimeInterval: 0.05)
}


//for c in spinner
//{
//  print("\(c)\r", terminator: "")
//  Ansi.flush()
//  Thread.sleep(forTimeInterval: 0.3)
//}

Ansi.resetAll().stdout()
Ansi.Set.cursorOn().stdout()

