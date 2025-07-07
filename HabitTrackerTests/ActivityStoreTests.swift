import Testing
import Foundation
@testable import HabitTracker

class ActivityStoreTests {
    let activity = Activity.example

    var store = ActivityStore()

    deinit {
        store.items.removeAll()
    }

    func expectSuccess(_ result: Result<Void, ActivityError>, assert: () -> Void = {}) {
        if case .failure(let error) = result {
            #expect(Bool(false), "Expected success, but got failure: \(error)")
        } else {
            assert()
        }
    }

    func expectFailure(_ result: Result<Void, ActivityError>, assert: (ActivityError) -> Void) {
        if case .failure(let error) = result {
            assert(error)
        } else {
            #expect(Bool(false), "Expected failure, but got success")
        }
    }

    @Test func testSuccessfulValidation()  {
        expectSuccess(store.validate(activity))
    }

    @Test func testEmptyTitleValidation()  {
        let activity = Activity(
            title: "",
            description: activity.description,
        )

        let result = store.validate(activity)

        expectFailure(result) { error in
            #expect(error == .missingTitle)
        }
    }

    @Test func testFindOneOnEmpty() {
        #expect(store.items.isEmpty)
        #expect(store.findOne(with: activity.id) == nil)
    }

    @Test func testAppendAndFindOne() {
        expectSuccess(store.append(activity)) {
            #expect(store.findOne(with: activity.id) == activity)
        }
    }

    @Test func testFindOneMissing() {
        #expect(store.items.isEmpty)
        expectSuccess(store.append(activity)) {
            #expect(store.findOne(with: UUID()) == nil)
        }
    }

    @Test func testDuplicateTitleValidation() {
        expectSuccess(store.append(activity))
        let anotherActivity = Activity(
            title: activity.title,
            description: "\(activity.description) dolor sit"
        )

        let result = store.validate(anotherActivity)

        expectFailure(result) { error in
            #expect(error == .duplicateTitle)
        }
    }

    @Test func testNegativeCompletionsValidation() {
        let activity = Activity(
            title: activity.title,
            description: activity.description,
            completions: -1
        )

        let result = store.validate(activity)

        expectFailure(result) { error in
            #expect(error == .negativeCompletions)
        }
    }

    @Test func testAppendingInvalidActivity() {
        let activity = Activity(
            title: "",
            description: ""
        )

        let result = store.append(activity)

        expectFailure(result) { error in
            #expect(error == .missingTitle)
        }
    }

    @Test func testIncrement() {
        let _ = store.append(activity)

        store.increment(activity.id)

        #expect(store.findOne(with: activity.id)!.completions == activity.completions + 1)
    }

    @Test func testIncrementOnMissing() {
        let _ = store.append(activity)

        store.increment(UUID())

        #expect(store.findOne(with: activity.id)!.completions == activity.completions)
    }

    @Test func testDecrement() {
        let _ = store.append(activity)

        store.decrement(activity.id)

        #expect(store.findOne(with: activity.id)!.completions == activity.completions - 1)
    }

    @Test func testDecrementOnMissing() {
        let _ = store.append(activity)

        store.decrement(UUID())

        #expect(store.findOne(with: activity.id)!.completions == activity.completions)
    }
}
