//
//  GFError.swift
//  GHFollowersREMAKE
//
//  Created by billy pak on 5/5/21.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "unable to complete your request. Please check your internet connection"
    case invalidResponse = "invalid response from the server. Please try again"
    case invalidData = "Data recieved was invalid"
    case unableToFavorite = "Unable to add to Favorites"
    case alreadyInFavorites = "You've already favorited this user"
}
