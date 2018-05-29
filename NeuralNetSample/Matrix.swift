//
//  Matrix.swift
//  NeuralNetSample
//
//  Created by ST20591 on 2018/05/28.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import Foundation
import Accelerate

protocol LaObjectWrapperType {
    var raw: la_object_t { get }
}

/// 縦にrow、横にcolumn
/// http://yamaimo.hatenablog.jp/entry/2016/03/28/200000
/// la_retain, la_releaseは実装してないので謎
struct Matrix: LaObjectWrapperType {
    let raw: la_object_t
    
    /// 対角行列とかのときはヒントを指定するとはやくなるかも
    init?(array: [Double], rows: la_count_t, cols: la_count_t, hint: la_hint_t = la_hint_t(LA_NO_HINT)) {
        guard array.count == rows * cols else {
            debugPrint("array.count(\(array.count) does not matches rows * cols(\(rows * cols)")
            return nil
        }
        let matrix = la_matrix_from_double_buffer(array, rows, cols, cols, hint, la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        self.init(matrix)
    }
    
    fileprivate init?(_ matrix: la_object_t) {
        guard la_status(matrix) == LA_SUCCESS else {
            debugPrint("Matrix initializing error: \(la_status(matrix))")
            return nil
        }
        self.raw = matrix
    }
}

extension LaObjectWrapperType {
    var rows: la_count_t {
        return la_matrix_rows(raw)
    }
    
    var cols: la_count_t {
        return la_matrix_cols(raw)
    }
    
    var status: la_status_t {
        return la_status(raw)
    }
    
    func getComponents() -> [Double] {
        let rows = self.rows
        var buffer = [Double].init(repeating: 0, count: Int(rows * cols))
        la_matrix_to_double_buffer(&buffer, rows, raw)
        return buffer
    }
}

extension Matrix {
    // MARK: - Static Builder
    
    static func vector(_ array: [Double]) -> Matrix {
        return Matrix(array: array, rows: la_count_t(array.count), cols: 1)!
    }
    
    static func identity(_ size: la_count_t) -> Matrix {
        return Matrix(la_identity_matrix(size, la_scalar_type_t(LA_SCALAR_TYPE_DOUBLE), la_attribute_t(LA_DEFAULT_ATTRIBUTES)))!
    }
    
    static func diagonal(_ array: [Double], diagonal: la_index_t = 0) -> Matrix {
        let vector = Matrix.vector(array)
        return Matrix(la_diagonal_matrix_from_vector(vector.raw, diagonal))!
    }
    
    /// splatはサイズを持たないが、全ての要素がvalueとみなされる行列
    static func splat(fromValue value: Double) -> Matrix {
        return Matrix(la_splat_from_double(value, la_attribute_t(LA_DEFAULT_ATTRIBUTES)))!
    }
    
    /// splatをベクトルの要素から生成
    static func splat(fromElementOf vector: Matrix, index: la_index_t) -> Matrix? {
        return Matrix(la_splat_from_vector_element(vector.raw, index))
    }
    
    /// splatをmatrixの要素から生成
    static func splat(fromElementOf matrix: Matrix, row: la_index_t, col: la_index_t) -> Matrix? {
        return Matrix(la_splat_from_matrix_element(matrix.raw, row, col))
    }
}

extension Matrix {
    // MARK: - Static Operator
    
    /// サイズが同じである必要がある
    static func sum(_ lhs: Matrix, _ rhs: Matrix) -> Matrix? {
        return Matrix(la_sum(lhs.raw, rhs.raw))
    }
    
    /// サイズが同じである必要がある
    static func difference(_ lhs: Matrix, _ rhs: Matrix) -> Matrix? {
        return Matrix(la_difference(lhs.raw, rhs.raw))
    }
    
    /// 積
    static func product(_ lhs: Matrix, _ rhs: Matrix) -> Matrix? {
        return Matrix(la_matrix_product(lhs.raw, rhs.raw))
    }
    
    /// アダマール積
    /// サイズが同じである必要がある
    static func elementwiseProduct(_ lhs: Matrix, _ rhs: Matrix) -> Matrix? {
        return Matrix(la_elementwise_product(lhs.raw, rhs.raw))
    }
    
    // solve AX=B
    static func solve(_ system: Matrix, _ rhs: Matrix) -> Matrix? {
        return Matrix(la_solve(system.raw, rhs.raw))
    }
}

extension Matrix {
    // MARK: - Slicing
    
    /// 一部を取り出す
    func sliced(firstRow: la_index_t, firstCol: la_index_t, sliceRows: la_count_t, sliceCols: la_count_t, rowStride: la_index_t = 1, colStride: la_index_t = 1) -> Matrix? {
        return Matrix(la_matrix_slice(raw, firstRow, firstCol, rowStride, colStride, sliceRows, sliceCols))
    }
    
    /// 横ベクトルを取り出す
    func vectorFromRow(_ row: la_count_t) -> Matrix? {
        return Matrix(la_vector_from_matrix_row(raw, row))
    }
    
    /// 縦ベクトルを取り出す
    func vectorFromCol(_ col: la_count_t) -> Matrix? {
        return Matrix(la_vector_from_matrix_col(raw, col))
    }
    
    func vectorFromDiagonal(_ diagonal: la_index_t = 0) -> Matrix? {
        return Matrix(la_vector_from_matrix_diagonal(raw, diagonal))
    }
}

extension LaObjectWrapperType {
    // MARK: - Transforming
    
    func transposed() -> Matrix? {
        return Matrix(la_transpose(raw))
    }
    
    func scaled(by scale: Double) -> Matrix? {
        return Matrix(la_scale_with_double(raw, scale))
    }
}

struct Vector {
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
    
    fileprivate init?(_ vector: la_object_t) {
        guard la_status(vector) == LA_SUCCESS else {
            debugPrint("Vector initializing error: \(la_status(vector))")
            return nil
        }
        self.raw = vector
    }
}


extension Vector: LaObjectWrapperType {
    // MARK: - For vectors
    
    var length: la_count_t {
        return la_vector_length(raw)
    }
    
    /// 内積
    static func innerProduct(_ lhs: Vector, _ rhs: Vector) -> Double? {
        return Vector(la_inner_product(lhs.raw, rhs.raw))?.getComponents().first
    }
    
    /// 外積
    static func outerProduct(_ lhs: Vector, _ rhs: Vector) -> Vector? {
        return Vector(la_outer_product(lhs.raw, rhs.raw))
    }
    
    func norm(_ norm: la_norm_t = la_norm_t(LA_L1_NORM)) -> Double? {
        return la_norm_as_double(raw, norm)
    }
    
    func normalized(_ norm: la_norm_t = la_norm_t(LA_L1_NORM)) -> Vector? {
        return Vector(la_normalized_vector(raw, norm))
    }
    
}
