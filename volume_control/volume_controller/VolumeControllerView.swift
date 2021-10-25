//
//  ContentView.swift
//  volume_control
//
//  Created by Rok on 23/10/2021.
//

import SwiftUI
import MediaPlayer

// Used for communication between an external view and VolumeControllerView.
// Pass an instance of VolumeDelegate to VolumeControllerView and
// listen for changes if you want to handle those changes in an external view
class VolumeDelegate: ObservableObject {
    @Published var volumePercent:Int
    
    init(initialVolumePercent:Int) {
        self.volumePercent = initialVolumePercent
    }
}

struct VolumeControllerView: View {
    // Strings for textfields
    @State var volumePercentString:String = ""
    @State var numberOfLinesString:String = ""
    
    // Values we're setting and listening to
    @ObservedObject var volumeDelegate:VolumeDelegate
    @State var numberOfLines:Int = 10
    
    // If a volumeDelegate instance is passed to this view, use it
    init (volumeDelegate:VolumeDelegate) {
        self.volumeDelegate = volumeDelegate
    }
    
    // If a volume delegate isn't passed to this view, create one with an arbitrary initial value
    init () {
        self.volumeDelegate = VolumeDelegate(initialVolumePercent: 50)
    }
    
    // Callback for "SET VOLUME" button
    func setVolumeAction() -> Void {
        self.dismissKeyboard()
        let tmpVolume:Int? = Int(volumePercentString)
        
        // Ignore invalid input
        if tmpVolume == nil || tmpVolume! > 100 || tmpVolume! < 0 {
            self.volumePercentString = String(volumeDelegate.volumePercent)
            return
        }
        
        volumeDelegate.volumePercent = tmpVolume!
    }
    
    // Callback for "SET LINES" button
    func setNumberOfLinesAction() -> Void {
        self.dismissKeyboard()
        let tmpNumberOfLines:Int? = Int(numberOfLinesString)
        
        // Ignore unvalid input
        if tmpNumberOfLines == nil || tmpNumberOfLines! < 1 {
            self.numberOfLinesString = String(self.numberOfLines)
            return
        }
        
        self.numberOfLines = tmpNumberOfLines!
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    TextField(
                        "Volume (%)",
                        text: $volumePercentString,
                        onCommit: self.setVolumeAction
                    )
                        .keyboardType(.numberPad)
                    Button("SET VOLUME", action: self.setVolumeAction)
                }
                HStack {
                    TextField(
                        "Lines",
                        text: $numberOfLinesString,
                        onCommit: self.setNumberOfLinesAction
                    )
                        .keyboardType(.numberPad)
                    Button("SET LINES", action: self.setNumberOfLinesAction)
                }
            }
            .padding(20)
            Spacer()
            VolumeSlider(numberOfLines: $numberOfLines, volumePercent: $volumeDelegate.volumePercent)
            Text("Volume set at: \(volumeDelegate.volumePercent)%")
            Spacer()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VolumeControllerView()
        }
    }
}
