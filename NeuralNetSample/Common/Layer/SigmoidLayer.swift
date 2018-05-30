//
//  SigmoidLayer.swift
//  NeuralNetSample
//
//  Created by ST20591 on 2018/05/30.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import Foundation

class SigmoidLayer: LayerType {
    private var _outputCache: [Double]?
    
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
