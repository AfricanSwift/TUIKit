//
//          File:   dev-triangles.swift
//    Created by:   African Swift


import Foundation


  
func barTest()
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
    for y1 in stride(from: 0 + reduce, to: height, by: 1)
    {
      let nc = nextColor(
        color1: color1,
        color2: color2,
        percent: Double(y1) / Double(height))
      v.drawLine(from: TUIPoint(x: x, y: y1 + y),
                 to: TUIPoint(x: x + width - 1, y: y1 + y), color: nc)
    }
  }
  
  
  
  guard let wSize = TUIWindow.ttysize() else { exit(EXIT_FAILURE) }
  Ansi.Set.cursorOff().stdout()
  let width = Int(wSize.character.width * 2) - 4
  let height = Int(wSize.character.height * 4) - 8 - 2 - 8
  Ansi.Cursor.column().stdout()
  
  var view = TUIView(x: 0, y: 0, width: width, height: height)
  let axisOffset = 8
  let maximum = 76
  let tickInterval = 8
  let axisWidth = 150
  
  view.drawLine(from: TUIPoint(x: axisOffset + 2, y: 0),
                to: TUIPoint(x: axisOffset + 2, y: maximum))
  view.drawLine(from: TUIPoint(x: axisOffset + 2, y: maximum + 1),
                to: TUIPoint(x: axisOffset + 2 + axisWidth, y: maximum + 1))
  
  for i in stride(from: 0, through: maximum, by: 1)
  {
    let tickWidth = i % tickInterval == 0 ? 2 : 0
    if tickWidth > 0
    {
      view.drawLine(from: TUIPoint(x: axisOffset + 2 - tickWidth, y: i + 1),
                    to: TUIPoint(x: axisOffset + 2, y: i + 1))
    }
    if i % tickInterval == 0
    {
      let value = String(format: "%3d", maximum - i)
      
      view.drawText(x: ((axisOffset + 2 - tickWidth) / 2) - 3,
                    y: i / 4, text: value,
                    color: Ansi.Color(red: 0.4, green: 0.2, blue: 0.4, alpha: 1))
    }
  }
  
  for i in stride(from: 0, to: axisWidth, by: 8)
  {
    view.drawLine(from: TUIPoint(x: axisOffset + 2 + i, y: maximum + 1),
                  to: TUIPoint(x: axisOffset + 2 + i, y: maximum + 1 + 2))
  }
  let angle = 135
  let reverse = false
  let color = Ansi.Color(red: 0.7, green: 0.5, blue: 0.2, alpha: 1)
  
  let texts = ["apple", "google", "microsoft", "twitter",
               "facebook", "yahoo", "alphabet", "oracle",
               "adobe", "spacex", "tesla", "github",
               "mozilla", "logix", "realm", "mybroadband"]
  
  for i in 0...(texts.count - 1)
  {
    let x = ((axisOffset + 2 - 2) / 2) + 3 + (4 * i)
    let y = maximum / 4 + 1
    view.drawRotatedText(
      at: TUIPoint(x: x, y: y),
      angle: angle, text: texts[i], reverse: reverse, color: color)
  }
  
  let nwidth = 6
  let nheight = 76
  //  let barQuantity = 8
  let xOffset = 4
  let yOffset = 4
  let gapWidth = 2
  
  let barValues = [43, 32, 12, 16, 64, 18, 17, 11, 6, 9, 0, 54, 83, 32, 56, 12]
  let maxValue = barValues.max()
  
  for idx in barValues.indices
  {
    guard let max = maxValue else { continue }
    let percent = Double(barValues[idx]) / Double(max)
    let barX = xOffset + (idx * nwidth) + (idx * gapWidth)
    drawBar(x: barX + 8, y: 0 + 4, height: nheight - yOffset, width: nwidth,
            gapWidth: gapWidth, percent: percent, v: &view, color1: generateRandomColor1(), color2: generateRandomColor1())
  }
  
  view.draw()
}
