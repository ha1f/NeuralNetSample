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
    private let weights: Matrix
    private let biass: Vector
    
    init(weights: Matrix, biass: Vector) {
        self.weights = weights
        self.biass = biass
    }
    
    //TODO: 行列の入力に対応する(rowsがデータ数になる)
    /// countはパーセプトロンの数＝出力の長さ
    init(inputLength: Int, count: Int, distribution: Random.Distribution = .gaussian(μ: 0, σ: 1)) {
        let weights = Random.array(length: inputLength * count, distribution: distribution)
        self.weights = Matrix(array: weights, rows: la_count_t(inputLength), cols: la_count_t(count))!
        
        let biass = Random.array(length: count, distribution: distribution)
        self.biass = Vector(array: biass, isColumn: false)!
    }
    
    func forward(_ input: [Double]) -> [Double] {
        let inputVector = Vector(array: input, isColumn: false)!
        print(Matrix.product(inputVector, weights))
        print(Matrix.product(inputVector, weights)?.asVector())
        print(Vector.sum(Matrix.product(inputVector, weights)!.asVector()!, biass))
        return Vector.sum(Matrix.product(inputVector, weights)!.asVector()!, biass)!.getComponents()
    }
    
    func backward(_ input: [Double]) -> [Double] {
        let inputVector = Vector(array: input, isColumn: false)!
        return Matrix.product(inputVector, weights.transposed()!)!.asVector()!.getComponents()
    }
}
