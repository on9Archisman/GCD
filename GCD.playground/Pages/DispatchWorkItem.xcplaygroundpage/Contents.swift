import Foundation

struct WorkItem {
    let name: String
    var dispatchWorkItem: DispatchWorkItem? = nil

    mutating func highOccurringCharacter(completion: @escaping (String, Int) -> Void) {
        // Cancel previous work item
        dispatchWorkItem?.cancel()

        // Create new work item
        let workItem = DispatchWorkItem { [name] in
            let result = WorkItem.calculateHighestOccurrence(from: name)
            completion(result.0, result.1)
        }

        // Assign to variable so we can cancel if needed later
        dispatchWorkItem = workItem

        // Dispatch the work
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: workItem)
    }

    // Static method to calculate result
    private static func calculateHighestOccurrence(from input: String) -> (String, Int) {
        var dict: [Character: Int] = [:]

        for char in input.filter({ !$0.isWhitespace }) {
            dict[char, default: 0] += 1
        }

        if let (char, count) = dict.max(by: { $0.value < $1.value }) {
            return (String(char), count)
        }

        return ("", 0)
    }
}

var objWorkItem = WorkItem(name: "Hello World!")

DispatchQueue.global(qos: .userInitiated).async {
    objWorkItem.highOccurringCharacter { char, count in
        print("(userInitiated) Character with highest occurrence is:", char, "→", count)
    }
}

DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 0.9) {
    objWorkItem.highOccurringCharacter { char, count in
        print("(default) Character with highest occurrence is:", char, "→", count)
    }
}

DispatchQueue.global(qos: .userInteractive).async {
    objWorkItem.highOccurringCharacter { char, count in
        print("(userInteractive) Character with highest occurrence is:", char, "→", count)
    }
}
