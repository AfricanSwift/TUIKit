//
//          File:   Example+RandomViews.swift
//    Created by:   African Swift

import Foundation

public extension Example
{
  public struct Wavefront
  {
    struct Vertice
    {
      let x: Double
      let y: Double
      let z: Double
      
      init(_ line: String)
      {
        let values: [Double] = line.characters.split(separator: " ")
          .flatMap {
            let value = String($0)
            if value.hasPrefix("v") { return nil }
            return Double(value)
        }
        self.x = values[0]
        self.y = values[1]
        self.z = values[2]
      }
    }
    
    struct Indices
    {
      let x: Int
      let y: Int
      let z: Int
      
      init(_ v: String)
      {
        let vertices = v.characters
          .split(separator: "/", omittingEmptySubsequences: false)
          .map { String($0) }
        self.x = Int(vertices[0]) ?? -1
        self.y = Int(vertices[1]) ?? -1
        self.z = Int(vertices[2]) ?? -1
      }
    }
    
    struct Polygon
    {
      var indices: [Indices]
      
      init(_ line: String)
      {
        let indices: [Indices] = line.characters
          .split(separator: " ", omittingEmptySubsequences: false).flatMap {
            let v = String($0)
            if v.hasPrefix("f") { return nil }
            return Indices(v)
        }
        self.indices = indices
      }
    }
    
    public static func demo() throws
    {
      Ansi.Set.cursorOff().stdout()
      Ansi.Cursor.column().stdout()
      guard let wSize = TUIWindow.ttysize() else { exit(EXIT_FAILURE) }
      
      let width = Int(wSize.character.width * 2) - 4
      let height = Int(wSize.character.height * 4) - 8 - 2 - 8
      var view = TUIView(x: 0, y: 0, width: width, height: height)
      let center = TUIPoint(x: width / 2, y: height / 2)
      var polygons = [Polygon]()
      var vertices = [Vertice]()
      
      let path = "african_head.obj"
      let wfo = try String(contentsOfFile: path, encoding: .utf8)
      let lines = wfo.characters
        .split(separator: "\n", omittingEmptySubsequences: false)
        .map { String($0) }
      
      for line in lines
      {
        if line.hasPrefix("f ")
        {
          polygons.append(Polygon(line))
        }
        else if line.hasPrefix("v ")
        {
          vertices.append(Vertice(line))
        }
      }
      
      for polygon in polygons
      {
        for j in 0..<3
        {
          let v0 = vertices[polygon.indices[j].x - 1]
          let v1 = vertices[polygon.indices[(j+1)%3].x - 1]
          if v0.z < -0.3 || v1.z < -0.3 { continue }
          
          let pos0 = TUIPoint(x: (v0.x + 1) * center.x,
                              y: Double(height) - (v0.y + 1) * center.y)
          let pos1 = TUIPoint(x: (v1.x + 1) * center.x,
                              y: Double(height) - (v1.y + 1) * center.y)
          view.drawLine(from: pos0, to: pos1, action: .on)
        }
      }
      
      view.draw()
    }
  }
}
