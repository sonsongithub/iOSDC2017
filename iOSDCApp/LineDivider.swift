//
//  LineDivider.swift
//  LineDivider
//
//  Created by sonson on 2017/08/23.
//  Copyright © 2017年 sonson. All rights reserved.
//

import Foundation

public extension Data {
    public func lines() -> [String] {
        return self.withUnsafeBytes({ (pointer: UnsafePointer<UInt8>) -> [String] in
            let buffer = [UInt8](UnsafeBufferPointer(start: pointer, count: self.count))
            var lines: [String] = []
            let newline = UInt8(ascii: "\n")
            var begin = buffer.startIndex
            while let end = buffer.suffix(from: begin).index(of: newline).map({ buffer.index(after: $0) }) {
                defer { begin = end }
                let beforeNewline = buffer.index(before: end)
                guard beforeNewline - begin > 0 else { continue }
                let lineBuffer = buffer[begin..<beforeNewline]
                let data = Data(bytes: lineBuffer)
                if let line = String(data: data, encoding: .shiftJIS) {
                    lines.append(line)
                }
            }
            return lines
        })
    }
}
