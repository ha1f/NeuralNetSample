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
    let rawValue: la_object_t
    
    /// 対角行列とかのときはヒントを指定するとはやくなるかも
    init?(array: [Double], rows: la_count_t, cols: la_count_t, hint: la_hint_t = la_hint_t(LA_NO_HINT)) {
        guard array.count == rows * cols else {
            debugPrint("array.count(\(array.count) does not matches rows * cols(\(rows * cols)")
            return nil
        }
        let matrix = la_matrix_from_double_buffer(array, rows, cols, cols, hint, la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        self.init(rawValue: matrix)
    }
    
    init?(rawValue matrix: la_object_t) {
        guard la_status(matrix) == LA_SUCCESS else {
            debugPrint("Matrix initializing error: \(la_status(matrix))")
            return nil
        }
        self.rawValue = matrix
    }
    
    func asVector() -> Vector? {
        if cols == 1 {
            return Vector.fromRow(of: self, at: 0)
        } else if rows == 1 {
            return Vector.fromCol(of: self, at: 0)
        }
        return nil
    }
}

extension Matrix {
    // MARK: - Static Builder
    
    /// 単位行列
    static func identity(_ size: la_count_t) -> Matrix {
        return Matrix(rawValue: la_identity_matrix(size, la_scalar_type_t(LA_SCALAR_TYPE_DOUBLE), la_attribute_t(LA_DEFAULT_ATTRIBUTES)))!
    }
    
    /// 対角行列
    static func diagonal(_ array: [Double], diagonal: la_index_t = 0) -> Matrix {
        let vector = Vector(array: array)!
        return Matrix(rawValue: la_diagonal_matrix_from_vector(vector.rawValue, diagonal))!
    }
}

extension Matrix {
    // MARK: - Slicing
    
    /// 一部を取り出す
    func sliced(firstRow: la_index_t, firstCol: la_index_t, sliceRows: la_count_t, sliceCols: la_count_t, rowStride: la_index_t = 1, colStride: la_index_t = 1) -> Matrix? {
        return Matrix(rawValue: la_matrix_slice(rawValue, firstRow, firstCol, rowStride, colStride, sliceRows, sliceCols))
    }
}

extension Matrix: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Matrix(rows: \(rows), cols: \(cols), \(getComponents())"
    }
}
