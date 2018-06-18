//
//  main.swift
//  NeuralNetSample
//
//  Created by ST20591 on 2018/05/25.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import Foundation

print(Matrix(array: [1, 2, 3, 4, 5, 6], rows: 2, cols: 3)!)

let layer = AffineLayer(weights: Matrix(array: [1, 2, 3, 4, 5, 6], rows: 2, cols: 3)!, biass: Vector(array: [0.1, 0.2, 0.3], isColumn: false)!)

// 1 * 1 + 2 * 4 + 0.1 = 9.1
// 1 * 2 + 2 * 5 + 0.2 = 12.2
// 1 * 3 + 2 * 6 + 0.3 = 15.3
print(layer.forward([1, 2]))

// 1 * 1 + 2 * 2 + 3 * 3 = 14
// 1 * 4 + 2 * 5 + 3 * 6 = 32
print(layer.backward([1, 2, 3]))

let m1 = Matrix(array: [1, 2, 3, 4, 5, 6], rows: 2, cols: 3)!
let m2 = Matrix(array: [1, 2, 3, 4, 5, 6], rows: 2, cols: 3)!

print(layer.forward(batchInput: Matrix(array: [1, 2, 1, 2], rows: 2, cols: 2)!))

print(layer.backward(batchInput: Matrix(array: [1, 2, 3, 1, 2, 3], rows: 2, cols: 3)!))



