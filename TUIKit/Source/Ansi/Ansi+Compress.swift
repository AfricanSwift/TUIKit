//
//          File:   Ansi+Compress.swift
//    Created by:   African Swift

import Darwin

// MARK: -
// MARK: Tokenizer -
internal extension Ansi
{
  private typealias IndexChars = (current: String, next2: String)
  
  /// Validate is an indexed character is a compressable SGR function
  ///
  /// - parameters:
  ///   -  v: IndexChars
  /// - returns: Bool
  private static func compressableSGR(_ v: IndexChars) -> Bool
  {
    let compressableFunctions = "@ABCDEFILMPSTXZbm"
    return v.current.isNumeric() ||
      v.current == ";" ||
      !compressableFunctions.contains(v.current) ||
      v.next2 == Ansi.C1.CSI
  }
  
  /// Stand in for uncompressable function or non function
  private static let Uncompressable = "<Uncompressable>"
  
  /// Ansi Tokenizer Errors
  private enum TokenizerError: ErrorProtocol
  {
    case separatorNotFound
  }
  
  /// Token
  internal typealias Token = (
    function: String,
    parameter: String,
    suffix: String,
    text: String)
  
  /// Tokenize CSI Ansi
  ///
  /// - parameters:
  ///   -  input: Ansi
  ///   - separator: String
  /// - returns: [Token]
  /// - throws: TokenizerError.SeparatorNotFound
  internal static func tokenizer(
    input: Ansi,
          separator: String = Ansi.C1.CSI) throws -> [Token]
  {
    let splitInput = input.toString().components(separatedBy: separator)
    
    // Throw error if split did not find any separators.
    guard splitInput.count > 1 && splitInput[0] != input.toString() else
    {
      throw TokenizerError.separatorNotFound
    }
    
    // When a String starts with the separator,
    // the 1st array slot will be empty and must be dropped
    guard !splitInput[0].isEmpty else
    {
      return splitInput.dropFirst().map {
        tokenize(tag: separator + $0, separator: separator)
      }
    }
    
    return splitInput.mapWithIndex
      {
        (index, tag) -> Token in
        
        // Check if input has a prefix == separator,
        // if not then don't add it to the first element
        if index == 0 && !input.toString().hasPrefix(separator)
        {
          return self.tokenize(tag: tag, separator: separator)
        }
        return Ansi.tokenize(tag: separator + tag, separator: separator)
    }
  }
  
  /// Tokenize an indivudual Ansi CSI compressable tag
  /// Used in conjunction with Ansi.compress()
  ///
  /// - parameters:
  ///   - tag: String
  ///   - separator: String
  /// - returns: Token
  internal static func tokenize(tag: String, separator: String) -> Token
  {
    let sLength = separator.characters.count
    guard tag.characters.distance(from: tag.startIndex, to: tag.endIndex) > sLength else
    {
      return Token(
        function: Ansi.Uncompressable,
        parameter: String(),
        suffix: String(),
        text: tag)
    }

    var currentIndex = tag.index(tag.startIndex, offsetBy: sLength)
    var chars = IndexChars(current: "", next2: "")

    // Move through successors to identify end of a Token
    while compressableSGR(chars)
    {
      currentIndex = tag.index(after: currentIndex)
      guard currentIndex != tag.endIndex else
      {
        return Token(
          function: Ansi.Uncompressable,
          parameter: String(),
          suffix: String(),
          text: tag)
      }
      chars.current = String(tag[currentIndex])
      guard tag.index(after: currentIndex) != tag.endIndex else
      {
        continue
      }
      chars.next2 = tag[currentIndex...tag.index(after: currentIndex)]
    }
    
    // After exit currentIndex is the end of the tag
    // i.e. location of the function character
    let end = currentIndex
    let function = String(tag[end])
    let parameter = tag[tag.index(tag.startIndex, offsetBy: sLength)...tag.index(before: end)]
    
    //  Suffix is any printable characters after the tag is extracted
    let suffix = end == tag.index(before: tag.endIndex) ? "" :
      tag[tag.index(after: end)...tag.index(before: tag.endIndex)]

    return Token(
      function: function,
      parameter: parameter,
      suffix: suffix,
      text: tag)
  }
}

// MARK: -
// MARK: Compression -
internal extension Ansi
{
  /// Compress Ansi Type
  ///
  /// Compression is supported for the following CSI functions
  ///
  /// - CSI Ps @  Insert Ps (Blank) Character(s) (default = 1) (ICH).
  /// - CSI Ps A  Cursor Up Ps Times (default = 1) (CUU).
  /// - CSI Ps B  Cursor Down Ps Times (default = 1) (CUD).
  /// - CSI Ps C  Cursor Forward Ps Times (default = 1) (CUF).
  /// - CSI Ps D  Cursor Backward Ps Times (default = 1) (CUB).
  /// - CSI Ps E  Cursor Next Line Ps Times (default = 1) (CNL).
  /// - CSI Ps F  Cursor Preceding Line Ps Times (default = 1) (CPL).
  /// - CSI Ps I  Cursor Forward Tabulation Ps tab stops (default = 1) (CHT).
  /// - CSI Ps L  Insert Ps Line(s) (default = 1) (IL).
  /// - CSI Ps M  Delete Ps Line(s) (default = 1) (DL).
  /// - CSI Ps P  Delete Ps Character(s) (default = 1) (DCH).
  /// - CSI Ps S  Scroll up Ps lines (default = 1) (SU).
  /// - CSI Ps T  Scroll down Ps lines (default = 1) (SD).
  /// - CSI Ps X  Erase Ps Character(s) (default = 1) (ECH).
  /// - CSI Ps Z  Cursor Backward Tabulation Ps tab stops (default = 1) (CBT).
  /// - CSI Ps b  Repeat the preceding graphic character Ps times (REP).
  /// - CSI Pm m  Character Attributes (SGR).
  ///
  /// All Ps functions are compressed by summing the Ps values, for example:
  /// [1C + [1C = [2C
  ///
  /// All Pm functions are compressed with a semicolon delimiting sub Pm
  /// values, for example: [1m + [30m + [45m = [1;30;45m
  /// - returns: Ansi
  internal func compress() -> Ansi
  {
    var output = ""
    
    // Tokenize input, if that fails return original input unaltered
    guard let tokens = try? Ansi.tokenizer(input: self) else
    {
      return self
    }
    
    var index = 0
    for _ in Loop(index < tokens.count, index += 1)
    {
      let token = tokens[index]
      
      // Typically occurs at the conclusion of a line
      // i.e. last with \n as suffix
      guard token.suffix.isEmpty else
      {
        output += token.text
        continue
      }
      
      switch token.function
      {
      case "m":
        (output, index) = Ansi.processAttributeTokens(
          currentToken: token,
          tokens: tokens,
          currentOutput: output,
          currentIndex: index)
        
      case "@", "A", "B", "C", "D", "E", "F", "I", "L", "M", "P",
           "S", "T", "X", "Z", "b":
        (output, index) = Ansi.processQuantityTokens(
          currentToken: token,
          tokens: tokens,
          currentOutput: output,
          currentIndex: index)
        
      case Ansi.Uncompressable:
        output += token.text
        
      default:
        break
      }
    }
    return Ansi(output)
  }
  
  /// Process "m" Character Attributes (SGR)
  ///
  /// - parameters:
  ///   - currentToken: Token
  ///   - tokens: [Token]
  ///   - currentOutput: String
  ///   - currentIndex: Int
  /// - returns: (output: String, index: Int)
  private static func processAttributeTokens(
    currentToken token: Token,
                 tokens: [Token],
                 currentOutput: String,
                 currentIndex: Int) -> (output: String, index: Int)
  {
    var output = currentOutput
    var index = currentIndex
    output += Ansi.C1.CSI + token.parameter
    
    // When next index == tagArray.count, we reached the end
    // Close the tag by adding the function
    if index + 1 == tokens.count
    {
      output += token.function
      return (output, index)
    }
    
    // Advance through tags to identify any more matching attribute tags
    for _ in index + 1 ..< tokens.count
    {
      index += 1
      let adjacentToken = tokens[index]
      
      // if function is invalid (i.e. not a compressable tag)
      // then complete the current tag and add the adjacent tag unchanged
      guard adjacentToken.function != Ansi.Uncompressable else
      {
        output += token.function + token.suffix + adjacentToken.text
        break
      }
      
      // If the functions are not the same, complete the current tag,
      // and rewind index to allow analysis of tag2
      guard token.function == adjacentToken.function else
      {
        output += token.function + token.suffix
        index -= 1
        break
      }
      
      // If the tag includes a suffix i.e. printable character
      // then complete the current tag and add the suffix
      guard adjacentToken.suffix.isEmpty else
      {
        output += ";" + adjacentToken.parameter +
          token.function + adjacentToken.suffix
        break
      }
      
      // If all guards were passed, add the clip instruction
      // and continue the search for matching tags
      output += ";" + adjacentToken.parameter
      
      // If we're processing the last array element
      // Close the function, no more tags expected
      if index == tokens.count - 1
      {
        output += token.function
      }
    }
    return (output, index)
  }
  
  /// Process Quantity Attributes (SGR)
  ///
  /// - parameters:
  ///   - currentToken: Token
  ///   - tokens: [Token]
  ///   - currentOutput: String
  ///   - currentIndex: Int
  /// - returns: (output: String, index: Int)
  private static func processQuantityTokens(
    currentToken token: Token,
                 tokens: [Token],
                 currentOutput: String,
                 currentIndex: Int) -> (output: String, index: Int)
  {
    var output = currentOutput
    var index = currentIndex
    // Attempt to convert String quantity to Int, if invalid assume
    // invalid tag, add unchanged and continue.
    guard var quantitySum = Int(token.parameter) else
    {
      output += token.text
      return (output, index)
    }
    
    // When next index == tagArray.count, we reached the end
    // Close the tag by adding the function
    if index + 1 == tokens.count
    {
      output += Ansi.C1.CSI + "\(quantitySum)" + token.function
      return (output, index)
    }
    
    // Advance through tags to identify any more matching attribute tags
    for _ in index + 1 ..< tokens.count
    {
      index += 1
      let adjacentToken = tokens[index]
      
      // if function is invalid (i.e. not a compressable tag)
      // then complete the current tag and add the adjacent tag unchanged
      guard adjacentToken.function != Ansi.Uncompressable else
      {
        output += Ansi.C1.CSI + "\(quantitySum)" +
          token.function + token.suffix + adjacentToken.text
        break
      }
      
      // If the functions are different, complete the current tag,
      // and rewind index to allow analysis of tag2
      guard token.function == adjacentToken.function else
      {
        output += Ansi.C1.CSI + "\(quantitySum)" +
          token.function + token.suffix
        index -= 1
        break
      }
      
      // If the quantity conversion is invalid, complete the current tag,
      // and rewind index to allow analysis of tag2
      guard let quantity = Int(adjacentToken.parameter) else
      {
        output += Ansi.C1.CSI + "\(quantitySum)" +
          token.function + token.suffix
        index -= 1
        break
      }
      
      // If the tag includes a suffix i.e. printable character
      // then complete the current tag and add the suffix
      guard adjacentToken.suffix.isEmpty else
      {
        output += Ansi.C1.CSI + "\(quantitySum + quantity)" +
          token.function + adjacentToken.suffix
        break
      }
      
      // If all guards were passed, add quantity and
      // continue the search for matching tags
      quantitySum += quantity
      
      // If we're processing the last array element
      // Close the function, no more tags expected
      if index == tokens.count - 1
      {
        output += Ansi.C1.CSI + "\(quantitySum)" + token.function
      }
    }
    return (output, index)
  }
}
