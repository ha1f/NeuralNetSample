//
//  Layer.swift
//  NeuralNetSample
//
//  Created by ST20591 on 2018/05/25.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import Foundation

class TwoLayerNet {
//    var layers: [LayerType] = [AffineLayer(length: 100), SigmoidLayer(), AffineLayer(length: 8)]
}

protocol LayerType {
    func forward(_ input: [Double]) -> [Double]
    func backward(_ input: [Double]) -> [Double]
}

class IdentityLayer: LayerType {
    func forward(_ input: [Double]) -> [Double] {
        return input
    }
    func backward(_ input: [Double]) -> [Double] {
        return input
    }
}

class ReLULayer: LayerType {
    func forward(_ input: [Double]) -> [Double] {
        return input.map { $0 < 0 ? 0 : $0 }
    }
    
    func backward(_ input: [Double]) -> [Double] {
        return input.map { $0 < 0 ? 0 : 1 }
    }
}

class SigmoidLayer: LayerType {
    private var _outputCache: [Double]?
    
    func forward(_ input: [Double]) -> [Double] {
        let result = input.map { 1 / (1 + exp(-$0)) }
        _outputCache = result
        return result
    }
    
    func backward(_ input: [Double]) -> [Double] {
        // nilならエラーをはきたい
        return _outputCache ?? []
    }
}

class AffineLayer: LayerType {
    private let weights: [[Double]]
    private let biass: [Double]
    
    init(inputLength: Int, count: Int) {
        self.weights = Random.matrix(lines: count, rows: inputLength, distribution: .gaussian(μ: 0, σ: 1))
        self.biass = (0..<inputLength).map { _ in 0 }
    }
    
    init(weights: [[Double]], biass: [Double]) {
        assert(weights.count == biass.count, "weights.count and biass.count must be equal to the number of perceptron")
        self.weights = weights
        self.biass = biass
    }
    
    func forward(_ input: [Double]) -> [Double] {
        return zip(weights, biass)
            .map { weight, bias in
                zip(weight, input).map { $0 * $1 }.reduce(0, +) + bias }
    }
    
    func backward(_ input: [Double]) -> [Double] {
        return []
        // return zip(input, weights).map { $0 / $1 }
    }
}
