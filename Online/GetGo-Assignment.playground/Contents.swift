import Foundation
import CoreLocation

let locationManager = CLLocationManager()

public class MaxSum {
    public static func findMaxSum(numbers: Array<Int>) -> Int {
        let sortedArray = numbers.sorted { $0 > $1 }.prefix(2)
        return Array(sortedArray).reduce(0, +)
    }
}

print(MaxSum.findMaxSum(numbers: [ 5, 9, 7, 11 ]))

print("-------------------------------------------------------------")

public enum CropError: Error {
    case cropNotPresent
}

public class CropRotation {
    
    typealias Crop = (String, String)
    
    private var crops: [Crop] = []

    public func addNext(currentCrop: String, nextCrop: String) {
        let crop = (currentCrop, nextCrop)
        crops.append(crop)
    }
    
    public func getNext(currentCrop: String) throws -> String {
        if let crop = crops.last(where: { $0.0 == currentCrop } ) {
            return crop.1
        } else {
            throw CropError.cropNotPresent
        }
    }
}

do {
    var cropRotation = CropRotation()
    cropRotation.addNext(currentCrop: "Wheat", nextCrop: "Barley")
    cropRotation.addNext(currentCrop: "Barley", nextCrop: "Fallow")
    
    print(try cropRotation.getNext(currentCrop: "Wheat"))
    print(try cropRotation.getNext(currentCrop: "Barley"))
    print(try cropRotation.getNext(currentCrop: "Fallow"))
} catch CropError.cropNotPresent {
    print("Crop not present")
}

print("-------------------------------------------------------------")

public enum AlreadyHatchedError: Error {
    case alreadyHatched
}

public protocol Reptile {
    func lay() -> ReptileEgg
}

public class FireDragon: Reptile {
    public func lay() -> ReptileEgg {
        let egg = ReptileEgg(createReptile: {
            return FireDragon()
        })
        return egg
    }
    
}

public class ReptileEgg {
    private var isHatched = false
    private var reptile: Reptile!
    
    public init(createReptile: @escaping () -> Reptile) {
        self.reptile = createReptile()
    }

    public func hatch() throws -> Reptile {
        if !isHatched {
            isHatched = true
            return reptile
        } else {
            throw AlreadyHatchedError.alreadyHatched
        }
    }
}

let fireDragon = FireDragon()
//print(fireDragon)

print("-------------------------------------------------------------")

public class LazyMatcher {
    public var target: String = ""
    public var functions: Array<() -> Bool?> = []
    
    public func addPartialMatch(partialMatch: String) -> Void {
        let closure = { [unowned self] in // Literally just weak reference the self instance LMAO
            return self.target.contains(partialMatch)
        };
        
        self.functions.append(closure)
    }
    
    public func anyMatch() -> Bool {
        for fn in functions {
            let result = fn()
            if let unwrapped = result {
                if unwrapped {
                    return true
                }
            }
        }
        return false
    }
}

var matcher = LazyMatcher()
matcher.target = "some string"

matcher.addPartialMatch(partialMatch: "some")
matcher.addPartialMatch(partialMatch: "1")

print(matcher.anyMatch())
