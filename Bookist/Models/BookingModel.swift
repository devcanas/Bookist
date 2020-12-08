import Foundation

enum BookingType: String {
    case individual = "individual"
    case group = "group"
}

struct BookingDisplayableDateInfo {
    let day: String
    let startTime: String
    let endTime: String
}

struct ShuttleBooking {
    let toTime: Date
    let fromTime: Date
    let from: Campus
    let to: Campus
}

struct BookingModel {
    let startDate: Date
    let endDate: Date
    let room: Room
    let bookingType: BookingType
    let shuttleBooking: ShuttleBooking?
    
    var dateInfo: BookingDisplayableDateInfo {
        BookingDisplayableDateInfo(
            day: startDate.dayLabelText,
            startTime: startDate.hourLabelText,
            endTime: endDate.hourLabelText
        )
    }
    
    init(startDate: Date, endDate: Date, room: Room, bookingType: BookingType, shuttleBooking: ShuttleBooking? = nil) {
        self.startDate = startDate
        self.endDate = endDate
        self.room = room
        self.bookingType = bookingType
        self.shuttleBooking = shuttleBooking
    }
}

enum Campus: String {
    case alameda = "Alameda"
    case taguspark = "Taguspark"
}

struct Room {
    let name: String
    let campus: Campus
    let filters: [Filter]
    let bookingType: BookingType
}

enum Filter: String {
    case silent = "Silent"
    case accessible = "Accessible"
    case socket = "Socket"
    case computerLab = "Computer Lab"
    case airConditioned = "Air Conditioned"
    case projector = "Projector"
}

enum AnonymousFilter: String {
    case group = "group"
    case individual = "individual"
}
