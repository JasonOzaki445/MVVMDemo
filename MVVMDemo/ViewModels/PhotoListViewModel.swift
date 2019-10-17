//
//  PhotoListViewModel.swift
//  MVVMDemo
//
//  Created by Jason Chen on 2019/10/17.
//  Copyright © 2019 Jason Chen. All rights reserved.
//

import Foundation

//
// MARK: - Photo List View Model
//
class PhotoListViewModel {
    // Initialize the constant APIServiceProtocol
    let apiService: APIServiceProtocol
    // Declare private variables and initialize
    private var photos: [Photo] = [Photo]()
    private var cellViewModels: [PhotoListCellViewModel]  = [PhotoListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var isAllowSegue: Bool = false
    var selectedPhoto: Photo?
    var reloadTableViewClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var showAlertClosure: (() -> ())?
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func initFetch() {
        self.isLoading = true
        apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.rawValue
            } else {
                self?.processFetchedPhoto(photos: photos)
            }
        }
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> PhotoListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel(photo: Photo) -> PhotoListCellViewModel {

        // Wrap a description
        var descTextContainer: [String] = [String]()
        if let camera = photo.camera {
            descTextContainer.append(camera)
        }
        if let description = photo.description {
            descTextContainer.append(description)
        }
        let desc = descTextContainer.joined(separator: " - ")
        
        // Wrap the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return PhotoListCellViewModel(titleText: photo.name,
                                      descText: desc,
                                      imageUrl: photo.image_url,
                                      dateText: dateFormatter.string(from: photo.created_at))
    }
    
    private func processFetchedPhoto(photos: [Photo]) {
        self.photos = photos // Cache
        var vms = [PhotoListCellViewModel]()
        for photo in photos {
            vms.append(createCellViewModel(photo: photo))
        }
        self.cellViewModels = vms
    }
}

//
// MARK: - Handle The User intractive
//
extension PhotoListViewModel {
    func userPressed(at indexPath: IndexPath) {
        let photo = self.photos[indexPath.row]
        if photo.for_sale {
            self.isAllowSegue = true
            self.selectedPhoto = photo
        } else {
            self.isAllowSegue = false
            self.selectedPhoto = nil
            self.alertMessage = "This item is not for sale"
        }
    }
}

//
// MARK: - The ViewModel Of The Photo List Cell
//
struct PhotoListCellViewModel {
    let titleText: String
    let descText: String
    let imageUrl: String
    let dateText: String
}
