import Foundation

class BookingJourneyMetadata {
    var title: String {
        return bookingType == .individual
            ? Constants.Text.individualBooking
            : Constants.Text.groupBooking
    }
    
    var currentStep: BookingStep = .location
    let steps: BookingSteps
    let bookingType: BookingType
    
    init(steps: BookingSteps, bookingType: BookingType) {
        self.steps = steps
        self.bookingType = bookingType
    }
}

class BookingJourney {
    var metadata: BookingJourneyMetadata
    private(set) var bookingModel: BookingModel
    
    init(metadata: BookingJourneyMetadata) {
        self.metadata = metadata
        self.bookingModel = BookingModel(bookingType: metadata.bookingType)
    }
    
    func with(bookingModel: BookingModel) {
        self.bookingModel = bookingModel
    }
}
