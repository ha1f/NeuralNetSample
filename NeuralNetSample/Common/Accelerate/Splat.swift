//
//  Splat.swift
//  NeuralNetSample
//
//  Created by ST20591 on 2018/05/30.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import Foundation
import Accelerate

/// サイズを持たないが、全ての要素がvalueとみなされる行列
struct Splat: LaObjectWrapperType {
    let raw: la_object_t
    
    init?(value: Double) {
        self.init(la_splat_from_double(value, la_attribute_t(LA_DEFAULT_ATTRIBUTES)))
    }
    
    init?(_ matrix: la_object_t) {
        guard la_status(matrix) == LA_SUCCESS else {
            debugPrint("Matrix initializing error: \(la_status(matrix))")
            return nil
        }
        self.raw = matrix
    }
}

extension Splat {
    /// splatをベクトルの要素から生成
    static func from(elementOf vector: Vector, index: la_index_t) -> Splat? {
        return Splat(la_splat_from_vector_element(vector.raw, index))
    }
    
    /// splatをmatrixの要素から生成
    static func from(elementOf matrix: Matrix, row: la_index_t, col: la_index_t) -> Splat? {
        return Splat(la_splat_from_matrix_element(matrix.raw, row, col))
    }
}
