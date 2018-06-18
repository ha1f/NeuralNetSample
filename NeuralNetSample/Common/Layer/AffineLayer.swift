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
    
    func forward(batchInput input: Matrix) -> Matrix {
        // biasを行列に拡張（縦に同じ要素を繰り返す）
        let dataCount = input.rows
        let biasComponents = biass.getComponents()
        let bias = Matrix(array: (0..<Int(dataCount)).flatMap { _ in biasComponents }, rows: dataCount, cols: biass.cols)!
        
        return Matrix.sum(Matrix.product(input, weights)!, bias)!
    }
    
    func backward(batchInput input: Matrix) -> Matrix {
        return Matrix.product(input, weights.transposed()!)!
    }
    
    func forward(_ input: [Double]) -> [Double] {
        let inputVector = Vector(array: input, isColumn: false)!
        return Vector.sum(Matrix.product(inputVector, weights)!.asVector()!, biass)!.getComponents()
    }
    
    func backward(_ input: [Double]) -> [Double] {
        let inputVector = Vector(array: input, isColumn: false)!
        return Matrix.product(inputVector, weights.transposed()!)!.asVector()!.getComponents()
    }
}
