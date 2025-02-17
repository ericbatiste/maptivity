import Foundation

extension Array where Element == LocationData {
    func averageSpeed() -> Double {
        let speedArr: [Double] = map(\.speed)
        let sum = speedArr.reduce(0, +)
        let elements = Double(count)
        
        return sum / elements
    }
    
    func maxSpeed() -> Double {
        let speedArr: [Double] = map(\.speed)
        return speedArr.max() ?? 0
    }
    
    func totalClimb() -> Double {
        let climbArr: [Double] = map(\.altitude)
        var total: Double = 0
        var prevValue: Double = climbArr[0]
        
        for value in climbArr[1...] {
            if value > prevValue {
                total += Double(value - prevValue)
            }
        }
        
        return total
    }
    
    func totalDescent() -> Double {
        let descentArr: [Double] = map(\.altitude)
        var total: Double = 0
        var prevValue: Double = descentArr[0]
        
        for value in descentArr[1...] {
            if value < prevValue {
                total += Double(prevValue - value)
            }
        }
        
        return total
    }
}
