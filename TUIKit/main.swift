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


var view = TUIView(x: 0, y: 0, width: 200, height: 100, border: .none)
view.drawSquare(point: TUIPoint(x: 0, y: 0), width: 50)


let renderparm = TUIRenderParameter(
  colorspace: .foreground256,
  composite: .first,
  style: .drawille)
Ansi.Cursor.position(
  row: view.origin.y.toInt(),
  column: view.origin.x.toInt()).stdout()
print(view.draw(parameters: renderparm).map { $0.toString() }.joined(separator: "\n"))
