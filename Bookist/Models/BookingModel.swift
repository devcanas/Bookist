import Foundation
import UIKit

enum Section {
    case main
}

typealias BookingsDataSource = UITableViewDiffableDataSource<Section, BookingModel>
typealias BookingsSnapshot = NSDiffableDataSourceSnapshot<Section, BookingModel>

typealias RoomDataSource = UICollectionViewDiffableDataSource<Section, Room>
typealias RoomSnapshot = NSDiffableDataSourceSnapshot<Section, Room>

typealias ConfirmedFiltersSnapshot = NSDiffableDataSourceSnapshot<Section, Filter>
typealias ConfirmedFiltersDataSource = UITableViewDiffableDataSource<Section, Filter>

typealias FilterDataSource = UICollectionViewDiffableDataSource<Section, Filter>
typealias FilterSnapshot = NSDiffableDataSourceSnapshot<Section, Filter>

enum BookingType: String {
    case individual = "individual"
    case group = "group"
}

struct BookingDisplayableDateInfo {
    let day: String?
    let startTime: String?
    let endTime: String?
}

class ShuttleBooking {
    var toTime: Date?
    var fromTime: Date?
    var from: Campus?
    var to: Campus?
    var isRoundtrip: Bool = false
    
    init(shuttleBooking: ShuttleBooking? = nil, toTime: Date? = nil, fromTime: Date? = nil, from: Campus? = nil, to: Campus? = nil) {
        self.toTime = toTime
        self.fromTime = fromTime
        self.from = from
        self.to = to
    }
    
    var asDisplayableTime: String {
        guard let toTime = toTime else { return "" }
        let sep = fromTime != nil ? "/" : ""
        return "\(toTime.hourLabelText) \(sep) \(fromTime?.hourLabelText ?? "")"
    }
}

class BookingModel: Hashable {
    var id: String {
        "\(room?.name ?? "mkay")\(campus)"
    }
    var startDate: Date?
    var endDate: Date?
    var room: Room?
    var bookingType: BookingType
    var campus: Campus?
    var shuttleBooking: ShuttleBooking?
    var appliedFilters: [Filter] = []
    var filters: [Filter] = [.silent, .accessible, .socket, .computerLab, .airConditioned, .projector]
    
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: BookingModel, rhs: BookingModel) -> Bool {
        return lhs.id == rhs.id
    }
}

enum Campus: String {
    case alameda = "Alameda"
    case taguspark = "Taguspark"
}

struct Room: Hashable {
    var id: String {
        "\(name)\(campus)"
    }
    let name: String
    let campus: Campus
    let filters: [Filter]
    let bookingType: BookingType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Room, rhs: Room) -> Bool {
        lhs.id == rhs.id
    }
}

enum Filter: String, Hashable {
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
