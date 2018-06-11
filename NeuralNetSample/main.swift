//
//  main.swift
//  NeuralNetSample
//
//  Created by ST20591 on 2018/05/25.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import Foundation

let m1 = Matrix(array: [1, 2, 3, 4], rows: 2, cols: 2)!
let m2 = Matrix(array: [5, 6, 7, 8], rows: 2, cols: 2)!

debugPrint(Matrix.product(m1, m2))

