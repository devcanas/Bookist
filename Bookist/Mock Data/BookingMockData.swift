import Foundation

extension MockDataSource {
    func fetchBookingData() -> [BookingModel] {
        return bookingMockData
    }
}

private let bookingMockData: [BookingModel] = [
    BookingModel(startDate: Date(timeIntervalSince1970: 1607460026), endDate: Date(timeIntervalSince1970: 1607460026), room: room1, bookingType: .group, shuttleBooking: ShuttleBooking(toTime: Date(timeIntervalSince1970: 1607460026), fromTime: Date(timeIntervalSince1970: 1607460026), from: .alameda, to: .taguspark)),
    BookingModel(startDate: Date(timeIntervalSince1970: 1607522400), endDate: Date(timeIntervalSince1970: 1607526000), room: room1, bookingType: .group),
    BookingModel(startDate: Date(timeIntervalSince1970: 1607522400), endDate: Date(timeIntervalSince1970: 1607526000), room: room3, bookingType: .individual),
    BookingModel(startDate: Date(timeIntervalSince1970: 1607790600), endDate: Date(timeIntervalSince1970: 1607796000), room: room3, bookingType: .individual),
]

private let room1 = Room(
    name: "Room 0.0.7",
    campus: .alameda,
    filters: [.silent, .accessible],
    bookingType: .individual
)

private let room2 = Room(
    name: "Room 0.21",
    campus: .taguspark,
    filters: [.silent, .accessible, .socket],
    bookingType: .individual
)

private let room3 = Room(
    name: "Room 1.2",
    campus: .alameda,
    filters: [.silent, .socket, .projector],
    bookingType: .individual
)

private let room4 = Room(
    name: "Library",
    campus: .taguspark,
    filters: [.silent, .socket, .projector],
    bookingType: .group
)

private let room5 = Room(
    name: "Library",
    campus: .taguspark,
    filters: [.silent, .socket, .projector, .accessible, .computerLab, .airConditioned],
    bookingType: .group
)

private let room6 = Room(
    name: "Library",
    campus: .taguspark,
    filters: [.silent, .socket, .projector, .accessible, .computerLab, .airConditioned],
    bookingType: .group
)
