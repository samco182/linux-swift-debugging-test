//
//  ThreadsManager.swift
//  Test
//
//  Created by Samuel Cornejo on 9/24/19.
//

import Foundation

enum TestSequence {
    case initialization
    case routineOne
    case routineTwo
}

enum ThreadExecutionState {
    case idle
    case executing
}

class ThreadsManager {
    // MARK: Variables Declaration
    private var onExecutionQueueProcessing: ((TestSequence) -> Void)?
    private var executionQueue: [TestSequence]
    private var executionState: ThreadExecutionState {
        didSet {
            if executionState == .idle {
                processExecutionQueue()
            }
        }
    }
    
    // MARK: Initializer
    init(executionQueue: [TestSequence] = [], executionState: ThreadExecutionState = .idle) {
        self.executionQueue = executionQueue
        self.executionState = executionState
    }
    
    // MARK: Public Methods
    
    /// Starts ThreadsManager process.
    ///
    /// - Parameter onExecutionQueueProcessing: The closure to be executed whenever queue has finished processing a thread.
    func start(_ onExecutionQueueProcessing: @escaping (TestSequence) -> Void) {
        self.onExecutionQueueProcessing = onExecutionQueueProcessing
        processExecutionQueue()
    }
    
    /// Changes the process execution state.
    ///
    /// - Parameter newState: The new execution state
    func changeExecutionState(to newState: ThreadExecutionState) {
        executionState = newState
    }
    
    /// Adds a sequence to the execution queue.
    ///
    /// - Parameter sequence: The sequence to be added
    func addSequence(_ sequence: TestSequence) {
        executionQueue.append(sequence)
        processExecutionQueue()
    }
    
    // MARK: Private Methods
    private func processExecutionQueue() {
        if !executionQueue.isEmpty, executionState == .idle {
            let sequence = executionQueue.removeFirst()
            onExecutionQueueProcessing?(sequence)
        }
    }
}
