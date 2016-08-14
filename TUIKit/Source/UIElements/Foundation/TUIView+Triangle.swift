//
//          File:   TUIView+Triangle.swift
//    Created by:   African Swift

import Darwin

//// MARK: -
//// MARK: Draw Triangle -
public extension TUIView
{
  
  /// Draw Triangle
  ///
  /// - parameters:
  ///   - vectors: Array of TUIVec2 (1st three values are used)
  ///   - color: Ansi.Color (Optional, default is white)
  public mutating func drawTriangle(
    vectors v: [TUIVec2],
    fill: Bool = true,
    color: Ansi.Color = Ansi.Color(red: 1, green: 1, blue: 1, alpha: 1),
    action: TUICharacter.SetAction = .on)
  {
    guard v.count >= 3 else { return }
    self.drawTriangle(vector1: v[0], vector2: v[1], vector3: v[2], fill: fill,
                      color: color, action: action)
  }
  
  
  /// Draw Triangle
  ///
  /// - parameters:
  ///   - vector0: 1st TUIVec2 vector
  ///   - vector1: 2nd TUIVec2 vector
  ///   - vector2: 3rd TUIVec2 vector
  ///   - color: Ansi.Color (Optional, default is white)
  public mutating func drawTriangle(
    vector1 v0: TUIVec2,
    vector2 v1: TUIVec2,
    vector3 v2: TUIVec2,
    fill: Bool = true,
    color: Ansi.Color = Ansi.Color(red: 1, green: 1, blue: 1, alpha: 1),
    action: TUICharacter.SetAction = .on)
  {
    // Don't draw degenerate triangles
    guard v0.y != v1.y && v0.y != v2.y else { return }
   
    var v0 = v0, v1 = v1, v2 = v2
    
    // Sort vertices by their .y coordinates
    if v0.y > v1.y
    {
      swap(&v0, &v1)
    }
    
    if v0.y > v2.y
    {
      swap(&v0, &v2)
    }
    
    if v1.y > v2.y
    {
      swap(&v1, &v2)
    }
    
    // Draw unfilled triangle
    if !fill
    {
      self.drawLine(from: v0, to: v1, color: color, action: action)
      self.drawLine(from: v1, to: v2, color: color, action: action)
      self.drawLine(from: v2, to: v0, color: color, action: action)
      return
    }
    
    // Draw filled triangle
    let height = Int(v2.y - v0.y)
    for i in 0..<height
    {
      let secondHalf = i > Int(v1.y) - Int(v0.y) || Int(v1.y) == Int(v0.y)
      let segmentHeight = secondHalf ? v2.y - v1.y : v1.y - v0.y
      let alpha = Double(i) / Double(height)
     
      // cautionary: that above conditions don't result in divide by zero here
      let beta  = (Double(i) - (secondHalf ? v1.y - v0.y : 0.0)) / segmentHeight
      
      var A = v0 + (v2 - v0) * alpha
      var B = secondHalf ? v1 + (v2 - v1) * beta : v0 + (v1 - v0) * beta
      if A.x > B.x
      {
        swap(&A, &B)
      }
      
      for j in Int(A.x)..<Int(B.x)
      {
        // Note, due to int casts v0.y + i != A.y
        self.drawPixel(x: Double(j), y: v0.y + Double(i), color: color, action: action)
      }
    }
  }
}
