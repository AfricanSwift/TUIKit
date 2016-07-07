//
//          File:   Figlet.swift
//    Created by:   African Swift

import Foundation

internal struct Figlet
{
  /// Figlet Error
  /// - header
  /// - invalidHeader
  /// - fileReadError
  /// - characterIndexOutOfBounds
  internal enum Error: ErrorProtocol
  {
    case header(FigletHeader.Error)
    case invalidHeader, fileReadError
    case characterIndexOutOfBounds
  }
  
  /// Figlet font header values
  private let header: FigletHeader
  private var hasDeutsch: Bool = false
  
  /// Dictionary to contain figlet font characters
  private var letters = [Int: [String]]()
}

internal extension Figlet
{
  /// Scans file to identify newline terminator
  ///
  /// - parameters:
  ///   - file: String
  /// - returns: Character?
  private static func getTerminator(file: String) -> Character?
  {
    if file.range(of: "\r\n") != nil
    {
      return "\r\n"
    }
    else if file.range(of: "\n") != nil
    {
      return "\n"
    }
    else if file.range(of: "\r") != nil
    {
      return "\r"
    }
    else
    {
      return nil
    }
  }
  
  /// Default initializer
  ///
  /// - parameters:
  ///   - fontFile: String
  internal init?(fontFile path: String) throws
  {
    do
    {
      let font = try String(contentsOfFile: path, encoding: .utf8)
      
      guard let terminator = Figlet.getTerminator(file: font) else
      {
        print("unknown line terminator")
        return nil
      }
      
      let lines = font.characters
        .split(separator: terminator, omittingEmptySubsequences: false)
        .map { String($0) }
      
      let fontname = (path as NSString)
        .lastPathComponent
        .replacingOccurrences(of: ".flf", with: "")
      
      self.header = try FigletHeader(lines: lines, name: fontname)
      
      // Standard ASCII character set
      (32...126).forEach { letters[$0] = getLetter(array: lines, index: $0) }
      
      // Deutsch FIGcharacters
      if getLetterIndex(127) + (7 * self.header.height) >= self.header.lastline
      {
        self.hasDeutsch = true
        let deutschChar: [(code: Int, index: Int)]
        deutschChar = [(196, 127), (214, 128),
                       (220, 129), (228, 130),
                       (246, 131), (252, 132),
                       (223, 133)]
        deutschChar.forEach {
          letters[$0.code] = getLetter(array: lines, index: $0.index)
        }
      }      
    }
    catch Figlet.Error.header(let subType)
    {
      print("FigFont Header: \(subType)")
      return nil
      
    }
    catch let error as NSError
      where error.domain == NSCocoaErrorDomain
        && error.code == NSCocoaError.fileReadNoSuchFileError.rawValue
    {
      print("\(error.localizedDescription)")
      return nil
      
    }
    catch let error as NSError
    {
      print("\(error.localizedDescription)")
      return nil
    }
  }
}

internal extension Figlet
{
  /// Array index for character scanline
  ///
  /// - parameters:
  ///   - index: Int
  /// - returns: Int
  private func getLetterIndex(_ index: Int) -> Int
  {
    return ((index - 32) * self.header.height) +
      (self.header.comments + 1)
  }
  
  /// Remove delimiting endMark and hardBlank characters
  ///
  /// - parameters:
  ///   - scanline: String
  /// - returns: String
  private func removeDelimiters(_ scanline: String) -> String
  {
    // Last FIGcharacter line terminates with 2 endmarks. Search last 2 characters 
    // to avoid removing endmark character employed by a font design
    var endmarkScanIndex = scanline.startIndex..<scanline.endIndex
    if scanline.characters.count >= 2
    {
      endmarkScanIndex = scanline.index(scanline.endIndex, offsetBy: -2)..<scanline.endIndex
    }
    
    let noEndmark = scanline.replacingOccurrences(
      of: header.endmark.toString(),
      with: "",
      range: endmarkScanIndex)
    return noEndmark.replacingOccurrences(of: String(header.hardblank), with: " ")
  }
  
  /// Scan lines for a specific charCode
  ///
  /// - parameters:
  ///   - array: [String]
  ///   - index: Int
  /// - returns: [String]
  private func getLetter(array: [String], index: Int) -> [String]
  {
    let start = getLetterIndex(index)
    let end = start + self.header.height
    return (start..<end).map { removeDelimiters(array[$0]) }
  }
}

internal extension Figlet
{
  /// Draw text using a figlet font
  ///
  /// - parameters:
  ///   - text: String
  /// - returns: String
  internal func drawText(text: String) -> [String] {
    var result = [String]()
    for i in 0 ..< self.header.height
    {
      var line = ""
      for s in text.unicodeScalars
      {
        if let arr = letters[Int(s.value)]
        {
          // rudimentary smushing, remove last character
          line += arr[i].substring(with: 0..<arr[i].characters.count) ?? ""
        }
      }
      result.append(line)
    }
    return result
  }
}
