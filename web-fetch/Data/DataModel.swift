//
//  DataModel.swift
//  web-fetch
//
//  Created by Thalia Nero on 4/6/24.
//

import Foundation
import UIKit
import SwiftUI

/// URL of the meal summary data.
let summaryUrl = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!

/// Data about a meal to be shown in the summary view.
struct MealSummary: Hashable, Codable, Identifiable {
    /// The unique identifier for the meal.
    var id: String
    
    /// The name of the meal to show.
    var name: String
    
    /// The URL at which the imagge thumbnail is located.
    var imageUrl: URL
    
    /// The URL at which the preview thumbnail is located.
    var previewUrl: URL {
        imageUrl.appending(path: "preview")
    }
    
    /// Coding keys for this type.
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case imageUrl = "strMealThumb"
    }
}

/// A single ingredient for a meal.
struct Ingredient: Hashable, Identifiable {
    /// The ID (index) of the ingredient.
    var id: Int
    
    /// The name of the ingredient.
    var name: String
    
    /// The amount of the ingredient to use in the recipe.
    var measure: String
}

/// Recipe details for a meal.
struct MealDetail: Hashable, Decodable {
    /// Name of the meal.
    var name: String
    
    /// Ingredients of the meal.
    var ingredients: [Ingredient]
    
    /// Instructions for preparing the meal.
    var instructions: String
    
    /// Image depicting the meal.
    var image: URL
    
    internal init(name: String, ingredients: [Ingredient], instructions: String, image: URL) {
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.image = image
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .strMeal)
        self.instructions = try container.decode(String.self, forKey: .strInstructions)
        self.image = try container.decode(URL.self, forKey: .strMealThumb)
        self.ingredients = []
        for idx in 0..<20 {
            let ingredient = try container.decode(String.self, forKey: .ingredientKeys[idx])
            let measure = try container.decode(String.self, forKey: .measureKeys[idx])
            if ingredient.isEmpty || measure.isEmpty {
                break
            }
            self.ingredients.append(Ingredient(id: idx, name: ingredient, measure: measure))
        }
    }
    
    /// Coding keys for this type.
    enum CodingKeys: CodingKey {
        case strMeal
        case strInstructions
        case strMealThumb
        case strIngredient1
        case strIngredient2
        case strIngredient3
        case strIngredient4
        case strIngredient5
        case strIngredient6
        case strIngredient7
        case strIngredient8
        case strIngredient9
        case strIngredient10
        case strIngredient11
        case strIngredient12
        case strIngredient13
        case strIngredient14
        case strIngredient15
        case strIngredient16
        case strIngredient17
        case strIngredient18
        case strIngredient19
        case strIngredient20
        case strMeasure1
        case strMeasure2
        case strMeasure3
        case strMeasure4
        case strMeasure5
        case strMeasure6
        case strMeasure7
        case strMeasure8
        case strMeasure9
        case strMeasure10
        case strMeasure11
        case strMeasure12
        case strMeasure13
        case strMeasure14
        case strMeasure15
        case strMeasure16
        case strMeasure17
        case strMeasure18
        case strMeasure19
        case strMeasure20
        
        /// Keys used for ingredients.
        static var ingredientKeys: [CodingKeys] {
            [
                .strIngredient1,
                .strIngredient2,
                .strIngredient3,
                .strIngredient4,
                .strIngredient5,
                .strIngredient6,
                .strIngredient7,
                .strIngredient8,
                .strIngredient9,
                .strIngredient10,
                .strIngredient11,
                .strIngredient12,
                .strIngredient13,
                .strIngredient14,
                .strIngredient15,
                .strIngredient16,
                .strIngredient17,
                .strIngredient18,
                .strIngredient19,
                .strIngredient20,
            ]
        }
        
        /// Keys used for measures.
        static var measureKeys: [CodingKeys] {
            [
                .strMeasure1,
                .strMeasure2,
                .strMeasure3,
                .strMeasure4,
                .strMeasure5,
                .strMeasure6,
                .strMeasure7,
                .strMeasure8,
                .strMeasure9,
                .strMeasure10,
                .strMeasure11,
                .strMeasure12,
                .strMeasure13,
                .strMeasure14,
                .strMeasure15,
                .strMeasure16,
                .strMeasure17,
                .strMeasure18,
                .strMeasure19,
                .strMeasure20,
            ]
        }
    }
}

/// Response data about some set of meals.
struct Meals<T: Decodable>: Decodable {
    var meals: [T]
}

/// Loads meal summaries from a given URL.
/// - parameter url: The URL to load from.
/// - returns: The set of meals, or an empty array if the meals cannot be loaded.
func loadSummaries(url: URL) async -> [MealSummary] {
    let session = URLSession.shared
    do { 
        let (data, _) = try await session.data(from: url)
        let meals = try JSONDecoder().decode(Meals<MealSummary>.self, from: data)
        return meals.meals.filter { summary in
            !summary.id.isEmpty && !summary.name.isEmpty
        }
    } catch {
        return []
    }
}

/// Loads detail data for the given meal.
/// - parameter mealId: The ID of the meal.
/// - returns: The meal's details, or nil if the details cannot be loaded.
func loadDetail(mealId: String) async -> MealDetail? {
    let session = URLSession.shared
    let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealId)")!
    do {
        let (data, _) = try await session.data(from: url)
        let meals = try JSONDecoder().decode(Meals<MealDetail>.self, from: data)
        if meals.meals.count > 0 {
            return meals.meals[0]
        } else {
            return nil
        }
    } catch {
        return nil
    }
}

/// Loads an image view for an image stored at the given URL.
/// - parameter url: The URL to load from.
/// - returns: An image view containing the image, or if an error occurs an default system image.
func loadImage(_ url: URL) async -> Image {
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage).resizable()
        } else {
            return Image(systemName: "photo")
        }
    } catch {
        return Image(systemName: "photo")
    }
}
