import Foundation

extension Sequence {
    func inoutMap(_ transform: (inout Element) throws -> Void) rethrows -> [Element] {
        try map {
            var copy = $0
            try transform(&copy)
            return copy
        }
    }

    func inoutEnumeratedMap(_ transform: (Int, inout Element) throws -> Void) rethrows -> [Element] {
        try enumerated()
            .map { index, element in
                var copy = element
                try transform(index, &copy)
                return copy
            }
    }
}
