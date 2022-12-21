import Foundation

public extension Date {
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }

    var isTomorrow: Bool {
        let calendar = Calendar.current
        return calendar.isDateInTomorrow(self)
    }

    func getDateAndMonth(isFixed: Bool = false, timeZone: TimeZone = TimeZone.current, isShortFormat: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        let languageCode = Locale.current.languageCode ?? "en"

        dateFormatter.locale = Locale(identifier: languageCode)
        dateFormatter.timeZone = isFixed ? nil : timeZone

        if languageCode == "fr-CA" || languageCode == "fr" {
            dateFormatter.dateFormat = isShortFormat ? "d MMM" : "d MMMM"
        } else {
            dateFormatter.dateFormat = isShortFormat ? "MMM dd" : "MMMM dd"
        }
        return dateFormatter.string(from: self)
    }

    func getTime(isFixed: Bool = false) -> String {
        let englishDateFormatter = DateFormatter()
        englishDateFormatter.dateFormat = "hh:mm a"
        englishDateFormatter.amSymbol = "AM"
        englishDateFormatter.pmSymbol = "PM"

        let dateFormatter = Locale.current.isFrench ? Date.frenchDateFormatter : englishDateFormatter
        dateFormatter.timeZone = isFixed ? nil : TimeZone.current

        return dateFormatter.string(from: self)
    }

    func getMounthAndYear(isFixed: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        let languageCode = Locale.current.languageCode ?? "en"

        dateFormatter.locale = Locale(identifier: languageCode)
        dateFormatter.timeZone = isFixed ? nil : TimeZone.current

        if languageCode == "fr-CA" || languageCode == "fr" {
            dateFormatter.dateFormat = "d MMMM yyyy"
            return "Le " + dateFormatter.string(from: self)
        } else {
            dateFormatter.dateFormat = "MMMM d, yyyy"
            return dateFormatter.string(from: self)
        }
    }

    func getLocalizedTime(isFixed: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        let separator = "#*#"

        if Locale.current.isFrench {
            dateFormatter.locale = Locale(identifier: "fr_CA")
            dateFormatter.dateFormat = "H\(separator)mm"
        } else {
            dateFormatter.locale = Locale(identifier: "en_CA")
            dateFormatter.dateFormat = "h:mma"
        }
        dateFormatter.timeZone = isFixed ? TimeZone(secondsFromGMT: 0) : TimeZone.current
        return dateFormatter.string(from: self).replacingOccurrences(of: separator, with: "h")
    }

    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        let languageCode = Locale.current.languageCode ?? "en"

        dateFormatter.locale = Locale(identifier: languageCode)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }

    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self)
    }

    func getISODate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "America/New_York")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }

    func getTimeStamp() -> Double {
        NSDate().timeIntervalSince1970
    }

    func getElapsedInterval() -> String {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.calendar = calendar

        var dateString: String?
        let interval = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute], from: self, to: Date())
        if let year = interval.year, year > 0 {
            formatter.allowedUnits = [.year]
        } else if let month = interval.month, month > 0 {
            formatter.allowedUnits = [.month]
        } else if let week = interval.weekOfYear, week > 0 {
            formatter.allowedUnits = [.weekOfMonth]
        } else if let day = interval.day, day > 0 {
            formatter.allowedUnits = [.day]
        } else if let hour = interval.hour, hour > 0 {
            formatter.allowedUnits = [.hour]
        } else if let minute = interval.minute, minute > 0 {
            formatter.allowedUnits = [.minute]
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            dateString = dateFormatter.string(from: self)
        }
        if dateString == nil {
            dateString = formatter.string(from: self, to: Date())
            if Locale.current.isFrench {
                dateString = "Il y a " + dateString!
            } else {
                dateString = dateString! + " ago"
            }
        }
        return dateString!
    }

    var month: Int {
        Calendar.current.component(.month, from: self)
    }

    var monthYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }

    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        (min(date1, date2) ... max(date1, date2)) ~= self
    }

    func formattedString(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

public extension Date {
    static var currentDayString: String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        return dateFormatter.string(from: currentDate)
    }

    static var shortCurrentDayString: String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: date)
    }

    static func daysBetween(start: Date, end: Date) -> Int? {
        let calendar = Calendar.current

        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)

        let a = calendar.dateComponents([.day], from: date1, to: date2)
        return a.value(for: .day)
    }
}

public extension Date {
    enum TimeFormatConvention {
        case englishTimeFormat
        case frenchTimeFormat
    }

    static let calendar = Calendar.current

    static let frenchDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH 'h' mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()

    static let englishDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        return dateFormatter
    }()

    static func isStoreOpened(beginTime: String, endTime: String, locale: TimeFormatConvention, timezoneIdentifier: String? = nil) throws -> Bool {
        let wrongParseError = NSError(domain: "Can't parse provided time. Check locale and corresponding format", code: 0)

        let specifiedFormatter = locale ~= .frenchTimeFormat ? frenchDateFormatter : englishDateFormatter

        guard let endTimeDate = specifiedFormatter.date(from: endTime) else { throw wrongParseError }
        guard let beginTimeDate = specifiedFormatter.date(from: beginTime) else { throw wrongParseError }

        var currentDate = Date()
        if let timezoneIdentifier = timezoneIdentifier, let timezone = TimeZone(identifier: timezoneIdentifier) {
            currentDate = convertDateToRequiredTimezone(currentDate, from: TimeZone.current, to: timezone)
        }
        let timeComponents: Set<Calendar.Component> = [.hour, .minute]

        let currentTimeComponents = calendar.dateComponents(timeComponents, from: currentDate)
        let beginTimeComponents = calendar.dateComponents(timeComponents, from: beginTimeDate)
        let endTimeComponents = calendar.dateComponents(timeComponents, from: endTimeDate)

        guard let currentHour = currentTimeComponents.hour else { throw wrongParseError }
        guard let beginningHour = beginTimeComponents.hour else { throw wrongParseError }
        guard var closedStoreHour = endTimeComponents.hour else { throw wrongParseError }

        if beginningHour >= closedStoreHour {
            closedStoreHour += 24
        }

        return (beginningHour ..< closedStoreHour) ~= currentHour
    }

    static func convertDateToRequiredTimezone(_ date: Date, from: TimeZone, to: TimeZone) -> Date {
        let sourceOffset = from.secondsFromGMT(for: date)
        let destinationOffset = to.secondsFromGMT(for: date)
        let timeInterval = TimeInterval(destinationOffset - sourceOffset)
        return Date(timeInterval: timeInterval, since: date)
    }
}


public extension Locale {
    enum LocaleLanguage: String {
        case french = "fr"
        case english = "en"
    }

    var currentLanguage: LocaleLanguage {
        let languageCode = self.languageCode ?? "en"
        return LocaleLanguage(rawValue: languageCode) ?? .english
    }

    var isFrench: Bool {
        languageCode?.contains("fr") ?? false
    }

    var isEnglish: Bool {
        languageCode?.contains("en") ?? false
    }

    var localeIdentifier: String {
        isFrench ? "fr" : "en"
    }
}
