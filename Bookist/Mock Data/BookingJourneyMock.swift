import Foundation

protocol BookingJourneyDataSource {
    func fetchBookingJourney(for bookingType: BookingType) -> BookingJourney
}

extension MockDataSource: BookingJourneyDataSource {
    func fetchBookingJourney(for bookingType: BookingType) -> BookingJourney {
        let steps = bookingType == .individual
            ? Constants.Booking.Individual.steps
            : Constants.Booking.Group.steps
        let metadata = BookingJourneyMetadata(steps: steps, bookingType: bookingType)
        return BookingJourney(metadata: metadata)
    }
}
