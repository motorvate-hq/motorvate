//
//  Logging.swift
//  Motorvate
//
//  Created by Emmanuel on 2/1/23.
//  Copyright © 2023 motorvate. All rights reserved.
//

import Foundation

protocol MLogging {
    static var date: String { get }
    static var isEnabled: Bool { get }
}

extension MLogging {
    public static var date: String {
        return Date().description(with: nil)
    }

    public static var isEnabled: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
}

public class MLogger: MLogging {
    static func log(_ level: MLogger.Level, _ object: Any, filename: String = #file, line: Int = #line, functionName: String = #function) {
        guard MLogger.isEnabled else { return }
        print("\(MLogger.date) \(level.rawValue) [\(sourceFileName(filePath: filename))]: line: \(line) \(functionName) \(object)")
    }
}

extension MLogger {
    enum Level: String {
        case info = "ℹ️"
        case error = "‼️"
        case verbose = ""
    }
}

private extension MLogger {
    static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : (components.last ?? "")
    }
}
