//
//  SigmoidLayer.swift
//  NeuralNetSample
//
//  Created by ST20591 on 2018/05/30.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import Foundation
import Accelerate

class SigmoidLayer: LayerType {
    private var _outputCache: [Double]?
    
    func forward(batchInput input: Matrix) -> Matrix {
        let components = input.getComponents()
        
        let length = components.count
        var results = [Double](repeating: 0, count: length)
        let ones = [Double](repeating: 1, count: length)
        
        components.withUnsafeBufferPointer { pointer0 in
            results.withUnsafeMutableBufferPointer { resultPointer in
                cblas_dcopy(Int32(length), pointer0.baseAddress!, 1, resultPointer.baseAddress!, 1)
                cblas_dscal(Int32(length), -1, resultPointer.baseAddress!, 1)
                vvexp(resultPointer.baseAddress!, resultPointer.baseAddress!, [numericCast(length)])
                vDSP_vaddD(resultPointer.baseAddress!, 1, ones, 1, resultPointer.baseAddress!, 1, vDSP_Length(length))
                vvrec(resultPointer.baseAddress!, resultPointer.baseAddress!, [numericCast(length)])
            }
        }
        
        return Matrix(array: results, rows: input.rows, cols: input.cols)!
        // return Matrix(array: components.map { 1 / (1 + exp(-$0)) }, rows: input.rows, cols: input.cols)!
    }
    
    func forward(_ input: [Double]) -> [Double] {
        let result = input.map { 1 / (1 + exp(-$0)) }
        _outputCache = result
        return result
    }
    
    func backward(_ input: [Double]) -> [Double] {
        // nilならエラーをはきたい
        return _outputCache ?? []
    }
}
