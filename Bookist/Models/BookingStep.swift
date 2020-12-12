typealias BookingSteps = [BookingStep]

enum BookingStep: Int {
    case location
    case dateTime
    case roomChoice
    case confirm
    case groupShareStep
}
