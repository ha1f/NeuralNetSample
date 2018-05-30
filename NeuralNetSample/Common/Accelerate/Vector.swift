//
//  Vector.swift
//  NeuralNetSample
//
//  Created by はるふ on 2018/05/29.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import Foundation
import Accelerate

struct Vector: LaObjectWrapperType {
    let raw: la_object_t
    
    /// isColumn = trueなら縦ベクトル
    init?(array: [Double], isColumn: Bool = true) {
        let length = la_count_t(array.count)
        if isColumn {
            self.init(la_matrix_from_double_buffer(array, length, 1, 1, la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES)))
        } else {
            self.init(la_matrix_from_double_buffer(array, 1, length, length, la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES)))
        }
    }
    
    init?(_ vector: la_object_t) {
        guard la_status(vector) == LA_SUCCESS else {
            debugPrint("Vector initializing error: \(la_status(vector))")
            return nil
        }
        self.raw = vector
    }
}


extension Vector {
    var length: la_count_t {
        return la_vector_length(raw)
    }
    
    func norm(_ norm: la_norm_t = la_norm_t(LA_L1_NORM)) -> Double? {
        return la_norm_as_double(raw, norm)
    }
    
    func normalized(_ norm: la_norm_t = la_norm_t(LA_L1_NORM)) -> Vector? {
        return Vector(la_normalized_vector(raw, norm))
    }
}

extension Vector {
    /// 内積
    static func innerProduct(_ lhs: Vector, _ rhs: Vector) -> Double? {
        return Vector(la_inner_product(lhs.raw, rhs.raw))?.getComponents().first
    }
    
    /// 外積
    static func outerProduct(_ lhs: Vector, _ rhs: Vector) -> Vector? {
        return Vector(la_outer_product(lhs.raw, rhs.raw))
    }
}

