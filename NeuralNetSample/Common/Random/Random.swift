//
//  Random.swift
//  NeuralNetSample
//
//  Created by ST20591 on 2018/05/28.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import Foundation

struct Random {
    enum Distribution {
        case uniform
        case gaussian(μ: Double, σ: Double)
    }
    
    fileprivate static func generator(for distribution: Distribution) -> (() -> Double) {
        switch distribution {
        case .uniform:
            return Random.uniformGenerator()
        case .gaussian(let μ, let σ):
            return Random.gaussianGenerator(μ: μ, σ: σ)
        }
    }
    
    /// 0 < x < 1 の一様分布 (0 <= x < 1 なら、drand48()を使える)
    /// UInt32.maxのとき以外はuniform使わないとモジュロバイアスでずれる
    private static func uniformGenerator() -> (() -> Double) {
        return {
            let value = arc4random()
            return (Double(value) + 1) / (Double(UInt32.max) + 2)
        }
    }
    
    /// μ, σの正規分布。引数省略すれば標準正規分布。
    /// p(x) = 1 / sqrt(2 * π * σ^2) * exp(-x^2 / 2 * σ^2)
    /// Box-Muller method
    private static func gaussianGenerator(μ: Double = 0, σ: Double = 1) -> (() -> Double) {
        return {
            let z = sqrt(-2.0 * log(generate(.uniform))) * sin(2.0 * Double.pi * generate(.uniform))
            return μ + σ * z
        }
    }
}

extension Random {
    public static func generate(_ distribution: Distribution = .uniform) -> Double {
        return generator(for: distribution)()
    }
    
    public static func array(length: Int, distribution: Distribution) -> [Double] {
        let _generator = generator(for: distribution)
        return (0..<length).map { _ in _generator() }
    }
    
    public static func matrix(lines: Int, rows: Int, distribution: Distribution) -> [[Double]] {
        let _generator = generator(for: distribution)
        return (0..<lines).map { _ in (0..<rows).map { _ in _generator() } }
    }
}
