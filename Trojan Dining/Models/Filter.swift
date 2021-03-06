//
//  Filter.swift
//  USC Dining
//
//  Created by Hayden Shively on 12/3/18.
//  Copyright © 2019 Golden Age Technologies LLC. All rights reserved.
//

import Foundation

public protocol DataDuct {
    func apply(_ filter: Filter)
}

public class Filter {
    public var specifications: [AttributeStatus]

    init(specifications: [AttributeStatus]) {
        self.specifications = specifications
    }

    convenience init(unacceptable unacceptableAttributes: [String], required requiredAttributes: [String]) {
        self.init(specifications: Filter.standardize(unacceptable: unacceptableAttributes, required: requiredAttributes))
    }

    private static func standardize(unacceptable unacceptableAttributes: [String], required requiredAttributes: [String]) -> [AttributeStatus] {
        var standardized = [AttributeStatus](repeating: .inconsequential, count: Food.POSSIBLE_ATTRIBUTES.count)
        for attribute in unacceptableAttributes {
            guard let attributeIndex: Int = Food.POSSIBLE_ATTRIBUTES[attribute] else {fatalError("Searched for an attribute that doesn't exist! :: \(attribute)")}
            standardized[attributeIndex] = .absent
        }

        for attribute in requiredAttributes {
            guard let attributeIndex: Int = Food.POSSIBLE_ATTRIBUTES[attribute] else {fatalError("Searched for an attribute that doesn't exist! :: \(attribute)")}
            standardized[attributeIndex] = .present
        }

        return standardized
    }

    public func cycleStatus(at index: Int) {
        var status = specifications[index]
        switch status {
        case .inconsequential: status = .present
        case .present: status = .absent
        case .absent: status = .inconsequential
        }
        specifications[index] = status
    }
    
    public func save() {
        UserDefaults.standard.set(specifications.map({$0.rawValue}), forKey: "Filter")
    }
    
    public func load() {
        guard let savedFilter = UserDefaults.standard.array(forKey: "Filter") as? [String] else {return}
        specifications = savedFilter.map({AttributeStatus(rawValue: $0)!})
    }

    public enum AttributeStatus: String {case inconsequential, absent, present}
}
