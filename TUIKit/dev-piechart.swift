//
//          File:   dev-piechart.swift
//    Created by:   African Swift

import Foundation

func alphaPie()
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
  
  guard let wSize = TUIWindow.ttysize() else { exit(EXIT_FAILURE) }
  Ansi.Set.cursorOff().stdout()
  let width = Int(wSize.character.width * 2) - 4
  let height = Int(wSize.character.height * 4) - 8 - 2 - 8
  Ansi.Cursor.column().stdout()
  
  var view = TUIView(x: 0, y: 1, width: width, height: height)
  
  let radius = 30.0
  let fill = true
  var interval = 0
  var yOutset = 4
  var xOutset = 4
  var increment = 1
  var styleIndex = 0
  
  while interval < 512
  {
    view.drawPieSlice(center: TUIVec2(x: width / 2, y: height / 2 - yOutset), radius: radius,
                      startAngle: 0, endAngle: 45, color: generateRandomColor1(), fill: fill)
    
    view.drawPieSlice(center: TUIVec2(x: width / 2 + xOutset, y: height / 2 - yOutset / 2), radius: radius,
                      startAngle: 45, endAngle: 90, color: generateRandomColor1(), fill: fill)
    
    view.drawPieSlice(center: TUIVec2(x: width / 2 + xOutset, y: height / 2 + yOutset / 2), radius: radius,
                      startAngle: 90, endAngle: 135, color: generateRandomColor1(), fill: fill)
    
    view.drawPieSlice(center: TUIVec2(x: width / 2, y: height / 2 + yOutset), radius: radius,
                      startAngle: 135, endAngle: 180, color: generateRandomColor1(), fill: fill)
    
    view.drawPieSlice(center: TUIVec2(x: width / 2 - xOutset, y: height / 2 + yOutset), radius: radius,
                      startAngle: 180, endAngle: 225, color: generateRandomColor1(), fill: fill)
    
    view.drawPieSlice(center: TUIVec2(x: width / 2 - xOutset - xOutset, y: height / 2 + yOutset / 2), radius: radius,
                      startAngle: 225, endAngle: 270, color: generateRandomColor1(), fill: fill)
    
    view.drawPieSlice(center: TUIVec2(x: width / 2 - xOutset - xOutset, y: height / 2 - yOutset / 2), radius: radius,
                      startAngle: 270, endAngle: 315, color: generateRandomColor1(), fill: fill)
    
    view.drawPieSlice(center: TUIVec2(x: width / 2 - xOutset, y: height / 2 - yOutset), radius: radius,
                      startAngle: 315, endAngle: 360, color: generateRandomColor1(), fill: fill)
    
    if styleIndex > RenderStyle.allCases.count - 1 { styleIndex = 0 }
    let param = TUIRenderParameter(colorspace: .foreground256, composite: .first,
                                 style: RenderStyle.allCases[styleIndex])
    view.draw(atOrigin: true, parameters: param)
    xOutset += increment
    yOutset += increment
    if xOutset >= 20
    {
      increment = -1
      styleIndex += 1
    }
    
    if xOutset <= 2
    {
      increment = 1
    }
    interval += 1
//    Thread.sleep(forTimeInterval: 0.001)
    view.clear()
  }

  
}
