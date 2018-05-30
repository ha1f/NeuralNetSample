//
//  Matrix.swift
//  NeuralNetSample
//
//  Created by ST20591 on 2018/05/28.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import Foundation
import Accelerate

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
    
    init?(_ matrix: la_object_t) {
        guard la_status(matrix) == LA_SUCCESS else {
            debugPrint("Matrix initializing error: \(la_status(matrix))")
            return nil
        }
        self.raw = matrix
    }
}

extension Matrix {
    // MARK: - Static Builder
    
    static func identity(_ size: la_count_t) -> Matrix {
        return Matrix(la_identity_matrix(size, la_scalar_type_t(LA_SCALAR_TYPE_DOUBLE), la_attribute_t(LA_DEFAULT_ATTRIBUTES)))!
    }
    
    static func diagonal(_ array: [Double], diagonal: la_index_t = 0) -> Matrix {
        let vector = Vector(array: array)!
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
    // MARK: - Slicing
    
    /// 一部を取り出す
    func sliced(firstRow: la_index_t, firstCol: la_index_t, sliceRows: la_count_t, sliceCols: la_count_t, rowStride: la_index_t = 1, colStride: la_index_t = 1) -> Matrix? {
        return Matrix(la_matrix_slice(raw, firstRow, firstCol, rowStride, colStride, sliceRows, sliceCols))
    }
    
    /// 横ベクトルを取り出す
    func vectorFromRow(_ row: la_count_t) -> Vector? {
        return Vector(la_vector_from_matrix_row(raw, row))
    }
    
    /// 縦ベクトルを取り出す
    func vectorFromCol(_ col: la_count_t) -> Vector? {
        return Vector(la_vector_from_matrix_col(raw, col))
    }
    
    func vectorFromDiagonal(_ diagonal: la_index_t = 0) -> Vector? {
        return Vector(la_vector_from_matrix_diagonal(raw, diagonal))
    }
    
    func asVector() -> Vector? {
        let components = getComponents()
        if cols == 1 {
            return Vector(array: components, isColumn: true)
        } else if rows == 1 {
            return Vector(array: components, isColumn: false)
        }
        return nil
    }
}
