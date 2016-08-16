//
//          File:   main.swift
//    Created by:   African Swift

//import Darwin
import Foundation


//public class RunLoopDelegate
//{
//  @objc public func run()
//  {
//    let now = Date()
//    print("fired \(now)")
//  }
//}
//
////var testFire = TestFire()
//
//var now = Date()
//var timer = Timer(fireAt: now, interval: 0.01, target: RunLoopDelegate(),
//                  selector: #selector(RunLoopDelegate.run), userInfo: nil, repeats: true)
//
//var runLoop = RunLoop.current()
//runLoop.add(timer, forMode: .defaultRunLoopMode)
//runLoop.run()
///--------------------------------------




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

// Wireframe Wavefront
Ansi.Set.cursorOff().stdout()
try Example.Wavefront.demo()
Thread.sleep(forTimeInterval: 3)
Ansi.Display.Erase.all().stdout()

// Shaded Wavefront
Ansi.Set.cursorOff().stdout()
try Example.Wavefront.demo2()
Thread.sleep(forTimeInterval: 3)
//Ansi.Display.Erase.all().stdout()

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
//v.drawLine(from: TUIVec2(x: 0, y: 0),
//           to: TUIVec2(x: v.size.pixel.width / 3, y: v.size.pixel.height / 3))
//v.drawCircle(center: TUIVec2(x: v.size.pixel.width / 2, y: v.size.pixel.height / 2),
//             radius: v.size.pixel.height / 3)
//v.drawText(at: TUIVec2(x: 0, y: 5), text: "Hello World",
//           color: Ansi.Color(red: 0.6, green: 0.2, blue: 0.4, alpha: 1))
//
//v.drawText(at: TUIVec2(x: 0, y: 7), text: "💊 ⭕️ 🔫 🌝 🌖 🌗 🌘 🌑 🌚 🌒 🌓 🌔 🌝 ",
//           color: Ansi.Color(red: 0.6, green: 0.2, blue: 0.4, alpha: 1))
//
//v.drawAnsiText(x: 0, y: 8, text: "💊 ⭕️ 🔫 🌝 🌖 🌗 🌘 🌑 🌚 🌒 🌓 🌔 🌝 ".attribute(.blinkslow) + " ".attribute(.blinkslowoff))
//v.drawRotatedText(at: TUIVec2(x: 25, y: 12), angle: 90, text: "Quick Move",
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

//for h in stride(from: 0.0, through: 360, by: 15)
//{
//  let c1 = Ansi.Color2(hue: h, saturation: 0.8, lightness: 0.8, alpha: 1)
//  let c2 = c1.invert().shade(by: 0.4)
//  (c1.toAnsiColor().foreground256() + "█████").stdout()
//  (c2.toAnsiColor().foreground256() + "█████").stdout()
//  (c2.toAnsiColor().foreground256() + c1.toAnsiColor().background256() + " Hello World ").stdout()
//  Ansi.Color.resetAll().stdout()
//  for d in stride(from: 0.0, to: 2880.0, by: 30)
//  {
//    (c2.alterHue(by: d).toAnsiColor().foreground256() + "█").stdout()
//  }
//
//  Ansi.Color.resetAll().stdout()
//  print()
//}


//(c3.toAnsiColor().foregroundRGB() + "hello world\n").stdout()

//for i in stride(from: 0, to: 360.0, by: 15)
//{
//  var c2 = Ansi.Color2(hue: i, saturation: 0.5, lightness: 0.5, alpha: 1)
//  ((c2.toAnsiColor().foreground256() + " hello world ") +
//  (c2.complement().toAnsiColor().foreground256() + " hello world\n")).stdout()
//}

//----------------------------------------------------------------

//func randomColor() -> Ansi.Color
//{
//  let limit = 0.3
//  let r = Double(arc4random_uniform(255)) / 255.0
//  let g = Double(arc4random_uniform(255)) / 255.0
//  let b = Double(arc4random_uniform(255)) / 255.0
//  
//  func brightenColor(
//    _ red: Double,
//    green: Double,
//    blue: Double) -> (r: Double, g: Double, b: Double)
//  {
//    return (r: r <= limit ? r + 0.2 : r,
//            g: g <= limit ? g + 0.2 : g,
//            b: b <= limit ? b + 0.2 : b)
//  }
//  let part = brightenColor(r, green: g, blue: b)
//  return Ansi.Color(red: part.r, green: part.g, blue: part.b, alpha: 1)
//}
//
//
//let param = TUIView.Parameter(attribute: .single, invertYAxis: true)
//
////var v = TUIView(x: 0, y: 0, width: 268, height: 284, parameters: param)
//
//var v = TUIView(parameters: param)
//let halfWidth = v.size.pixel.width / 2
//let halfHeight = v.size.pixel.height / 2
//let center = TUIVec2(x: halfWidth - 1, y: halfHeight - 1)
//
//v.drawEllipse(center: center, radiusX: halfWidth - 1, radiusY: (halfHeight - 1) + 20)
//v.drawEllipse(center: center, radiusX: halfWidth - 1 + 20, radiusY: (halfHeight - 1))
//
//let t0 = [TUIVec2(x: 10, y: 70), TUIVec2(x: 50, y: 160), TUIVec2(x: 70, y: 80)]
//let t1 = [TUIVec2(x: 180, y: 50), TUIVec2(x: 150, y: 1), TUIVec2(x: 70, y: 180)]
//let t2 = [TUIVec2(x: 180, y: 150), TUIVec2(x: 120, y: 160), TUIVec2(x: 130, y: 180)]
//
//v.drawTriangle(vectors: t0, color: randomColor())
//v.drawTriangle(vectors: t1, color: randomColor())
//v.drawTriangle(vectors: t2, color: randomColor())
//
//v.draw()

//----------------------------------------------------------------


//devTermios()

//let a = Ansi("\(Ansi.C1.CSI)22q")
//a.stdout()
Ansi.flush()

//Ansi.Terminal.hardReset()

Ansi.resetAll().stdout()

Ansi.Set.cursorOn().stdout()
