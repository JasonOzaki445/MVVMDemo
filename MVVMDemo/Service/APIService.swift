//
//  APIService.swift
//  MVVMDemo
//
//  Created by Jason Chen on 2019/10/17.
//  Copyright © 2019 Jason Chen. All rights reserved.
//

import Foundation

//
// MARK: - The Enums of the API Error
//
enum APIError: String, Error {
    case noNetwork = "No network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

//
// MARK: Protocol for API Service
//
protocol APIServiceProtocol {
    func fetchPopularPhoto( complete: @escaping ( _ success: Bool, _ photos: [Photo], _ error: APIError? ) -> () )
}

//
// MARK: - APIService
//
// Runs query data task, and stores results in array of Photos
class APIService: APIServiceProtocol {
    // Simulate a long waiting for fetching
    func fetchPopularPhoto( complete: @escaping ( _ success: Bool, _ photos: [Photo], _ error: APIError? ) -> () ) {
        DispatchQueue.global().async {
            sleep(3)
            let path = Bundle.main.path(forResource: "content", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let photos = try! decoder.decode(Photos.self, from: data)
            complete( true, photos.photos, nil )
        }
    }
}
