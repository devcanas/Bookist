import UIKit

struct Constants {
    struct Text {
        static let individual = "Individual"
        static let group = "Group"
        static let newBooking = "New Booking"
        static let upNext = "Up Next"
        static let confirm = "Confirm"
        static let continueText = "Continue"
        static let close = "Close"
        
        static let individualBooking = "Individual Booking"
        static let groupBooking = "Group Booking"
        
        static let alameda = "Alameda"
        static let taguspark = "Taguspark"
        static let campus = "Campus"
        static let shuttle = "Shuttle"
        
        static let dateAndTime = "Date & Time"
        static let availableRooms = "Available Rooms"
        static let filters = "Filters"
        
        static let confirmBooking = "Booking Confirmed"
    }
    
    struct Color {
        static let theme = UIColor(red: 0 / 255, green: 157 / 255, blue: 224 / 255, alpha: 1)
        static let secondaryColor = UIColor(red: 70 / 255, green: 85 / 255, blue: 95 / 255, alpha: 1)
    }
    
    struct Image {
        static let individual = UIImage(systemName: "person.fill")!
        static let group = UIImage(systemName: "person.2.fill")!
        static let arrowLeft = UIImage(systemName: "arrow.left.circle")!
        static let campus = UIImage(systemName: "building.columns.fill")!
        static let shuttle = UIImage(systemName: "bus.fill")!
        static let clock = UIImage(systemName: "clock")!
        static let rooms = UIImage(systemName: "scroll")!
        static let filters = UIImage(systemName: "line.horizontal.3.decrease.circle")!
        static let confirm = UIImage(systemName: "checkmark.rectangle.portrait")!
        static let calendar = UIImage(systemName: "calendar")!
        static let confirmFilter = UIImage(systemName: "checkmark.circle.fill")!
        static let excl = UIImage(systemName: "exclamationmark.triangle.fill")!
        static let link = UIImage(systemName: "link")!
    }
    
    struct Booking {
        struct Individual {
            static let steps: BookingSteps = [.location, .dateTime, .roomChoice, .confirm, .groupShareStep]
        }
        
        struct Group {
            static let steps: BookingSteps = [.location, .dateTime, .roomChoice, .confirm, .groupShareStep]
        }
    }
}
