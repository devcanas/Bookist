import UIKit

struct Constants {
    struct Text {
        static let individual = "Individual"
        static let group = "Group"
        static let newBooking = "New Booking"
        static let upNext = "Up Next"
        static let confirm = "Confirm"
        static let continueText = "Continue"
        
        static let individualBooking = "Individual Booking"
        static let groupBooking = "Group Booking"
        
        static let alameda = "Alameda"
        static let taguspark = "Taguspark"
        static let campus = "Campus"
        static let shuttle = "Shuttle"
        
        static let dateAndTime = "Date & Time"
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
    }
    
    struct Booking {
        struct Individual {
            static let steps: BookingSteps = [.location, .dateTime, .roomChoice, .confirm]
        }
        
        struct Group {
            static let steps: BookingSteps = [.location, .dateTime, .roomChoice, .confirm, .groupShareStep]
        }
    }
}
