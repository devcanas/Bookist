import Foundation

enum BookingType: String {
    case individual = "individual"
    case group = "group"
}

struct BookingDisplayableDateInfo {
    let day: String?
    let startTime: String?
    let endTime: String?
}

struct ShuttleBooking {
    let toTime: Date?
    let fromTime: Date?
    var from: Campus?
    let to: Campus?
    var isRoundtrip: Bool = false
    
    mutating func setAsRoundtrip() {
        isRoundtrip = true
        from = to == .alameda ? .taguspark : .alameda
    }
    
    init(toTime: Date? = nil, fromTime: Date? = nil, from: Campus? = nil, to: Campus? = nil) {
        self.toTime = toTime
        self.fromTime = fromTime
        self.from = from
        self.to = to
    }
}

class BookingModel {
    var startDate: Date?
    var endDate: Date?
    var room: Room?
    var bookingType: BookingType
    var campus: Campus?
    var shuttleBooking: ShuttleBooking?
    
    var dateInfo: BookingDisplayableDateInfo? {
        BookingDisplayableDateInfo(
            day: startDate?.dayLabelText,
            startTime: startDate?.hourLabelText,
            endTime: endDate?.hourLabelText
        )
    }
    
    init(startDate: Date? = nil,
         endDate: Date? = nil,
         room: Room? = nil,
         bookingType: BookingType = .individual,
         campus: Campus? = nil,
         shuttleBooking: ShuttleBooking? = nil
    ) {
        self.startDate = startDate
        self.endDate = endDate
        self.room = room
        self.bookingType = bookingType
        self.campus = campus
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
