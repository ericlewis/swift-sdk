//
//  File.swift
//  
//
//  Created by Taylor Dawson on 5/7/24.
//

import CryptoKit
import Foundation

extension Data {
  public init?(hexString: String) {
    let len = hexString.count / 2
    var data = Data(capacity: len)
    for i in 0..<len {
      let j = hexString.index(hexString.startIndex, offsetBy: i * 2)
      let k = hexString.index(j, offsetBy: 2)
      let bytes = hexString[j..<k]
      if var num = UInt8(bytes, radix: 16) {
        data.append(&num, count: 1)
      } else {
        return nil
      }
    }
    self = data
  }

  public func toHexString() -> String {
    return map { String(format: "%02x", $0) }.joined()
  }

  public func base64URLEncodedString() -> String {
    let base64String = self.base64EncodedString()
    let base64URLString =
      base64String
      .replacingOccurrences(of: "+", with: "-")
      .replacingOccurrences(of: "/", with: "_")
      .trimmingCharacters(in: CharacterSet(charactersIn: "="))
    return base64URLString
  }
  /// Initializes `Data` by decoding a base64 URL encoded string.
  /// - Parameter base64URLEncoded: The base64 URL encoded string.
  /// - Returns: An optional `Data` instance if the string is valid and successfully decoded, otherwise `nil`.
  public init?(base64URLEncoded: String) {
    let paddedBase64 =
      base64URLEncoded
      .replacingOccurrences(of: "-", with: "+")
      .replacingOccurrences(of: "_", with: "/")
    // Adjust the string to ensure it's a multiple of 4 for valid base64 decoding
    let paddingLength = (4 - paddedBase64.count % 4) % 4
    let paddedBase64String = paddedBase64 + String(repeating: "=", count: paddingLength)
    guard let data = Data(base64Encoded: paddedBase64String) else {
      return nil
    }
    self = data
  }
}
