//
//          File:   TUITable.swift
//    Created by:   African Swift

import Darwin

public struct TUITable
{
  /// Progress view
//  private var view: TUIView
  public var value = ""
  
  public init(_ v: [String])
  {
    let width = maxWidth(v)
    guard let box = TUIBorder.single.toTUIBox() else { exit(EXIT_FAILURE) }
    
    let topMiddle = String(repeating: box.horizontal.top, count: width + 2)
    let middleMiddle = String(repeating: box.horizontal.middle, count: width + 2)
    let bottomMiddle = String(repeating: box.horizontal.bottom, count: width + 2)
    let top = "\(box.top.left)\(topMiddle)\(box.top.right)\n"
    let middle = "\(box.middle.left)\(middleMiddle)\(box.middle.right)\n"
    let bottom = "\(box.bottom.left)\(bottomMiddle)\(box.bottom.right)\n"
    
    self.value += top
    self.value += v
      .map { text in
        var result = String(box.vertical.left) + " "
        result += String(text).padding(toLength: width, withPad: " ", startingAt: 0)
        result += " " + String(box.vertical.right)
        return result }
      .joined(separator: "\n\(middle)")
    self.value += "\n\(bottom)"
    
  }
  
  public init (_ v: [[String]])
  {
    var widths = Array<Int>(repeating: 0, count: v[0].count)
    guard let box = TUIBorder.single.toTUIBox() else { exit(EXIT_FAILURE) }
    
    for c in 0..<v[0].count
    {
      var width = 0
      for r in 0..<v.count
      {
        let count = v[r][c].characters.count
        if count > width { width = count }
      }
      widths[c] = width
    }
    
    var top = "\(box.top.left)"
    var bottom = "\(box.bottom.left)"
    var middle = "\(box.middle.left)"
    for c in 0..<v[0].count
    {
      top += String(repeating: box.horizontal.top, count: widths[c] + 2)
      if c < v[0].count - 1 {
        top += "\(box.top.middle)"
      }
      bottom += String(repeating: box.horizontal.bottom, count: widths[c] + 2)
      if c < v[0].count - 1 {
        bottom += "\(box.bottom.middle)"
      }
      middle += String(repeating: box.horizontal.middle, count: widths[c] + 2)
      if c < v[0].count - 1 {
        middle += "\(box.middle.middle)"
      }
      
    }
    top += "\(box.top.right)"
    bottom += "\(box.bottom.right)"
    middle += "\(box.middle.right)"
    
    var data = ""
    for r in 0..<v.count
    {
      data += "\(box.vertical.left)"
      for c in 0..<v[0].count
      {
        data += " " + String(v[r][c]).padding(toLength: widths[c], withPad: " ", startingAt: 0) + " "
        if c < v[0].count - 1 {
          data += "\(box.vertical.middle)"
        }
      }
      data += "\(box.vertical.right)\n"
      if r < v.count - 1 {
        data += "\(middle)\n"
      }
    }
    
    let result = "\(top)\n\(data)\(bottom)\n"
    
    print(result)
  }
  
  func maxWidth(_ values: [String]) -> Int
  {
    var width = 0
    for v in values
    {
      let count = v.characters.count
      if count > width { width = count }
    }
    return width
  }
  
  
  
}
