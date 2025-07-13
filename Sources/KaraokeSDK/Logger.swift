//
//  Logger.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

@preconcurrency
import SwiftyBeaver

public enum Logger: Sendable {
    private static let logger: SwiftyBeaver.Type = SwiftyBeaver.self
    private static let console: ConsoleDestination = .init(format: "$DHH:mm:ss$d $L: $M")
    private static let file: FileDestination = .init(format: "$DHH:mm:ss$d $L: $M")
    
    public static func configure() {
        logger.addDestination(console)
        logger.addDestination(file)
    }
    
    public static func info(_ message: Any, context: Any? = nil) {
        logger.info(message, context: context)
    }

    public static func error(_ message: Any, context: Any? = nil) {
        logger.error(message, context: context)
    }

    public static func debug(_ message: Any, context: Any? = nil) {
        logger.debug(message, context: context)
    }

    public static func warning(_ message: Any, context: Any? = nil) {
        logger.warning(message, context: context)
    }

    public static func verbose(_ message: Any, context: Any? = nil) {
        logger.verbose(message, context: context)
    }
}

extension ConsoleDestination {
    convenience init(format: String) {
        self.init()
        self.format = format
        minLevel = .verbose
    }
}

extension FileDestination {
    convenience init(format: String) {
        self.init()
        self.format = format
        minLevel = .info
    }
}
