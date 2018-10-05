import UIKit
import CoreML
import Vision
import CoreVideo

//: # Check iOS version
UIDevice.current.systemVersion

//: # Model Adapter
class IdentityModelAdapter {
    let model: VNCoreMLModel

    init(name: String) throws {
        let loader = ModelLoader(name: name)
        self.model = try loader.preparedVisionModel()
    }

    func predict(image: UIImage, callback: @escaping (UIImage?) -> Void) throws {
        let pixelBuffer = image.pixelBuffer()
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }

            let results = request.results as! [VNCoreMLFeatureValueObservation]
            let multiArrayValue = results[0].featureValue.multiArrayValue!
            let multiArray = MultiArray<Double>(multiArrayValue)

            // Save output tensor into a file.
            //try! save(multiArray: multiArrayValue, name: "output.bin")

            guard let outputImage = multiArray.image(offset: 0, scale: 255) else {
                fatalError("Unable to convert the output to UIImage!")
            }

            callback(outputImage)
        }

        let ciImage = CIImage(cvImageBuffer: pixelBuffer)
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])

        try handler.perform([request])
    }
}

//: # Prediction

// Prepare the input image
let image = UIImage(named: "neptune.jpg")!
let crop = CGRect(x: 0, y: 0, width: 416, height: 740)
let cropped = image.cropping(to: crop)!

//: ## Available models:
//:
//: * identity_model_rect_original
//: * identity_model_rect
//: * identity_model

let adapter = try IdentityModelAdapter(name: "identity_model_rect")
try adapter.predict(image: cropped, callback: { (image) in
    guard let image = image else {
        return
    }
    image
})
