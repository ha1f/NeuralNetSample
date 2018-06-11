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
    let rawValue: la_object_t
    
    /// isColumn = trueなら縦ベクトル
    init?(array: [Double], isColumn: Bool = true) {
        let length = la_count_t(array.count)
        if isColumn {
            self.init(rawValue: la_matrix_from_double_buffer(array, length, 1, 1, la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES)))
        } else {
            self.init(rawValue: la_matrix_from_double_buffer(array, 1, length, length, la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES)))
        }
    }
    
    init?(rawValue vector: la_object_t) {
        guard la_status(vector) == LA_SUCCESS else {
            debugPrint("Vector initializing error: \(la_status(vector))")
            return nil
        }
        self.rawValue = vector
    }
}


extension Vector {
    var length: la_count_t {
        return la_vector_length(rawValue)
    }
    
    func norm(_ norm: la_norm_t = la_norm_t(LA_L1_NORM)) -> Double? {
        return la_norm_as_double(rawValue, norm)
    }
    
    func normalized(_ norm: la_norm_t = la_norm_t(LA_L1_NORM)) -> Vector? {
        return Vector(rawValue: la_normalized_vector(rawValue, norm))
    }
}

extension Vector {
    /// 横ベクトルを取り出す
    static func fromRow(of matrix: Matrix, at row: la_count_t) -> Vector? {
        return Vector(rawValue: la_vector_from_matrix_row(matrix.rawValue, row))
    }
    
    /// 縦ベクトルを取り出す
    static func fromCol(of matrix: Matrix, at col: la_count_t) -> Vector? {
        return Vector(rawValue: la_vector_from_matrix_col(matrix.rawValue, col))
    }
    
    /// 対角線ベクトルを取り出す
    static func fromDiagonal(of matrix: Matrix, at diagonal: la_index_t = 0) -> Vector? {
        return Vector(rawValue: la_vector_from_matrix_diagonal(matrix.rawValue, diagonal))
    }
}

extension Vector {
    /// 内積
    static func innerProduct(_ lhs: Vector, _ rhs: Vector) -> Double? {
        return Vector(rawValue: la_inner_product(lhs.rawValue, rhs.rawValue))?.getComponents().first
    }
    
    /// 外積
    static func outerProduct(_ lhs: Vector, _ rhs: Vector) -> Vector? {
        return Vector(rawValue: la_outer_product(lhs.rawValue, rhs.rawValue))
    }
}

