//
//  VolumeSliderView.swift
//  volume_control
//
//  Created by Rok on 24/10/2021.
//

import Foundation
import SwiftUI

struct VolumeSlider: View {
    // Slider frame configuration
    private let height:CGFloat = 200.0
    private let width:CGFloat = 100.0
    
    // Slider color configuration
    private let activeColor:Color = Color.blue
    private let inactiveColor:Color = Color.gray
    
    // Needed values
    @Binding var numberOfLines:Int
    @Binding var volumePercent:Int
    
    // Drag gesture configuration
    private var drag: some Gesture {
        DragGesture()
            .onChanged { x in
                self.handleDraggingEvent(x)
            }
    }
    
    // Handle event from the drag gesture
    func handleDraggingEvent(_ x:DragGesture.Value) {
        var dragValue = x.location.y
        
        // Handle out of bounds drag
        if dragValue < 0 {
           dragValue = 0
        } else if dragValue > self.height {
            dragValue = self.height
        }
        
        // Calculate new volumePercent based on the drag event
        self.volumePercent = Int((self.height - dragValue) / self.height * 100)
    }
    
    // Tells the rectangles whether they should take the activeColor or inactiveColor
    func shouldBeColored(_ elementIndex: Int) -> Bool {
        return (100.0 / CGFloat(self.numberOfLines) * CGFloat(self.numberOfLines - elementIndex)) < CGFloat(self.volumePercent)
    }
    
    var body: some View {
        VStack {
            ForEach(1..<self.numberOfLines, id: \.self) { i in
                Rectangle()
                    .fill(self.shouldBeColored(i) ? self.activeColor : self.inactiveColor)
                Spacer().frame(minHeight: 0.0, maxHeight: .infinity)
            }
            Rectangle()
                .fill(self.shouldBeColored(self.numberOfLines) ? self.activeColor : self.inactiveColor)
        }
        .frame(width: self.width, height: self.height, alignment: .center)
        .gesture(drag)
    }
}
