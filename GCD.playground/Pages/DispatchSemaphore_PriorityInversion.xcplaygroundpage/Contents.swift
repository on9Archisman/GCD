import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let highPriorityQueue = DispatchQueue.global(qos: .userInitiated)
let lowPriorityQueue = DispatchQueue.global(qos: .utility)
let defaultPriorityQueue = DispatchQueue.global(qos: .default)

let dispatcherSemaphore = DispatchSemaphore(value: 1)

func printEmoji(queue: DispatchQueue, emoji: String) {
    queue.async {
        print("\(emoji) waiting...")
        dispatcherSemaphore.wait()
        
        for i in 0...10 {
            print("\(emoji) \(i)")
        }
        
        print("\(emoji) signal!")
        dispatcherSemaphore.signal()
    }
}

printEmoji(queue: defaultPriorityQueue, emoji: "🏎️")
printEmoji(queue: highPriorityQueue, emoji: "🚑")
printEmoji(queue: lowPriorityQueue, emoji: "🚕")


/* Here you can see 3 queue's based on priority want to access the resouce but it is not like that, the high priority will always execute at first so this condition also arises in Semaphore despite of using it and this is called PRIORITY INVERSION which is a DRAWBACK of a Semaphore. */
