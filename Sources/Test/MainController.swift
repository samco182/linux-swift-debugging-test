//
//  MainController.swift
//  Test
//
//  Created by Samuel Cornejo on 12/11/19.
//

import Foundation

class MainController {
    private let masterModule: MainModule
    private let networkService: NetworkService
    private let request: URLRequest = {
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)
        request.httpMethod = "GET"
        return request
    }()
    
    init(masterModule: MainModule, networkService: NetworkService = NetworkService()) {
        self.masterModule = masterModule
        self.networkService = networkService
    }
    
    func executeInitialization(onCompletion: @escaping (Result<Void, Error>) -> Void) {
        networkService.execute(request: request) { [weak self] _ in
            self?.updateSensorReadings()
            onCompletion(.success(()))
        }
    }
    
    func executeRoutineOne(onCompletion: @escaping (Result<TimeInterval, Error>) -> Void) {
        print("Fetching data...")

        networkService.execute(request: request) { [weak self] _ in
            self?.updateOtherData()
            onCompletion(.success((5)))
        }
    }
    
    func executeRoutineTwo(onCompletion: @escaping (Result<TimeInterval, Error>) -> Void) {
        updateSensorReadings()

        networkService.execute(request: request) { _ in
            onCompletion(.success((2)))
        }
    }
    
    // MARK: Private Methods
    private func updateSensorReadings() {
        let newReading = Reading(value: 25.0)
        masterModule.updateSensorReadings(newReading: newReading)
        print(String(format: "Reading: %.2f", newReading.value))
    }
    
    private func updateOtherData() {
        let newOtherData = OtherData(data: "NewData")
        masterModule.updateOtherData(newOtherData: newOtherData)
        print("Other data updated...")
    }
}
