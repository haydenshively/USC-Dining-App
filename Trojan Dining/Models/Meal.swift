//
//  Meal.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 12/7/19.
//  Copyright © 2019 Hayden Shively. All rights reserved.
//

import UIKit

public final class Meal: DataDuct, CollectableData {
    public let CorrespondingView: CollectableCell.Type = MealCell.self

    public static let COLOR_BREAKFAST = UIColor(red: 254/255.0, green: 229/255.0, blue: 203/255.0, alpha: 1.0)
    public static let COLOR_LUNCH = UIColor(red: 193/255.0, green: 225/255.0, blue: 231/255.0, alpha: 1.0)
    public static let COLOR_DINNER = UIColor(red: 240/255.0, green: 144/255.0, blue: 138/255.0, alpha: 1.0)

    public let name: String
    public let date: String
    public let halls: [String]
    public let sections: [[String]]
    public let foods: [[[Food]]]
    public private(set) lazy var isServed: Bool = {[unowned self] in
        return (foods.reduce(0, {$0 + $1.reduce(0, {$0 + $1.count})}) > 0) && withinHours(for: self)
    }()

    public private(set) var filteredFoods: [[[Food]]]

    init(name: String, date: String, halls: [String], sections: [[String]], foods: [[[Food]]]) {
        self.name = name
        self.date = date
        self.halls = halls
        self.sections = sections
        self.foods = foods

        self.filteredFoods = foods
    }

    convenience init(fromHTMLMeal htmlMeal: MenuBuilder.HTMLMeal) {
        var halls: [String] = []
        var sections: [[String]] = []
        var foods: [[[Food]]] = []
        
        for i in 0..<htmlMeal.halls.count {
            var htmlHall = htmlMeal.halls[i]
            halls.append(htmlHall.decodedName)
            sections.append([])
            foods.append([])
            for htmlSection in htmlHall.sections {
                sections[sections.endIndex - 1].append(htmlSection.name)
                foods[foods.endIndex - 1].append([])
                for htmlFood in htmlSection.foods {
                    let food = Food(name: htmlFood.name, hall: htmlHall.decodedName, section: htmlSection.name, attributes: htmlFood.allergens)
                    foods[foods.endIndex - 1][foods[foods.endIndex - 1].endIndex - 1].append(food)
        }}}
        
        let iVillage = halls.firstIndex(of: Food.hallLongName("Village"))!
        let iEVK = halls.firstIndex(of: Food.hallLongName("EVK"))!
        let iParkside = halls.firstIndex(of: Food.hallLongName("Parkside"))!
        
        let orderedHalls = [halls[iVillage], halls[iEVK], halls[iParkside]]
        let orderedSections = [sections[iVillage], sections[iEVK], sections[iParkside]]
        let orderedFoods = [foods[iVillage], foods[iEVK], foods[iParkside]]

        self.init(name: htmlMeal.shortName, date: htmlMeal.dateText, halls: orderedHalls, sections: orderedSections, foods: orderedFoods)
    }

    public func apply(_ filter: Filter) {
        filteredFoods = []
        for hall in foods {
            filteredFoods.append([])
            for section in hall {
                filteredFoods[filteredFoods.endIndex - 1].append(section.filter {$0.passes(filter)})
            }
        }
    }

    public func getColor() -> UIColor {
        switch name {
        case "Breakfast":
            return Meal.COLOR_BREAKFAST
        case "Brunch":
            return Meal.COLOR_BREAKFAST
        case "Lunch":
            return Meal.COLOR_LUNCH
        case "Dinner":
            return Meal.COLOR_DINNER
        default:
            return UIColor.darkGray
        }
    }
}


public func latestHours(for meal: Meal) -> Date? {
    let cal = Calendar(identifier: .gregorian)

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM d, yyyy"
    let startOfDay = dateFormatter.date(from: meal.date)!

    switch (meal.name) {
    case "Breakfast": return cal.date(bySettingHour: 10, minute: 30, second: 0, of: startOfDay)
    case "Brunch": return cal.date(bySettingHour: 15, minute: 0, second: 0, of: startOfDay)
    case "Lunch": return cal.date(bySettingHour: 15, minute: 0, second: 0, of: startOfDay)
    case "Dinner": return cal.date(bySettingHour: 22, minute: 0, second: 0, of: startOfDay)
    default: return cal.date(bySettingHour: 22, minute: 0, second: 0, of: startOfDay)
    }
}

public func withinHours(for meal: Meal) -> Bool {
    guard let closingTime = latestHours(for: meal) else {return true}

    let now = Date()
    return now.compare(closingTime) == .orderedAscending
}
