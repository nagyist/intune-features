//  Copyright © 2015 Venture Media. All rights reserved.

import Cocoa
import FeatureExtraction
import Upsurge
import Peak

class FeaturesViewController: NSTabViewController {
    let configuration = Configuration()

    var example: Example! {
        didSet {
            updateFeatures()
        }
    }

    var notes = [MIDINoteEvent]() {
        didSet {
            updateFeatures()
        }
    }

    var spectrum: SpectrumViewController!
    var peakHeights: PeakHeightsViewController!
    var peakHeightsFlux: PeakHeightsFluxViewController!
    var spectrumFlux: SpectrumFluxViewController!

    var featureBuilder: FeatureBuilder!

    override func viewDidLoad() {
        super.viewDidLoad()

        featureBuilder = FeatureBuilder(configuration: configuration)

        view.translatesAutoresizingMaskIntoConstraints = false
        tabView.translatesAutoresizingMaskIntoConstraints = false
        
        spectrum = storyboard!.instantiateControllerWithIdentifier("SpectrumViewController") as! SpectrumViewController
        spectrum.configuration = configuration
        peakHeights = storyboard!.instantiateControllerWithIdentifier("PeakHeightsViewController") as! PeakHeightsViewController
        peakHeights.configuration = configuration
        peakHeightsFlux = storyboard!.instantiateControllerWithIdentifier("PeakHeightsFluxViewController") as! PeakHeightsFluxViewController
        peakHeightsFlux.configuration = configuration
        spectrumFlux = storyboard!.instantiateControllerWithIdentifier("SpectrumFluxViewController") as! SpectrumFluxViewController
        spectrumFlux.configuration = configuration
        tabViewItems = [
            NSTabViewItem(viewController: spectrum),
            NSTabViewItem(viewController: peakHeights),
            NSTabViewItem(viewController: peakHeightsFlux),
            NSTabViewItem(viewController: spectrumFlux)
        ]
        selectedTabViewItemIndex = 0
    }

    /// Convert from spectrum values to frequency, value points
    func spectrumPoints(spectrum: ValueArray<Double>) -> [FeatureExtraction.Point] {
        return (0..<spectrum.count).map{ FeatureExtraction.Point(x: configuration.baseFrequency * Double($0), y: spectrum[$0]) }
    }

    func updateFeatures() {
        let feature = featureBuilder.generateFeatures(example.data[0..<configuration.windowSize], example.data[configuration.stepSize..<configuration.windowSize + configuration.stepSize])

        let markNotes = notes.map{ Int($0.note) }

        spectrum.updateView(feature, markNotes: markNotes)
        peakHeights.updateView(feature, markNotes: markNotes)
        peakHeightsFlux.updateView(feature, markNotes: markNotes)
        spectrumFlux.updateView(feature, markNotes: markNotes)
    }
    
}
