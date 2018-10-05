import UIKit
import CoreML
import PlaygroundSupport

public func save(image: UIImage, name: String) throws {
    #if swift(>=4.2)
    let data = image.jpegData(compressionQuality: 1.0)!
    #else
    let data = UIImageJPEGRepresentation(image, 1.0)!
    #endif
    try data.write(to: playgroundSharedDataDirectory.appendingPathComponent(name))
}

public func save(multiArray: MLMultiArray, name: String) throws {
    let ptr = UnsafeMutablePointer<Double>(OpaquePointer(multiArray.dataPointer))
    let bufferPtr = UnsafeMutableBufferPointer(start: ptr, count: multiArray.count)
    let data = Data(buffer: bufferPtr)

    try data.write(to: playgroundSharedDataDirectory.appendingPathComponent(name))
}
