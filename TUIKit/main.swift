//
//          File:   main.swift
//    Created by:   African Swift

//import Darwin
import Foundation

// WWDC 2016 Logo Example
Ansi.Set.cursorOff().stdout()
Example.WWDC.demo()
Ansi.Display.Erase.all().stdout()

// Fig Font Example
Ansi.Set.cursorOff().stdout()
try Example.Figfont.demo()
Thread.sleep(forTimeInterval: 2)
Ansi.Display.Erase.all().stdout()

// Demo of line graphics
Ansi.Set.cursorOff().stdout()
Example.LineGraphics.demo()
Thread.sleep(forTimeInterval: 1)
Ansi.Display.Erase.all().stdout()

// Random views
Ansi.Set.cursorOff().stdout()
Example.RandomViews.demo()
Thread.sleep(forTimeInterval: 1)
Ansi.Display.Erase.all().stdout()

// ProgressBars
Ansi.Set.cursorOff().stdout()
Ansi.Cursor.position().stdout()
Example.ProgressBars.demo()
Thread.sleep(forTimeInterval: 1)
print()
Ansi.Display.Erase.all().stdout()

// Wavefront
Ansi.Set.cursorOff().stdout()
try Example.Wavefront.demo()
Thread.sleep(forTimeInterval: 3)
Ansi.Display.Erase.all().stdout()

//alphaCode()
//Thread.sleep(forTimeInterval: 2)
//alphaBar()
//Thread.sleep(forTimeInterval: 2)
//barTest()
//
//alphaPie()

//print("apple")
//print("\(Ansi.C0.ESC)#3Big TITLE 😀 ❤️ ")
//print("\(Ansi.C0.ESC)#4Big TITLE 😀 ❤️ ")
//print("\(Ansi.C0.ESC)#5small title")
//print("\(Ansi.C0.ESC)#3████████░░░░░░░░")
//print("\(Ansi.C0.ESC)#4████████░░░░░░░░")
//print("yahoo")
//print("\(Ansi.C0.ESC)#6Wide Title", terminator: "")
//print(" alphabet 😀 ❤️ ".foreground(.red).resetall)
//print("yahoo")
//print("\(Ansi.C0.ESC)#3⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤💊 ⭕️ 🔫 🌝 🌖 🌗 🌘 🌑 🌚 🌒 🌓 🌔 🌝 ")
//print("\(Ansi.C0.ESC)#4⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤💊 ⭕️ 🔫 🌝 🌖 🌗 🌘 🌑 🌚 🌒 🌓 🌔 🌝 ")
//print("⠤⠤⠤⠤")
//print("⠤⠤⠤⠤⠤⠤⠤⠤")
//print("⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤")
//print("⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤")

//let text = "Hello World!"
//let fixed = String(repeating: " ", count: 20)
//var backVar = 40
//var frontVar = 10
//var increment = 1
//for i in stride(from: 0, to: 200, by: 1)
//{
//  Ansi.Cursor.position(row: 3, column: 1).stdout()
//  Ansi.Line.Erase.right().stdout()
//  Ansi.Cursor.position(row: 2, column: 1).stdout()
//  Ansi.Line.Erase.right().stdout()
//  let front = String(repeating: " ", count: frontVar) + text
//  let back = String(repeating: " ", count: backVar - frontVar) + text
//  print(back + Ansi.Line.Attributes.Height.topHalf())
//  print(front + Ansi.Line.Attributes.Height.bottomHalf())
//  Thread.sleep(forTimeInterval: 0.02)
//  frontVar += increment
//  if frontVar > 20 { increment = -1; Thread.sleep(forTimeInterval: 0.2) }
//  if frontVar <= 10 { increment = 1 }
//}
//print()
//print()


/// ------
//var v = TUIView(parameters: TUIView.Parameter(attribute: .heightx2))
//
//v.drawLine(from: TUIPoint(x: 0, y: 0),
//           to: TUIPoint(x: v.size.pixel.width / 3, y: v.size.pixel.height / 3))
//v.drawCircle(center: TUIPoint(x: v.size.pixel.width / 2, y: v.size.pixel.height / 2),
//             radius: v.size.pixel.height / 3)
//v.drawText(at: TUIPoint(x: 0, y: 5), text: "Hello World",
//           color: Ansi.Color(red: 0.6, green: 0.2, blue: 0.4, alpha: 1))
//
//v.drawText(at: TUIPoint(x: 0, y: 7), text: "💊 ⭕️ 🔫 🌝 🌖 🌗 🌘 🌑 🌚 🌒 🌓 🌔 🌝 ",
//           color: Ansi.Color(red: 0.6, green: 0.2, blue: 0.4, alpha: 1))
//
//v.drawAnsiText(x: 0, y: 8, text: "💊 ⭕️ 🔫 🌝 🌖 🌗 🌘 🌑 🌚 🌒 🌓 🌔 🌝 ".attribute(.blinkslow) + " ".attribute(.blinkslowoff))
//v.drawRotatedText(at: TUIPoint(x: 25, y: 12), angle: 90, text: "Quick Move",
//                  color: Ansi.Color(red: 0.4, green: 1, blue: 0.5, alpha: 1))
//v.draw()

/// ---------------------
//print(String(cString: getenv("TERM")))
//Ansi.Set.sendMouseXYOnButtonPressX11On().stdout()
//Ansi.Set.sgrMouseModeOn().stdout()
//Ansi.flush()
//Thread.sleep(forTimeInterval: 10)
//Ansi.Set.sendMouseXYOnButtonPressX11Off().stdout()
//Ansi.Set.sgrMouseModeOff().stdout()
/// ---------------------


//devTermios()

//Ansi.Terminal.hardReset()

Ansi.resetAll().stdout()

Ansi.Set.cursorOn().stdout()
