import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText = ""
    @State private var selectedFilter = FilterOption.all
    @State private var showingFilters = false
    @State private var priceRange: ClosedRange<Double> = 50...500
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText)
                    .onChange(of: searchText) { _ in
                        Task {
                            await viewModel.searchHotels(query: searchText)
                        }
                    }
                
                // Filter Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(FilterOption.allCases, id: \.self) { option in
                            FilterPill(option: option,
                                     isSelected: selectedFilter == option) {
                                selectedFilter = option
                                Task {
                                    await viewModel.applyFilter(option)
                                }
                            }
                        }
                        
                        Button(action: { showingFilters.toggle() }) {
                            HStack {
                                Image(systemName: "slider.horizontal.3")
                                Text("More Filters")
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(20)
                        }
                    }
                    .padding()
                }
                
                // Hotel List
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else if viewModel.hotels.isEmpty {
                    ContentUnavailableView(
                        "No Hotels Found",
                        systemImage: "building.2",
                        description: Text("Try adjusting your filters or search terms")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.hotels) { hotel in
                                HotelCard(hotel: hotel)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Find Your Hotel")
            .sheet(isPresented: $showingFilters) {
                FilterView(priceRange: $priceRange) {
                    Task {
                        await viewModel.applyPriceFilter(range: priceRange)
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error occurred")
            }
        }
    }
}

// Filter View
struct FilterView: View {
    @Binding var priceRange: ClosedRange<Double>
    @Environment(\.dismiss) var dismiss
    let onApply: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Price Range")) {
                    VStack {
                        HStack {
                            Text("$\(Int(priceRange.lowerBound))")
                            Spacer()
                            Text("$\(Int(priceRange.upperBound))")
                        }
                        .font(.caption)
                        
                        RangeSlider(value: $priceRange, in: 0...1000)
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        onApply()
                        dismiss()
                    }
                }
            }
        }
    }
}

// Helper Views
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search hotels, destinations...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal)
    }
}

struct FilterPill: View {
    let option: FilterOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(option.rawValue)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}
