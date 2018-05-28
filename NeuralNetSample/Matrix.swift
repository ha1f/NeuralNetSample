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
struct Matrix {
    let raw: la_object_t
    
    var rows: la_count_t {
        return la_matrix_rows(raw)
    }
    
    var cols: la_count_t {
        return la_matrix_cols(raw)
    }
    
    /// 対角行列とかのときはヒントを指定するとはやくなる
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
    
    func getComponents() -> [Double] {
        let rows = self.rows
        var buffer = [Double].init(repeating: 0, count: Int(rows * cols))
        la_matrix_to_double_buffer(&buffer, rows, raw)
        return buffer
    }
}

extension Matrix {
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
}

extension Matrix {
    func sliced(firstRow: la_index_t, firstCol: la_index_t, sliceRows: la_count_t, sliceCols: la_count_t, rowStride: la_index_t = 1, colStride: la_index_t = 1) -> Matrix? {
        return Matrix(la_matrix_slice(raw, firstRow, firstCol, rowStride, colStride, sliceRows, sliceCols))
    }
    
    func vector(row: la_count_t) -> Matrix? {
        return Matrix(la_vector_from_matrix_row(raw, row))
    }
    
    func vector(col: la_count_t) -> Matrix? {
        return Matrix(la_vector_from_matrix_col(raw, col))
    }
    
    func diagonalVector(_ diagonal: la_index_t = 0) -> Matrix? {
        return Matrix(la_vector_from_matrix_diagonal(raw, diagonal))
    }
}
