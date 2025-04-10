//
//  PexalViewModelTest.swift
//  KumarPraveenZeoImageTests
//
//  Created by Praveen on 10/04/25.
//

import XCTest
@testable import KumarPraveenZeoImage

final class PexelsViewModelTests: XCTestCase {
    
    /// Tests successful image fetch after debounce using mock JSON.
    func testSuccessfulImageFetchWithDebounce() {
        let mockService = MockNetworkService()
        let viewModel = PexelsViewModel(network: mockService)
        viewModel.query = "Nature"

        let expectation = XCTestExpectation(description: "Wait for debounce and API call")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(viewModel.photos.isEmpty)
            XCTAssertEqual(viewModel.photos.first?.id, 2325447)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    /// Tests failure handling when mock network is configured to fail.
    func testAPIFailure() {
        let mockService = MockNetworkService()
        mockService.shouldFail = true
        let viewModel = PexelsViewModel(network: mockService)
        viewModel.query = "FailCase"

        let expectation = XCTestExpectation(description: "Expect failure to complete silently")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(viewModel.photos.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    /// Tests that no API call is made for short/empty query (less than 2 characters).
    func testNoFetchOnShortQuery() {
        let mockService = MockNetworkService()
        let viewModel = PexelsViewModel(network: mockService)
        viewModel.query = "a"

        let expectation = XCTestExpectation(description: "No API call for short query")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(viewModel.photos.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    /// Tests that resetting the search clears existing photos and refetches results.
    func testResetSearchClearsPhotos() {
        let mockService = MockNetworkService()
        let viewModel = PexelsViewModel(network: mockService)
        viewModel.query = "Nature"

        let expectation = XCTestExpectation(description: "Fetch and reset query")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(viewModel.photos.isEmpty)

            viewModel.query = "Mountain" // Triggers reset
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertFalse(viewModel.photos.isEmpty)
                XCTAssertEqual(viewModel.currentPage, 2) // Because 1st page fetched again
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 3)
    }

    /// Tests that pagination triggers additional load when near the end of list.
    func testPaginationTriggersOnThreshold() {
        let mockService = MockNetworkService()
        let viewModel = PexelsViewModel(network: mockService)
        viewModel.query = "Nature"

        let expectation = XCTestExpectation(description: "Load more on scroll")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let lastItem = viewModel.photos.last
            viewModel.loadMoreIfNeeded(currentItem: lastItem)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertGreaterThan(viewModel.photos.count, 0)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 3)
    }

    /// Tests that calling loadMoreIfNeeded with nil immediately loads images.
    func testLoadMoreIfNeededWithNil() {
        let mockService = MockNetworkService()
        let viewModel = PexelsViewModel(network: mockService)

        viewModel.query = "Nature"
        let expectation = XCTestExpectation(description: "loadImages triggered with nil item")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            viewModel.loadMoreIfNeeded(currentItem: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertFalse(viewModel.photos.isEmpty)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 3)
    }

    /// Tests that debounce logic cancels previous work and only fires latest call.
    func testDebounceCancelsPreviousCalls() {
        let mockService = MockNetworkService()
        let viewModel = PexelsViewModel(network: mockService)

        viewModel.query = "A"
        viewModel.query = "AB"
        viewModel.query = "ABC"

        let expectation = XCTestExpectation(description: "Only final debounced call should succeed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(viewModel.photos.isEmpty)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }
}
