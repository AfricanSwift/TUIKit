//
//          File:   dev-barchart.swift
//    Created by:   African Swift

import Foundation

func alphaBar()
{
  
  func generateRandomColor1() -> Ansi.Color
  {
    let limit = 0.3
    let r = Double(arc4random_uniform(255)) / 255.0
    let g = Double(arc4random_uniform(255)) / 255.0
    let b = Double(arc4random_uniform(255)) / 255.0
    
    func brightenColor(
      _ red: Double,
      green: Double,
      blue: Double) -> (r: Double, g: Double, b: Double)
    {
      return (r: r <= limit ? r + 0.2 : r,
              g: g <= limit ? g + 0.2 : g,
              b: b <= limit ? b + 0.2 : b)
    }
    let part = brightenColor(r, green: g, blue: b)
    return Ansi.Color(red: part.r, green: part.g, blue: part.b, alpha: 1)
  }
  
  func generateRandomColor2() -> Ansi.Color
  {
    let limit = 0.3
    let r = Double(arc4random_uniform(60)) / 255.0
    let g = Double(arc4random_uniform(20)) / 255.0
    let b = Double(arc4random_uniform(40)) / 255.0
    
    func brightenColor(
      _ red: Double,
      green: Double,
      blue: Double) -> (r: Double, g: Double, b: Double)
    {
      return (r: r <= limit ? r + 0.2 : r,
              g: g <= limit ? g + 0.2 : g,
              b: b <= limit ? b + 0.2 : b)
    }
    let part = brightenColor(r, green: g, blue: b)
    return Ansi.Color(red: part.r, green: part.g, blue: part.b, alpha: 1)
  }
  
  func nextColor(color1: Ansi.Color, color2: Ansi.Color, percent: Double) -> Ansi.Color
  {
    let diffRed = color2.RGB.red - color1.RGB.red
    let diffGreen = color2.RGB.green - color1.RGB.green
    let diffBlue = color2.RGB.blue - color1.RGB.blue
    
    let newRed = color1.RGB.red + diffRed * percent
    let newGreen = color1.RGB.green + diffGreen * percent
    let newBlue = color1.RGB.blue + diffBlue * percent
    
    return Ansi.Color(red: newRed, green: newGreen, blue: newBlue, alpha: color1.alpha)
  }
  
  func drawBar(
    x: Int,
    y: Int,
    height: Int,
    width: Int,
    gapWidth: Int,
    percent: Double,
    v: inout TUIView,
    color1: Ansi.Color,
    color2: Ansi.Color)
  {
    let reduce = Int(Double(height) * (1.0 - percent))
    for y in stride(from: 0 + reduce, to: height, by: 1)
    {
      let nc = nextColor(
        color1: color1,
        color2: color2,
        percent: Double(y) / Double(height))
      v.drawLine(from: TUIVec2(x: x, y: y),
                 to: TUIVec2(x: x + width - 1, y: y), color: nc)
    }
  }
  
  guard let wSize = TUIWindow.ttysize() else { exit(EXIT_FAILURE) }
  Ansi.Set.cursorOff().stdout()
  let width = Int(wSize.character.width * 2) - 4
  let height = Int(wSize.character.height * 4) - 8 - 2 - 8
  Ansi.Cursor.column().stdout()
  
  var view = TUIView(x: 0, y: 0, width: width, height: height)
  
  let axisOffset = 8
  let maximum = 60
  let tickInterval = 8
  let axisWidth = 150
  
  view.drawLine(from: TUIVec2(x: axisOffset + 2, y: 0),
                to: TUIVec2(x: axisOffset + 2, y: maximum))
  view.drawLine(from: TUIVec2(x: axisOffset + 2, y: maximum + 1),
                to: TUIVec2(x: axisOffset + 2 + axisWidth, y: maximum + 1))
  
//  for i in stride(from: 0, through: maximum, by: 1)
//  {
//    let tickWidth = i % tickInterval == 0 ? 2 : 0
//    if tickWidth > 0
//    {
//      view.drawLine(from: TUIVec2(x: axisOffset + 2 - tickWidth, y: i + 1),
//                    to: TUIVec2(x: axisOffset + 2, y: i + 1))
//    }
//    if i % tickInterval == 0
//    {
//      let value = String(format: "%3d", maximum - i)
//      
//      view.drawText(x: ((axisOffset + 2 - tickWidth) / 2) - 3,
//                    y: i / 4, text: value,
//                    color: Ansi.Color(red: 0.4, green: 0.2, blue: 0.4, alpha: 1))
//    }
//  }
  
  let color = Ansi.Color(red: 0.6, green: 0.2, blue: 0.4, alpha: 1)
  
  var idx = 0
  
  for i in stride(from: 0, to: axisWidth, by: 16)
  {
    let from = TUIVec2(x: axisOffset + 2 + i, y: maximum + 1)
    let to = TUIVec2(x: axisOffset + 2 + i, y: maximum + 1 + 2)
    view.drawLine(from: from, to: to)
    let text = String(format: "%2d", idx)
    view.drawText(x: Int(to.x) / 2 - 1, y: Int(to.y) / 4 + 1, text: text, color: color)
    idx += 1000
  }
  
  let values = [34, 56, 76, 23, 12, 55, 89, 10]

  for i in values.indices
  {
    let percent = Double(values[i]) / 100
    let reduce = Int(Double(height) * (1.0 - percent))
    let color1 = generateRandomColor1()
    let color2 = generateRandomColor1()
//    for x in stride(from: 0, to: axisWidth - reduce, by: 4)
//    {
//      let rect = TUIRectangle(origin: TUIVec2(x: axisOffset + 2 + x, y: maximum - 4 - (i * 8)),
//                              size: TUISize(width: axisOffset + 2 + axisWidth - reduce - x, height: 3))
//      view.drawRectangle(rect: rect, color: color1)
//    }

    
    for x in stride(from: 0, to: axisWidth - reduce, by: 1)
    {
      let from = TUIVec2(x: axisOffset + 4 + x, y: maximum - 4 - (i * 8))
      let to = TUIVec2(x: axisOffset + 4 + x, y: maximum - 1 - (i * 8))
      let nc = nextColor(color1: color1, color2: color2, percent: Double(x) / Double(width))
      view.drawLine(from: from, to: to, color: nc)
    }
  }
  
  let param = TUIRenderParameter(colorspace: .foreground256, composite: .first, style: .drawille)
  view.draw(parameters: param)
  
  
}

/*
 Features of bar chart
- Border;
   - TUIBorders
   - Drawille
   - None
 
- Graph Axis
   - Style: TUIBorders, Drawille, None
   - Axis Style: Left / Bottom, Right / Bottom, All Sides
   - Ticks: inset, outset, width
   - Tick Interval: Major, Minor
 
- Legend:
   - Position: Top, Bottom, None
   - Border: TUIBorders, Drawille, None

- Bar Type: Horizontal, Vertical, Stacked Horizontal, Stack Vertical

- Bar Character: Drawille, custom

- Render options: bar separate from axis, border and legend

- Value location: Above or Right of bars, below Axis or left of axis, none

- Color: Bar, Border, Legend, Text, Value
 
*/



