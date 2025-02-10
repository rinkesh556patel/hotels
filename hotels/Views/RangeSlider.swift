//
//  RangeSlider.swift
//  hotels
//
//  Created by rinkesh patel on 09/02/25.
//


import SwiftUI

struct RangeSlider: View {
    @Binding var value: ClosedRange<Double>
    let bounds: ClosedRange<Double>
    
    init(value: Binding<ClosedRange<Double>>, in bounds: ClosedRange<Double>) {
        self._value = value
        self.bounds = bounds
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                sliderView(geometry)
            }
            .frame(maxHeight: 30)
        }
        .frame(height: 30)
    }
    
    private func sliderView(_ geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let sliderWidth = width - 24 // Accounting for circle width
        
        return ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: width, height: 4)
            
            Rectangle()
                .fill(Color.blue)
                .frame(width: position(for: value.upperBound, in: bounds, width: sliderWidth) - 
                      position(for: value.lowerBound, in: bounds, width: sliderWidth),
                      height: 4)
                .offset(x: position(for: value.lowerBound, in: bounds, width: sliderWidth))
            
            // Lower bound handle
            Circle()
                .fill(Color.white)
                .shadow(radius: 2)
                .frame(width: 24, height: 24)
                .offset(x: position(for: value.lowerBound, in: bounds, width: sliderWidth))
            
            // Upper bound handle
            Circle()
                .fill(Color.white)
                .shadow(radius: 2)
                .frame(width: 24, height: 24)
                .offset(x: position(for: value.upperBound, in: bounds, width: sliderWidth))
        }
    }
    
    private func position(for value: Double, in bounds: ClosedRange<Double>, width: CGFloat) -> CGFloat {
        let percent = (value - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        return CGFloat(percent) * width
    }
    
    private func dragGesture(for bound: WritableKeyPath<ClosedRange<Double>, Double>, 
                           width: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { gesture in
                let percent = min(max(0, gesture.location.x / width), 1)
                let newValue = bounds.lowerBound + (bounds.upperBound - bounds.lowerBound) * Double(percent)
                
                if bound == \ClosedRange<Double>.lowerBound {
                    if newValue < value.upperBound {
                        value = newValue...value.upperBound
                    }
                } else {
                    if newValue > value.lowerBound {
                        value = value.lowerBound...newValue
                    }
                }
            }
    }
}
