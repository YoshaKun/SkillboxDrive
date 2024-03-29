//
//  Units.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 19.12.2023.
//

import Foundation

public struct Units {

  public let bytes: Int64

  public var kilobytes: Double {
    return Double(bytes) / 1_024
  }

  public var megabytes: Double {
    return kilobytes / 1_024
  }

  public var gigabytes: Double {
    return megabytes / 1_024
  }

  public init(bytes: Int64) {
    self.bytes = bytes
  }

  public func getReadableUnit() -> String {

    switch bytes {
    case 0..<1_024:
      return "\(bytes) bytes"
    case 1_024..<(1_024 * 1_024):
      return "\(String(format: "%.2f", kilobytes)) " + Constants.Text.kbMemory
    case 1_024..<(1_024 * 1_024 * 1_024):
        return "\(String(format: "%.2f", megabytes)) " + Constants.Text.mbMemory
    case (1_024 * 1_024 * 1_024)...Int64.max:
        return "\(String(format: "%.2f", gigabytes)) " + Constants.Text.gbMemory
    default:
      return "\(bytes) bytes"
    }
  }
}
