//
//  TestController.swift
//  Test
//
//  Created by Samuel Cornejo on 8/18/19.
//

import Foundation

class TestController {
    // MARK: Variables Declaration
    private let masterQueue: DispatchQueue
    private let threadsManager: ThreadsManager
    
    private var masterController: MainController?
    private var masterModule: MainModule?
    
    // MARK: Initializer
    init(mainQueue: DispatchQueue = DispatchQueue(label: "com.test.masterqueue"),
         threadsManager: ThreadsManager = ThreadsManager(executionQueue: [.initialization, .routineOne, .routineTwo])) {
        self.masterQueue = mainQueue
        self.threadsManager = threadsManager
    }
    
    // MARK: Public Methods
    func startProgram() {
        setupMasterModule()
        setupControllers()
        
        threadsManager.start { [weak self] (sequence) in
            switch sequence {
            case .initialization:
                self?.executeInitialization()
            case .routineOne:
                self?.executeRoutineOne()
            case .routineTwo:
                self?.executeRoutineTwo()
            }
        }
    }
    
    // MARK: Private Methods
    private func setupMasterModule() {
        // Extra stuff to obtain identifier
        masterModule = MainModule(identifier: "123456789")
    }
    
    private func setupControllers() {
        guard let masterModule = masterModule else { return }
        
        masterController = MainController(masterModule: masterModule)
    }
    
    private func executeInitialization() {
        threadsManager.changeExecutionState(to: .executing)
        print("\(Date()) - Executing Initialization...")
        
        masterController?.executeInitialization() { [weak self] result in
            switch result {
            case .success(_):
                self?.threadsManager.changeExecutionState(to: .idle)
            case .failure(let error):
                print("Error executing initialization: \(error)")
            }
        }
    }
    
    private func executeRoutineOne() {
        threadsManager.changeExecutionState(to: .executing)
        
        masterController?.executeRoutineOne() { [weak self] result in
            print("\(Date()) - Routine One executed...\n")
            
            switch result {
            case .success(let routineOneSyncPeriod):
                self?.masterQueue.asyncAfter(deadline: .now() + routineOneSyncPeriod) {
                     self?.threadsManager.addSequence(.routineOne)
                 }
            case .failure(let error):
                print("Error executing routine one: \(error)")
            }
            
            self?.threadsManager.changeExecutionState(to: .idle)
        }
    }
    
    private func executeRoutineTwo() {
        threadsManager.changeExecutionState(to: .executing)
        
        masterController?.executeRoutineTwo() { [weak self] result in
            print("\(Date()) - Routine Two executed...\n")
            
            switch result {
            case .success(let routineTwoSyncPeriod):
                self?.masterQueue.asyncAfter(deadline: .now() + routineTwoSyncPeriod) {
                    self?.threadsManager.addSequence(.routineTwo)
                }
            case .failure(let error):
                print("Error executing routine two: \(error)")
            }
            
            self?.threadsManager.changeExecutionState(to: .idle)
        }
    }
}
