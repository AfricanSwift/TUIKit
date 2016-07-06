//
//          File:   main.swift
//    Created by:   African Swift

import Darwin
import Foundation

//// WWDC 2016 Logo Example
//Example_WWDCLogo.demo()

//// Fig Font Example
//for i in 1...20 {
//  try Example_Figfont.demo()
//}

/// Demo of line graphics
//Example_LineGraphics.demo()

//print(Ansi.Window.Report.characterTextAreaSize())

//

//Ansi.resetAll().stdout()


func draw(view: inout TUIView)
{
  var y = Int(view.origin.y)
  var x = Int(view.origin.x)
  
  func nextPos()
  {
    Ansi.Cursor.position(row: y, column: x).stdout()
    y += 1
  }
  
//  var validBorder = true
//  if case .none = view.border
//  {
//    validBorder = false
//  }
//  
//  let left = validBorder ? view.borderParts.left : ""
//  let right = validBorder ? view.borderParts.right : ""
//  
//  if validBorder
//  {
//    nextPos()
//    print(view.borderParts.top)
//  }
  
  for line in view.draw()
  {
    nextPos()
//    (left + view.backgroundColor + line + right + "\n").stdout()
    line.stdout()
  }
  
//  if validBorder
//  {
//    nextPos()
//    print(view.borderParts.bottom)
//  }
  Ansi.resetAll().stdout()
}

Ansi.Set.cursorOff().stdout()
let currentPos = Ansi.Cursor.Report.position() ?? TUIPoint(x: -1, y: -1)
let color1 = Ansi.Color.Foreground.white()
  + Ansi.Color.Background.colorRGB256(red: 75, green: 25, blue: 50)
let color2 = Ansi.Color.Background.color256(index: 17)
var view = TUIView(x: 10, y: 6, width: 50, height: 50, border: .single,
                   borderColor: color1, backgroundColor: color2)
let midY = view.size.pixel.height / 2
let midX = view.size.pixel.width / 2
let center = TUIPoint(x: midX, y: midY)

let rect = TUIRectangle(x: 1, y: 1, width: 40, height: 40)
for i in stride(from: 1.0, through: 40.0, by: 10)
{
//  view.drawEllipse(center: center, radiusX: midX - i, radiusY: midX - i)
  view.drawRoundedRectangle(rect: rect, radius: i)
}

//view.draw().forEach { $0.stdout() }

let s = Ansi.Window.Report.characterTextAreaSize() ?? TUISize(width: 40, height: 20)

for i in 0...1000
{
  let x = Int(arc4random_uniform(UInt32(s.width - view.size.character.width - 1)))
  let y = Int(arc4random_uniform(UInt32(s.height - view.size.character.height - 1)))
  view.move(x: x, y: y)
  draw(view: &view)
}

//if currentPos.x != -1
//{
//  Ansi.Cursor.position(row: Int(currentPos.y), column: Int(currentPos.x)).stdout()
//}
Ansi.resetAll().stdout()
Ansi.Set.cursorOn().stdout()
