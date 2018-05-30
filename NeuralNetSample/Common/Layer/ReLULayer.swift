//
//  ReLULayer.swift
//  NeuralNetSample
//
//  Created by ST20591 on 2018/05/30.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import Foundation

class ReLULayer: LayerType {
    func forward(_ input: [Double]) -> [Double] {
        return input.map { $0 < 0 ? 0 : $0 }
    }
    
    func backward(_ input: [Double]) -> [Double] {
        return input.map { $0 < 0 ? 0 : 1 }
    }
}
