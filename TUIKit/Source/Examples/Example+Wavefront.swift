//
//          File:   Example+Wavefront.swift
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
    
    struct Face
    {
      let face: Int
      let texture: Int
      let vertex: Int
      
      private init(_ face: String, _ texture: String, _ vertex: String)
      {
        self.face = Int(face) ?? -1
        self.texture = Int(texture) ?? -1
        self.vertex = Int(vertex) ?? -1
      }
      
      static func load(from line: String) -> [Face]
      {
        let step1 = line.characters.split(separator: " ")
          .map { String($0).characters.split(separator: "/", omittingEmptySubsequences: false)
            .map { String($0) } }
        
        return step1.flatMap { v -> Face? in
          if String(v[0]).hasPrefix("f") { return nil }
          let cnt = v.count
          return Face(v[0], cnt > 1 ? v[1] : "", cnt > 2 ? v[2] : "")
        }
      }
    }
    
    struct Polygon
    {
      var faces: [Face]
      
      init(_ line: String)
      {
        self.faces = Face.load(from: line)
      }
    }
    
    public static func demo() throws
    {
      Ansi.Set.cursorOff().stdout()
      Ansi.Cursor.column().stdout()
      guard let wSize = TUIWindow.ttysize() else { exit(EXIT_FAILURE) }
      
      let width = Int(wSize.character.width * 2) - 4
      let height = Int(wSize.character.height * 4) - 8 - 2 - 8
      let param = TUIView.Parameter(invertYAxis: true)
      var view = TUIView(x: 0, y: 0, width: width, height: height, parameters: param)
      let center = TUIVec2(x: width / 2, y: height / 2)
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
          let v0 = vertices[polygon.faces[j].face - 1]
          let v1 = vertices[polygon.faces[(j+1)%3].face - 1]
          if v0.z < -0.3 || v1.z < -0.3 { continue }
          let pos0 = TUIVec2(x: (v0.x + 1) * center.x,
                             y: (v0.y + 1) * center.y)
          let pos1 = TUIVec2(x: (v1.x + 1) * center.x,
                             y: (v1.y + 1) * center.y)
          view.drawLine(from: pos0, to: pos1, action: .on)
        }
      }
      
      view.draw()
    }
  }
}

public extension Example.Wavefront
{
  
  public static func shoelace(_ v: [TUIVec2]) -> Double
  {
    let a = v[0].x * v[1].y - v[1].x * v[0].y
    let b = v[1].x * v[2].y - v[2].x * v[1].y
    let c = v[2].x * v[0].y - v[0].x * v[2].y
    return (a + b + c) / 2
  }
  
  public static func demo2() throws
  {
    Ansi.Set.cursorOff().stdout()
    Ansi.Cursor.column().stdout()
    guard let wSize = TUIWindow.ttysize() else { exit(EXIT_FAILURE) }
    let width = Int(wSize.character.width * 2) - 4
    let height = Int(wSize.character.height * 4) - 8 - 2 - 8
    let param = TUIView.Parameter(invertYAxis: true)
    var view = TUIView(x: 0, y: 0, width: width, height: height, parameters: param)
    let center = TUIVec2(x: width / 2, y: height / 2)
    var polygons = [Polygon]()
    var vertices = [Vertice]()
    let path = "head.obj"
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
    
    let lightDirection = TUIVec3(x: -0.0, y: -0.5, z: -1)
    
    for shoeSkip in stride(from: 400.0, through: 0.0, by: -25)
    {
      for polygon in polygons
      {
        var screenCoords = Array<TUIVec2>(repeating: TUIVec2(), count:  3)
        var worldCoords = Array<TUIVec3>(repeating: TUIVec3(), count: 3)
        
        for j in 0 ..< 3
        {
          let v = vertices[polygon.faces[j].face - 1]
          screenCoords[j] = TUIVec2(x: (v.x + 1) * center.x, y: (v.y + 1) * center.y) * 1
          worldCoords[j] = TUIVec3(x: v.x, y: v.y, z: v.z)
          // Move coords to center object
          // screenCoords[j] = screenCoords[j] + TUIVec2(x: center.x / 2 + 20, y: 0)
        }
        
        let shoelace = Example.Wavefront.shoelace(screenCoords)
        if shoelace < shoeSkip || shoelace > shoeSkip + 25  { continue }
        let n = (worldCoords[2] - worldCoords[0]) ** (worldCoords[1] - worldCoords[0])
        let intensity = n.normalize() * lightDirection
        if intensity > 0
        {
          let color = Ansi.Color(red: 0.98 * intensity,
                                 green: 0.85 * intensity,
                                 blue: 0.67 * intensity, alpha: 1)
          view.drawTriangle(vector1: screenCoords[0],
                            vector2: screenCoords[1],
                            vector3: screenCoords[2], color: color, fill: true)
        }
      }
    }
    let renderParm = TUIRenderParameter(colorspace: .foreground256,
                                        composite: .average, style: .drawille)
    view.draw(parameters: renderParm)
    Ansi.Cursor.position().stdout()
    Ansi.flush()
  }
}
