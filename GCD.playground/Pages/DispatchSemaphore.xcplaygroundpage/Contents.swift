import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

protocol Banking {
    func withdraw(amount: Double) throws
}

enum BankingError: Error {
    case inssuficientFunds
    case invalidWithdrawalAmount
}

var accountBalance: Double = 40000.00

struct ATM: Banking {
    func withdraw(amount: Double) throws {
        guard amount > 0 else {
            throw BankingError.invalidWithdrawalAmount
        }
        
        guard amount <= accountBalance else {
            throw BankingError.inssuficientFunds
        }
        
        // Intentional pause : ATM doing some calculation before it can dispense money
        Thread.sleep(forTimeInterval: Double.random(in: 1...3))
        accountBalance -= amount
    }
    
    func balance() {
        debugPrint("ATM withdrawal successful, New account balance = \(accountBalance)")
    }
}

struct UPI: Banking {
    func withdraw(amount: Double) throws {
        guard amount > 0 else {
            throw BankingError.invalidWithdrawalAmount
        }
        
        guard amount <= accountBalance else {
            throw BankingError.inssuficientFunds
        }
        
        // Intentional pause : UPI doing some calculation before it can dispense money
        Thread.sleep(forTimeInterval: Double.random(in: 1...3))
        accountBalance -= amount
    }
    
    func balance() {
        debugPrint("UPI withdrawal successful, New account balance = \(accountBalance)")
    }
}

let queue = DispatchQueue(label: "semaphore", qos: .utility, attributes: .concurrent)
let semaphore = DispatchSemaphore(value: 1)

// For ATM
queue.async {
    do {
        semaphore.wait()
        let objATM = ATM()
        try objATM.withdraw(amount: 30000.00)
        objATM.balance()
        semaphore.signal()
    } catch let error as BankingError {
        switch error {
        case .inssuficientFunds:
            print("ATM withdrawal failure: The account balance is less than the amount you want to withdraw, transaction cancelled")
        case .invalidWithdrawalAmount:
            print("ATM withdrawal failure: The entered amount is invalid, transaction cancelled")
        }
        semaphore.signal()
    } catch {
        print("Error")
        semaphore.signal()
    }
}

// For UPI
queue.async {
    do {
        semaphore.wait()
        let objUPI = UPI()
        try objUPI.withdraw(amount: 20000.00)
        objUPI.balance()
        semaphore.signal()
    } catch let error as BankingError {
        switch error {
        case .inssuficientFunds:
            print("UPI withdrawal failure: The account balance is less than the amount you want to withdraw, transaction cancelled")
        case .invalidWithdrawalAmount:
            print("UPI withdrawal failure: The entered amount is invalid, transaction cancelled")
        }
        semaphore.signal()
    }
    catch {
        print("Error")
        semaphore.signal()
    }
}
