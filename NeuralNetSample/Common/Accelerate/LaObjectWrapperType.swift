//
//  LaObjectWrapperType.swift
//  NeuralNetSample
//
//  Created by はるふ on 2018/05/29.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import Foundation
import Accelerate

protocol LaObjectWrapperType: RawRepresentable where RawValue == la_object_t {
}

extension LaObjectWrapperType {
    // MARK: - Transforming
    
    func transposed() -> Self? {
        return Self(rawValue: la_transpose(rawValue))
    }
    
    func scaled(by scale: Double) -> Self? {
        return Self(rawValue: la_scale_with_double(rawValue, scale))
    }
}

extension LaObjectWrapperType {
    // MARK: - Static Operator
    
    /// サイズが同じである必要がある
    static func sum(_ lhs: Self, _ rhs: Self) -> Self? {
        return Self(rawValue: la_sum(lhs.rawValue, rhs.rawValue))
    }
    
    /// サイズが同じである必要がある
    static func difference(_ lhs: Self, _ rhs: Self) -> Self? {
        return Self(rawValue: la_difference(lhs.rawValue, rhs.rawValue))
    }
    
    /// 積
    static func product<T: LaObjectWrapperType, U: LaObjectWrapperType>(_ lhs: T, _ rhs: U) -> Matrix? {
        return Matrix(rawValue: la_matrix_product(lhs.rawValue, rhs.rawValue))
    }
    
    /// アダマール積
    /// サイズが同じである必要がある
    static func elementwiseProduct(_ lhs: Self, _ rhs: Self) -> Self? {
        return Self(rawValue: la_elementwise_product(lhs.rawValue, rhs.rawValue))
    }
    
    // solve AX=B
    static func solve<T: LaObjectWrapperType>(_ system: Matrix, _ rhs: T) -> Matrix? {
        return Matrix(rawValue: la_solve(system.rawValue, rhs.rawValue))
    }
}

extension LaObjectWrapperType {
    var rows: la_count_t {
        return la_matrix_rows(rawValue)
    }
    
    var cols: la_count_t {
        return la_matrix_cols(rawValue)
    }
    
    var status: la_status_t {
        return la_status(rawValue)
    }
    
    func getComponents() -> [Double] {
        let cols = self.cols
        var buffer = [Double](repeating: 0, count: Int(cols * rows))
        la_matrix_to_double_buffer(&buffer, cols, rawValue)
        return buffer
    }
}
