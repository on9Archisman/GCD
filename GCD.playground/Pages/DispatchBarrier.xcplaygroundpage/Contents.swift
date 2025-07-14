import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class PhoneStocks {
    
    var stocks : Array<String> = ["iPhone 13", "iPhone 12", "iPhone 11", "iPhone XS", "iPhone XR"]
    
    let dispatchBarrier = DispatchQueue(label: "barrierQueue")
    
    func getAvailableStrocks() {
        dispatchBarrier.sync {
            print("Available Stocks: \(stocks)")
        }
    }
    
    func purchasePhone(phone: String) {
        dispatchBarrier.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            guard let index = self.stocks.firstIndex(of: phone) else {
                print("No such phone in the stock")
                return
            }
            
            self.stocks.remove(at: index)
            
            print("Congratulations, You have successfully purchased \(phone)")
        }
    }
}

let concurrentQueue = DispatchQueue(label: "customConcurrentQueue", attributes: .concurrent)
let objPhoneStocks = PhoneStocks()

concurrentQueue.async {
    objPhoneStocks.purchasePhone(phone: "iPhone 11")
}

concurrentQueue.async {
    objPhoneStocks.getAvailableStrocks()
}

