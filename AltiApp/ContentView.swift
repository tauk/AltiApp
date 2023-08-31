//
//  ContentView.swift
//  AltiApp
//
//  Created by Tauseef Kamal on 19/08/2023.
//


import SwiftUI
import CoreMotion

struct ContentView: View {
    @State private var pressure: Double = 0
    @State private var altitude: Double = 0

    private let altimeter = CMAltimeter()

    var body: some View {
        Text("Pressure: \(pressure) kpascals \nAltitude change: \(altitude) m")
            .onAppear(perform: startAltimeterUpdates)
            .onDisappear(perform: stopAltimeterUpdates)
    }

    func startAltimeterUpdates() {
        guard CMAltimeter.isRelativeAltitudeAvailable() else {
            print("Relative altitude is not available on this device.")
            return
        }
        
        altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { (data, error) in
            if let data = data {
                self.pressure = Double(truncating: data.pressure)
                self.altitude = Double(truncating: data.relativeAltitude)
            } else if let error = error {
                print("Error fetching altitude data: \(error.localizedDescription)")
            }
        }
    }

    func stopAltimeterUpdates() {
        altimeter.stopRelativeAltitudeUpdates()
    }
}


/*
struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Altimeter data")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
