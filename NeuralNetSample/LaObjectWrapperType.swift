//
//  LaObjectWrapperType.swift
//  NeuralNetSample
//
//  Created by はるふ on 2018/05/29.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import Foundation
import Accelerate

protocol LaObjectWrapperType {
    var raw: la_object_t { get }
    
    init?(_: la_object_t)
}

extension LaObjectWrapperType {
    // MARK: - Transforming
    
    func transposed() -> Self? {
        return Self(la_transpose(raw))
    }
    
    func scaled(by scale: Double) -> Self? {
        return Self(la_scale_with_double(raw, scale))
    }
}

extension LaObjectWrapperType {
    // MARK: - Static Operator
    
    /// サイズが同じである必要がある
    static func sum(_ lhs: Self, _ rhs: Self) -> Self? {
        return Self(la_sum(lhs.raw, rhs.raw))
    }
    
    /// サイズが同じである必要がある
    static func difference(_ lhs: Self, _ rhs: Self) -> Self? {
        return Self(la_difference(lhs.raw, rhs.raw))
    }
    
    /// 積
    static func product(_ lhs: LaObjectWrapperType, _ rhs: LaObjectWrapperType) -> Matrix? {
        return Matrix(la_matrix_product(lhs.raw, rhs.raw))
    }
    
    /// アダマール積
    /// サイズが同じである必要がある
    static func elementwiseProduct(_ lhs: Self, _ rhs: Self) -> Self? {
        return Self(la_elementwise_product(lhs.raw, rhs.raw))
    }
    
    // solve AX=B
    static func solve(_ system: Matrix, _ rhs: LaObjectWrapperType) -> Matrix? {
        return Matrix(la_solve(system.raw, rhs.raw))
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
