//
//  RollinsportMessageBus.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/11/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import SwiftGodot

@NativeHandleDiscarding
class RollinsportMessageBus: Node {
    static var shared = RollinsportMessageBus()

    required init() {
        Self.initializeClass()
        super.init()
    }

    func notify(_ message: RollinsportMessage) throws {
        switch message {
        case .puzzleSolved(let id), .foundSolution(let id), .requestForSolve(let id):
            try emitSignal(message.signal, Variant(id))
        }
    }

    func registerSubscriber(_ callable: Callable, to message: RollinsportMessage) throws {
        try connect(signal: message.signal, callable: callable)
    }

}

extension RollinsportMessageBus {
    static func initializeClass() {
        let className = StringName("\(RollinsportMessageBus.self)")
        let classInfo = ClassInfo<RollinsportMessageBus>(name: className)

        for messageType in RollinsportMessage.allCases {
            classInfo.registerSignal(name: messageType.signal, arguments: messageType.propertyInformation)
        }
    }
}

// MARK: - Messages

enum RollinsportMessage {
    case requestForSolve(id: String)
    case foundSolution(id: String)
    case puzzleSolved(id: String)

    var signal: StringName {
        switch self {
        case .requestForSolve:
            return "request_for_solve"
        case .foundSolution:
            return "found_solution"
        case .puzzleSolved:
            return "puzzle_solved"
        }
    }
}

extension RollinsportMessage: CaseIterable {
    static var allCases: [RollinsportMessage] {
        [.puzzleSolved(id: ""), .requestForSolve(id: ""), .foundSolution(id: "")]
    }
}

extension RollinsportMessage {
    var propertyInformation: [PropInfo] {
        let className = StringName("\(RollinsportMessageBus.self)")
        return switch self {
        case .puzzleSolved, .requestForSolve, .foundSolution:
            [
                PropInfo(propertyType: .string,
                         propertyName: self.signal,
                         className: className,
                         hint: .typeString,
                         hintStr: "",
                         usage: .default)
            ]
        }
    }
}
