//
//  AffineLayer.swift
//  NeuralNetSample
//
//  Created by ST20591 on 2018/05/30.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import Foundation
import Accelerate

class AffineLayer: LayerType {
//    private let weights: Matrix
    private let weights: [[Double]]
    private let biass: [Double]
    
    init(inputLength: Int, count: Int, distribution: Random.Distribution = .gaussian(μ: 0, σ: 1)) {
        self.weights = Random.matrix(lines: inputLength, rows: count, distribution: distribution)
        self.biass = (0..<inputLength).map { _ in 0 }
    }
    
//    init(inputLength: Int, count: Int, distribution: Random.Distribution = .gaussian(μ: 0, σ: 1)) {
//        let numbers = Random.array(length: inputLength * count, distribution: distribution)
//        self.weights = Matrix(array: numbers, rows: la_count_t(inputLength), cols: la_count_t(count))!
//        self.biass = Vector(array: (0..<inputLength).map { _ in 0 })
//    }
    
//    init(weights: [[Double]], biass: [Double]) {
//        assert(weights.count == biass.count, "weights.count and biass.count must be equal to the number of perceptron")
//        self.weights = weights
//        self.biass = biass
//    }
    
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
