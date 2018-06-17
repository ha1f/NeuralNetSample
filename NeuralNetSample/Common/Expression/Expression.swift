//
//  Expression.swift
//  NeuralNetSample
//
//  Created by ST20591 on 2018/06/17.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import Foundation

//enum InfixOperator: String {
//    case plus = "+"
//    case minus = "-"
//    case divide = "/"
//    case multiply = "*"
//    case power = "^"
//
//    func calculate(_ lhs: Double, _ rhs: Double) -> Double {
//        switch self {
//        case .plus:
//            return lhs + rhs
//        case .minus:
//            return lhs - rhs
//        case .divide:
//            return lhs / rhs
//        case .multiply:
//            return lhs * rhs
//        case .power:
//            return pow(lhs, rhs)
//        }
//    }
//}
//
//enum ExpressionError: Error {
//    case invalidInput
//    case failedParsingValue
//    case unknown
//}
//
//indirect enum Expression {
//    case value(Double)
//    case statement(InfixOperator, Expression, Expression)
//
//    // TODO: convert to struct(expressions: [String], isLeftAssociative: Bool, priority: Int)
//    enum Operator: String {
//        case plus = "+"
//        case minus = "-"
//        case divide = "/"
//        case multiply = "*"
//        case power = "^"
//
//        var isLeftAssociative: Bool {
//            switch self {
//            case .plus, .minus, .divide, .multiply:
//                return true
//            case .power:
//                return false
//            }
//        }
//
//        var priority: Int {
//            switch self {
//            case .plus, .minus:
//                return 2
//            case .divide, .multiply:
//                return 3
//            case .power:
//                return 4
//            }
//        }
//
//        static var all: [Operator] {
//            return [.plus, .minus, .divide, .multiply, .power]
//        }
//    }
//
//    static func parse(_ string: String) -> Expression {
//        if Regex.float.matches(string) {
//            return Expression.value(Double(string)!)
//        }
//
//        var output = [String]()
//        var operators = [Operator]()
//        for character in string.unicodeScalars {
//            if CharacterSet.decimalDigits.contains(character) || character == "." {
//                output.append(String(character))
//                continue
//            }
//            if let op = Operator(rawValue: String(character)) {
//                while let lastOp = operators.first,
//                    (op.isLeftAssociative && op.priority <= lastOp.priority)
//                        || (op.priority < lastOp.priority) {
//                            operators.removeFirst()
//                            output.append(op.rawValue)
//                }
//                operators.insert(op, at: 0)
//            }
//
//        }
//    }
//}
//
//extension Expression {
//    // MARK: calculating
//
//    func calculateResult() -> Double {
//        switch self {
//        case .value(let value):
//            return value
//        case .statement(let op, let e1, let e2):
//            return op.calculate(e1.calculateResult(), e2.calculateResult())
//        }
//    }
//}
