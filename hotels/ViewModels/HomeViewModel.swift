import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var hotels: [Hotel] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    
    private let hotelService = HotelService.shared
    private var searchTask: Task<Void, Never>?
    
    init() {
        Task {
            await loadHotels()
        }
    }
    
    @MainActor
    func loadHotels() async {
        isLoading = true
        do {
            hotels = try await hotelService.getHotels()
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func searchHotels(query: String) async {
        // Cancel any existing search task
        searchTask?.cancel()
        
        guard !query.isEmpty else {
            await loadHotels()
            return
        }
        
        isLoading = true
        do {
            hotels = try await hotelService.searchHotels(query: query)
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func applyFilter(_ filter: FilterOption) async {
        isLoading = true
        do {
            switch filter {
            case .all:
                hotels = try await hotelService.getHotels()
            case .luxury:
                hotels = try await hotelService.getHotels(minPrice: 300)
            case .business:
                hotels = try await hotelService.getHotels(minRating: 4.5)
            case .budget:
                hotels = try await hotelService.getHotels(maxPrice: 200)
            }
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func applyPriceFilter(range: ClosedRange<Double>) async {
        isLoading = true
        do {
            hotels = try await hotelService.getHotels(
                minPrice: range.lowerBound,
                maxPrice: range.upperBound
            )
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func clearError() {
        showError = false
        errorMessage = nil
    }
    
    deinit {
        searchTask?.cancel()
    }
}
