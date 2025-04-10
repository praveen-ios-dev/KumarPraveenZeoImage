//
//  PexelsViewModel.swift
//  KumarPraveenZeoImage
//
//  Created by Praveen on 10/04/25.
//

import Foundation

/// ViewModel responsible for managing image search and pagination using the Pexels API.
class PexelsViewModel: ObservableObject {
    /// Published array of fetched Pexels photos.
    @Published var photos: [PexelsPhoto] = []
    
    /// Search query string that triggers image fetch when changed.
    @Published var query: String = "" {
        didSet {
            debounceSearch()
        }
    }
    
    var currentPage = 1
    private var isLoading = false
    private var hasMorePages = true
    private var workItem: DispatchWorkItem?
    private var network: NetworkServiceProtocol
    
    /// Initializes the view model with a given network service.
    init(network: NetworkServiceProtocol = NetworkService.shared){
        self.network = network
    }
    
    
    /// Loads more images if the current item is near the end of the list.
    func loadMoreIfNeeded(currentItem item: PexelsPhoto?) {
        guard let item = item else {
            loadImages()
            return
        }
        
        let thresholdIndex = photos.index(photos.endIndex, offsetBy: -5)
        if photos.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadImages()
        }
    }
    
    /// Triggers a debounced image search after a short delay to avoid rapid API calls.
    private func debounceSearch() {
        workItem?.cancel()
        
        // Debounce delay
        let newWorkItem = DispatchWorkItem { [weak self] in
            self?.loadImages(reset: true)
        }
        workItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: newWorkItem)
        
    }
    
    /// Loads images from the network, optionally resetting pagination.
    func loadImages(reset: Bool = false) {
        isLoading = true
        if reset {
            currentPage = 1
            photos = []
            hasMorePages = true
        }
        
        network.fetchImages(query: query, page: currentPage, perPage: 40) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.photos.append(contentsOf: response.photos)
                    self.hasMorePages = !response.photos.isEmpty
                    self.currentPage += 1
                case .failure(_):
                    print(AppConstant.apiFetchErrorMsg)
                }
            }
        }
    }
}
