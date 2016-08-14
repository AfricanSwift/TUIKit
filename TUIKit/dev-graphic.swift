//
//          File:   main2.swift
//    Created by:   African Swift

import Darwin

//var t = TUITable(["abc", "mnopqrs", "xdefg 1234567", "hijkl", "a quick movement of the enemy"])
//print(t.value)
//
//
//var u = TUITable([["def", "12345", "a quick movement"],
//                  ["banana bunch", "zebra colony", "675"],
//                  ["apple pear orange", "dictate", "derk"]])




//// text to multi column
//let path = "/Users/VW/Desktop/testtv.txt"
//let tv = try String(contentsOfFile: path, encoding: .utf8)
//let lines = tv.characters
//  .split(separator: "\n", omittingEmptySubsequences: false)
//  .map { String($0) }.sorted()
//
//
//let third = Int(round(Double(lines.count) / 3))
//var array = init2D(d1: third + 1, d2: 3, repeatedValue: "")
//
//var r = 0
//var c = 0
//for line in lines
//{
//  if r == array.count {
//    r = 0
//    c += 1
//  }
//  array[r][c] = line
//  r += 1
//}
//
//
//var t = TUITable(array)
//print(t.value)

//public extension CountableClosedRange where Bound : Comparable
//{
//  public func isRange(within: CountableClosedRange) -> Bool
//  {
//    guard self.lowerBound >= within.lowerBound && self.upperBound <= within.upperBound
//      else { return false }
//    return true
//  }
//}


// --------------------------------------------------------

public extension ClosedRange where Bound : Comparable
{
  public func isRange(within: ClosedRange) -> Bool
  {
    guard self.lowerBound >= within.lowerBound && self.upperBound <= within.upperBound
      else { return false }
    return true
  }
}

private struct EllipseIterator
{
  private let center: TUIVec2
  private let square: TUISize
  private let square4: TUISize
  private var point1: TUIVec2
  private var point2: TUIVec2
  private var sigma1: Int
  private var sigma2: Int
  private let arc: ClosedRange<Int>

  private init(center: TUIVec2, size: TUISize, arc: ClosedRange<Int>)
  {
    self.center = center
    self.arc = arc
    self.square = TUISize(width: size.width * size.width, height: size.height * size.height)
    self.square4 = TUISize(width: square.width * 4, height: square.height * 4)
    self.point1 = TUIVec2(x: 0, y: size.height)
    self.point2 = TUIVec2(x: size.width, y: 0)
    self.sigma1 = 2 * Int(square.height) + Int(square.width) * (1 - 2 * Int(size.height))
    self.sigma2 = 2 * Int(square.width) + Int(square.height) * (1 - 2 * Int(size.width))
  }

  private func calcQuads(at: TUIVec2) -> [(ClosedRange<Int>, ClosedRange<Int>, Int, Int)]
  {
    let c = (x: Int(self.center.x), y: Int(self.center.y))
    let x = Int(at.x)
    let y = Int(at.y)
    return [(0...45, 45...90, c.x + x, c.y - y),
            (135...180, 90...135, c.x + x, c.y + y),
            (180...225, 225...270, c.x - x, c.y + y),
            (315...360, 270...315, c.x - x, c.y - y)]
  }
}

private extension EllipseIterator
{
  mutating func calcResult1(result: inout [TUIVec2])
  {
    result = calcQuads(at: point1).flatMap {
      return $0.0.isRange(within: self.arc) ? TUIVec2(x: $0.2, y: $0.3) : nil
    }

    if self.sigma1 >= 0
    {
      self.sigma1 += Int(self.square4.width) * (1 - Int(self.point1.y))
      self.point1.y -= 1
    }
    self.sigma1 += Int(self.square.height) * ((4 * Int(self.point1.x)) + 6)
    self.point1.x += 1
  }

  mutating func calcResult2(result: inout [TUIVec2], check1: Bool)
  {
    let quads2 = calcQuads(at: point2).flatMap {
      return $0.1.isRange(within: self.arc) ? TUIVec2(x: $0.2, y: $0.3) : nil
    }
    result = check1 ? result + quads2 : quads2

    if self.sigma2 >= 0
    {
      self.sigma2 += Int(square4.height) * (1 - Int(self.point2.x))
      self.point2.x -= 1
    }
    self.sigma2 += Int(square.width) * ((4 * Int(self.point2.y)) + 6)
    self.point2.y += 1
  }
}


extension EllipseIterator: IteratorProtocol
{
  mutating func next() -> [TUIVec2]?
  {
    var result = [TUIVec2()]
    let check1 = Int(self.square.height * self.point1.x) <= Int(self.square.width * self.point1.y)
    let check2 = Int(square.width * self.point2.y) <= Int(self.square.height * self.point2.x)

    // Stop when checks fails
    guard check1 || check2 else { return nil }

    // First call of ellipse quads
    if check1
    {
      calcResult1(result: &result)
    }

    // Second call of ellipse quads
    if check2
    {
      calcResult2(result: &result, check1: check1)
    }
    return result
  }
}

func drawEllipse(center: TUIVec2, size: TUISize, arc: ClosedRange<Int>,
                 view: inout TUIView, fill: Bool = false)
{
  let color = Ansi.Color(red: 0.6, green: 0.2, blue: 0.4, alpha: 1)
  var ellipse = EllipseIterator(center: center, size: size, arc: arc)
  while let point = ellipse.next()
  {
    point.forEach {
      _ = fill ? view.drawLine(from: center, to: $0, color: color) :
        view.drawPixel(at: $0, color: color)
    }
  }
}

func drawCircle(center: TUIVec2, radius: Double, arc: ClosedRange<Int>,
                view: inout TUIView, fill: Bool = false)
{
  let size = TUISize(width: radius, height: radius)
  drawEllipse(center: center, size: size, arc: arc, view: &view, fill: fill)
}

// --------------------------------------------------------
//guard let wSize = TUIWindow.ttysize() else { exit(EXIT_FAILURE) }
//
//Ansi.Set.cursorOff().stdout()
//
//let width = Int(wSize.character.width * 2) - 4
//let height = Int(wSize.character.height * 4) - 8 - 2 - 8
//let radius = min(width / 2, height / 2)
//Ansi.Cursor.column().stdout()
//
//var view = TUIView(x: 0, y: 0, width: width, height: height)
//let center = TUIVec2(x: width / 2, y: height / 2)
//
//var size = TUISize(width: width / 2 - 1, height: height / 2 - 2)
//
//let color = Ansi.Color(red: 0.6, green: 0.2, blue: 0.4, alpha: 1)
//
//
//for i in stride(from: 5, to: width / 2 - 2, by: 15)
//{
//  size = TUISize(width: i, height: height / 2 - 2)
//  drawEllipse(center: center, size: size, arc: 0...180, view: &view)
//}
//
//for i in stride(from: 5, to: height / 2 - 2, by: 15)
//{
//  size = TUISize(width: width / 2 - 2, height: i)
//  drawEllipse(center: center, size: size, arc: 90...270, view: &view)
//}
// --------------------------------------------------------

//let rect = TUIRectangle(x: 0, y: 0, width: 199, height: 99)
//
//view.drawRoundedRectangle(rect: rect, radius: 20)
//
//view.drawRectangle(rect: rect)
//let rect2 = TUIRectangle(x: 1, y: 1, width: 197, height: 97)
//view.drawRectangle(rect: rect2)
//let lines = [
//  (from: TUIVec2(x: 0, y: 0), to: TUIVec2(x: 0, y: 99)),
//  (from: TUIVec2(x: 0, y: 0), to: TUIVec2(x: 199, y: 0)),
//  (from: TUIVec2(x: 199, y: 0), to: TUIVec2(x: 199, y: 99)),
//  (from: TUIVec2(x: 0, y: 99), to: TUIVec2(x: 199, y: 99)),
//  (from: TUIVec2(x: 0, y: 0), to: TUIVec2(x: 199, y: 99)),
//  (from: TUIVec2(x: 0, y: 99), to: TUIVec2(x: 199, y: 0))]
//
//lines.forEach {
//  view.drawLine(from: $0.from, to: $0.to)
//}


//func plotLine(view: inout TUIView, from f: TUIVec2, to t: TUIVec2)
//{
//  let color = Ansi.Color(red: 0.6, green: 0.2, blue: 0.4, alpha: 1.0)
//  var from = (x: Int(f.x), y: Int(f.y))
//  let to = (x: Int(t.x), y: Int(t.y))
//  let distance = (x: abs(to.x - from.x), y: -abs(to.y - from.y))
//  let slope = (x: from.x < to.x ? 1 : -1, y: from.y < to.y ? 1 : -1)
//  var error1 = distance.x + distance.y
//
//  while true
//  {
//    view.drawPixel(x: from.x, y: from.y, color: color)
//    let error2 = 2 * error1
//
//    if error2 >= distance.y
//    {
//      if from.x == to.x
//      {
//        break
//      }
//      error1 += distance.y
//      from.x += slope.x
//    }
//
//    if error2 <= distance.x
//    {
//      if from.y == to.y
//      {
//        break
//      }
//      error1 += distance.x
//      from.y += slope.y
//    }
//  }
//}

//func plotEllipse(view: inout TUIView, center c: TUIVec2, size: TUISize)
//{
//  let radius = (width: Int(size.width), height: Int(size.height))
//  let color = Ansi.Color(red: 0.6, green: 0.2, blue: 0.4, alpha: 1.0)
//  let center = (x: Int(c.x), y: Int(c.y))
//  var x = -radius.width
//  var y = 0
//  var error2 = radius.height * radius.height
//  var error1 = x * (2 * error2 + x) + error2
//
//  repeat
//  {
//    view.drawPixel(x: center.x - x, y: center.y + y, color: color)
//    view.drawPixel(x: center.x + x, y: center.y + y, color: color)
//    view.drawPixel(x: center.x + x, y: center.y - y, color: color)
//    view.drawPixel(x: center.x - x, y: center.y - y, color: color)
//    error2 = 2 * error1
//    if error2 >= (x * 2 + 1) * radius.height * radius.height
//    {
//      x += 1
//      error1 += (x * 2 + 1) * radius.height * radius.height
//    }
//    if error2 <= (y * 2 + 1) * radius.width * radius.width
//    {
//      y += 1
//      error1 += (y * 2 + 1) * radius.width * radius.width
//    }
//  } while x <= 0
//
//  /* -> finish tip of ellipse */
////  while y < radius.height
////  {
////    view.drawPixel(x: center.x, y: center.y + y, color: color)
////    view.drawPixel(x: center.x, y: center.y - y, color: color)
////    y += 1
////  }
//}

func plotCircle(view: inout TUIView, center c: TUIVec2, radius: Int)
{
  let color = Ansi.Color(red: 0.6, green: 0.2, blue: 0.4, alpha: 1.0)
  let center = (x: Int(c.x), y: Int(c.y))
  var radius = radius
  var x = -radius
  var y = 0
  var error1 = 2 - 2 * radius      /* bottom left to top right */
  repeat
  {
    view.drawPixel(x: center.x - x, y: center.y + y, color: color)   /*   I. Quadrant +x +y */
    view.drawPixel(x: center.x - y, y: center.y - x, color: color)   /*  II. Quadrant -x +y */
    view.drawPixel(x: center.x + x, y: center.y - y, color: color)   /* III. Quadrant -x -y */
    view.drawPixel(x: center.x + y, y: center.y + x, color: color)   /*  IV. Quadrant +x -y */
    radius = error1
    if radius <= y
    {
      y += 1
      error1 += y * 2 + 1                             /* e_xy+e_y < 0 */
    }
    if radius > x || error1 > y                  /* e_xy+e_x > 0 or no 2nd y-step */
    {
      x += 1
      error1 += x * 2 + 1                                     /* -> x-step now */
    }
  } while x < 0
}

func alphaCode()
{
  guard let wSize = TUIWindow.ttysize() else { exit(EXIT_FAILURE) }
  Ansi.Set.cursorOff().stdout()
  let width = Int(wSize.character.width * 2) - 4
  let height = Int(wSize.character.height * 4) - 8 - 2 - 8
  let radius = min(width / 2, height / 2)
  Ansi.Cursor.column().stdout()
  
  var view = TUIView(x: 0, y: 0, width: width, height: height)
  let center = TUIVec2(x: width / 2, y: height / 2)
  let center2 = TUIVec2(x: width / 2 + 4, y: height / 2 + 4)
  
  var size = TUISize(width: width / 2 - 1, height: height / 2 - 2)
  
  let color = Ansi.Color(red: 0.6, green: 0.2, blue: 0.4, alpha: 1)
  
  plotCircle(view: &view, center: center, radius: 16)
  plotCircle(view: &view, center: center, radius: 17)
  plotCircle(view: &view, center: center, radius: 18)
  plotCircle(view: &view, center: center, radius: 19)
  plotCircle(view: &view, center: center, radius: 20)
  plotCircle(view: &view, center: center, radius: 21)
  plotCircle(view: &view, center: center, radius: 40)
  plotCircle(view: &view, center: center, radius: 41)
  plotCircle(view: &view, center: center, radius: 42)
  plotCircle(view: &view, center: center, radius: 53)
  plotCircle(view: &view, center: center, radius: 54)
  plotCircle(view: &view, center: center, radius: 58)
  plotCircle(view: &view, center: center, radius: 59)
  plotCircle(view: &view, center: center, radius: 60)
  
//  for i in stride(from: 5, to: width / 2 - 2, by: 15)
//  {
//    size = TUISize(width: i, height: height / 2 - 2)
//    drawEllipse(center: center, size: size, arc: 0...360, view: &view)
//  }
//  
//  for i in stride(from: 5, to: height / 2 - 2, by: 15)
//  {
//    size = TUISize(width: width / 2 - 2, height: i)
//    drawEllipse(center: center, size: size, arc: 0...360, view: &view)
//  }
  
  let param = TUIRenderParameter(colorspace: .foreground256, composite: .first, style: .drawille)
  view.draw(parameters: param)
}
