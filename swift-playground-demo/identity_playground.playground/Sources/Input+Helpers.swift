import GameplayKit

public struct PixelData {
    public var a: UInt8
    public var r: UInt8
    public var g: UInt8
    public var b: UInt8
}

public func imageFromARGB32Bitmap(_ pixels: [PixelData], width: Int, height: Int) -> UIImage? {
    guard width > 0 && height > 0 else { return nil }
    guard pixels.count == width * height else { return nil }

    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
    let bitsPerComponent = 8
    let bitsPerPixel = 32

    var data = pixels // Copy to mutable []
    guard let providerRef = CGDataProvider(data: NSData(bytes: &data,
                                                        length: data.count * MemoryLayout<PixelData>.size)
        )
        else { return nil }

    guard let cgim = CGImage(
        width: width,
        height: height,
        bitsPerComponent: bitsPerComponent,
        bitsPerPixel: bitsPerPixel,
        bytesPerRow: width * MemoryLayout<PixelData>.size,
        space: rgbColorSpace,
        bitmapInfo: bitmapInfo,
        provider: providerRef,
        decode: nil,
        shouldInterpolate: true,
        intent: .defaultIntent
        )
        else { return nil }

    return UIImage(cgImage: cgim)
}

public func gaussianNoiseBackground(width: Int, height: Int) -> UIImage? {
    let random = GKRandomSource()
    let dice = GKGaussianDistribution(randomSource: random, lowestValue: 0, highestValue: 255)
    let count = width * height
    var pixels = [PixelData]()
    for _ in 0..<count {
        pixels.append(PixelData(a: UInt8(dice.nextInt()),
                                r: UInt8(dice.nextInt()),
                                g: UInt8(dice.nextInt()),
                                b: UInt8(dice.nextInt())))
    }
    return imageFromARGB32Bitmap(pixels, width: width, height: height)
}

