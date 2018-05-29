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
