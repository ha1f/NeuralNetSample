//
//  Zip3Sequence.swift
//  NeuralNetSample
//
//  Created by ST20591 on 2018/05/28.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import Foundation

/// An iterator for `Zip3Sequence`.
public struct Zip3Iterator<Iterator1, Iterator2, Iterator3> where Iterator1 : IteratorProtocol, Iterator2 : IteratorProtocol, Iterator3 : IteratorProtocol {
    fileprivate var _iterator1: Iterator1
    fileprivate var _iterator2: Iterator2
    fileprivate var _iterator3: Iterator3
    
    init(_ iterator1: Iterator1, _ iterator2: Iterator2, _ iterator3: Iterator3) {
        self._iterator1 = iterator1
        self._iterator2 = iterator2
        self._iterator3 = iterator3
    }
}

extension Zip3Iterator : IteratorProtocol {
    
    /// The type of element returned by `next()`.
    public typealias Element = (Iterator1.Element, Iterator2.Element, Iterator3.Element)
    
    /// Advances to the next element and returns it, or `nil` if no next element
    /// exists.
    ///
    /// Once `nil` has been returned, all subsequent calls return `nil`.
    public mutating func next() -> Zip3Iterator.Element? {
        guard let next1 = _iterator1.next(),
            let next2 = _iterator2.next(),
            let next3 = _iterator3.next() else {
            return nil
        }
        return (next1, next2, next3)
    }
}

/// A sequence of set built out of three underlying sequences.
public struct Zip3Sequence<Sequence1, Sequence2, Sequence3> where Sequence1 : Sequence, Sequence2 : Sequence, Sequence3: Sequence {
    private let _sequence1: Sequence1
    private let _sequence2: Sequence2
    private let _sequence3: Sequence3
    
    init(_ sequence1: Sequence1, _ sequence2: Sequence2, _ sequence3: Sequence3) {
        self._sequence1 = sequence1
        self._sequence2 = sequence2
        self._sequence3 = sequence3
    }
}

extension Zip3Sequence : Sequence {
    
    /// A type whose instances can produce the elements of this
    /// sequence, in order.
    public typealias Iterator = Zip3Iterator<Sequence1.Iterator, Sequence2.Iterator, Sequence3.Iterator>
    
    /// Returns an iterator over the elements of this sequence.
    public func makeIterator() -> Zip3Sequence.Iterator {
        return Zip3Iterator.init(_sequence1.makeIterator(), _sequence2.makeIterator(), _sequence3.makeIterator())
    }
}

public func zip<Sequence1, Sequence2, Sequence3>(_ sequence1: Sequence1, _ sequence2: Sequence2, _ sequence3: Sequence3) -> Zip3Sequence<Sequence1, Sequence2, Sequence3> where Sequence1 : Sequence, Sequence2 : Sequence, Sequence3: Sequence {
    return Zip3Sequence(sequence1, sequence2, sequence3)
}
