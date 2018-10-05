import Foundation
import Vision
import CoreML

public struct ModelLoader {

    public let name: String

    public init(name: String) {
        self.name = name
    }

    public func loadedModel() throws -> MLModel {
        let filePath = Bundle.main.path(forResource: name, ofType: "mlmodelc")!
        let url = URL(fileURLWithPath: filePath)
        let model = try MLModel(contentsOf: url)
        return model
    }

    public func preparedVisionModel() throws -> VNCoreMLModel {
        let model = try loadedModel()
        let visionModel = try VNCoreMLModel(for: model)
        return visionModel
    }
}
