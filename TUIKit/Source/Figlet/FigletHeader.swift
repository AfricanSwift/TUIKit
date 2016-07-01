//
//          File:   FigletHeader.swift
//    Created by:   African Swift

import Darwin

// The first five characters must be "flf2a"
//
//         flf2a$ 6 5 20 15 3 0 143 229
//           |  | | | |  |  | |  |   |
//          /  /  | | |  |  | |  |   \
// Signature  /  /  | |  |  | |   \   Codetag_Count
//   Hardblank  /  /  |  |  |  \   SmushFull
//        Height  /   |  |   \  Print_Direction
//        Baseline   /    \   Comment_Lines
//         Max_Length      SmushOld

/// Figlet Header Structure
internal struct FigletHeader
{
  /// Font name
  internal let name: String
  
  /// The signature is the first five characters: "flf2a".
  internal let signature: String
  
  /// Hardblank is a character adjacent to the signature.
  internal let hardblank: Character
  
  /// Height of a character
  internal let height: Int
  
  /// Height of a character, not including descenders
  internal let baseline: Int
  
  /// Max line length (excluding comment lines) + a fudge factor
  internal let length: Int
  
  /// Old smushmode
  internal let smushold: Int
  
  /// Number of comment lines
  internal let comments: Int
  
  /// Each line has one or two endmark characters, locations designate width
  internal let endmark: Character
  
  /// Last line containing endmark
  internal let lastline: Int
  
  internal static let signature = "flf2a"
  
  internal enum Error
  {
    case signature, hardblank, height, baseLine
    case maxLength, oldlayout, commentLines
    case printDirection, fulllayout, codetagCount
    case missingParameters, endmarkInconsistency
  }
  
}

internal extension FigletHeader
{
  private struct Header
  {
    private let signature: String
    private let hardblank: Character
    private let height: Int
    private let baseline: Int
    private let length: Int
    private let smushold: Int
    private let comments: Int
    
    /// Default initializer
    ///
    /// - parameters:
    ///   - header: [String]
    /// - throws: Figlet.Error
    private init(header: [String]) throws
    {
      // Validate Figlet signature
      guard let signature = header[0].substring(with: 0..<5)
        where signature == FigletHeader.signature else {
          throw Figlet.Error.header(.signature)
      }
      
      // These six values are the minimum required, fail if any are invalid
      guard let hardblank = header[0].substring(atIndex: 5) else {
        throw Figlet.Error.header(.hardblank)
      }
      
      guard let height = Int(header[1]) else {
        throw Figlet.Error.header(.height)
      }
      
      guard let baseline = Int(header[2]) else {
        throw Figlet.Error.header(.baseLine)
      }
      
      guard let length = Int(header[3]) else {
        throw Figlet.Error.header(.maxLength)
      }
      
      guard let smushold = Int(header[4]) else {
        throw Figlet.Error.header(.oldlayout)
      }
      
      guard let comments = Int(header[5]) else {
        throw Figlet.Error.header(.commentLines)
      }
      
      self.signature = signature
      self.hardblank = hardblank
      self.height = height
      self.baseline = baseline
      self.length = length
      self.smushold = smushold
      self.comments = comments
    }
  }
  
  /// Default initializer
  ///
  /// - parameters:
  ///   - lines: [String]
  ///   - name: String
  /// - throws: FigletHeader.Error
  internal init(lines: [String], name: String) throws
  {
    let headerline = lines[0].characters
      .split(separator: " ", omittingEmptySubsequences: false)
      .map { String($0) }
    let header = try Header(header: headerline)
    
    // Last line(foot) of FIGcharacter has two endmarks
    let foot = lines[header.comments + header.height].trim()
    if foot.characters.count < 2
    {
      throw Figlet.Error.header(.endmarkInconsistency)
    }
    let footEndmark = foot.substring(from: foot.index(foot.endIndex, offsetBy: -2))
    guard let endmark = footEndmark.substring(atIndex: 0),
      let adjmark = footEndmark.substring(atIndex: 1)
      where endmark == adjmark else {
        throw Figlet.Error.header(.endmarkInconsistency)
    }
    
    // Find last line with endmark
    var lastIndex = 0
    for idx in (0...lines.count - 1).reversed()
    {
      if lines[idx].contains(endmark.toString())
      {
        lastIndex = idx
        break
      }
    }
    
    self.name = name
    self.signature = header.signature
    self.hardblank = header.hardblank
    self.height = header.height
    self.baseline = header.baseline
    self.length = header.length
    self.smushold = header.smushold
    self.comments = header.comments
    self.endmark = endmark
    self.lastline = lastIndex
  }
}
