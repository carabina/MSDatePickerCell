//
//  MSDatePickerCell.swift
//  MSDatePickerCell-Demo
//
//  Created by 須藤 将史 on 2017/02/04.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import UIKit

@objc enum DatePickerStyle: Int {
    case YMD
    case YM
    case MD
}

private extension UIColor {
    static func unable() -> UIColor {
        return UIColor.init(colorLiteralRed: 200.0/255.0, green: 200.0/255.0, blue: 205.0/255.0, alpha: 1)
    }
}

private extension Date {
    static func dateFromString(string: String, format: String, calendar: Calendar) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }
    
    func string(format: String, calendar: Calendar) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

class MSDatePickerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    public var cal: Calendar = Calendar.init(identifier: .gregorian)
    public var picker: UIPickerView

    private var dateUpdated: (Date) -> Void
    private var style: DatePickerStyle
    
    let isJapanLanguage: Bool = {
        if let lang: String = NSLocale.preferredLanguages.first {
            return lang.substring(to: lang.index(lang.startIndex, offsetBy: 2)) == "ja"
        } else {
            return false
        }
    }()
    
    let years: [Int] = (1900...2100).map { $0 }
    let months: [Int] = (1...12).map { $0 }
    let enMonths: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let days: [Int] = (1...31).map { $0 }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(date: Date = Date(), style: DatePickerStyle, dateUpdated: @escaping ((Date) -> Void)) {
        
        self.dateUpdated = dateUpdated
        self.style = style
        self.picker = UIPickerView()
        self.picker.showsSelectionIndicator = true
        
        super.init(style: .default, reuseIdentifier: "DatePickerCell")
        
        self.picker.delegate = self
        self.defaultSelectPickerRow(date: date)
        
        self.accessoryType = .none
        self.selectionStyle = .none
        self.clipsToBounds = true
        self.contentView.addSubview(self.picker)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var insets = self.layoutMargins
        insets.left = insets.left > 20 ? insets.left : 0
        insets.right = insets.right > 20 ? insets.right : 0
        
        self.picker.frame = CGRect(x: insets.left, y: 0, width: self.frame.width - (insets.left + insets.right), height: self.picker.frame.height)
    }
    
    // MARK: - UIPickerView data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        switch self.style {
        case .YMD: return 3
        case .YM: return 2
        case .MD: return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch self.style {
        case .YMD:
            
            if isJapanLanguage {

                if component == 0 {
                    return years.count
                } else if component == 1 {
                    return months.count
                } else {
                    return days.count
                }
                
            } else {
                
                if component == 0 {
                    return enMonths.count
                } else if component == 1 {
                    return days.count
                } else {
                    return years.count
                }
            }
            
        case .YM:
            
            if isJapanLanguage {
            
                if component == 0 {
                    return years.count
                } else {
                    return months.count
                }

            } else {

                if component == 0 {
                    return enMonths.count
                } else {
                    return years.count
                }
            }
            
        case .MD:
            
            if component == 0 {
                return months.count
            } else {
                return days.count
            }
        }
    }
    
    // MARK: - UIPickerView delegate
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        switch self.style {
        case .YMD:

            if isJapanLanguage {
            
                if component == 0 {
                    return NSAttributedString.init(string: "\(years[row])年")
                } else if component == 1 {
                    return NSAttributedString.init(string: "\(months[row])月")
                } else {
                    
                    switch days[row] {
                    case 29, 30, 31:
                        return self.ableOrUnableDay(pickerView, year: years[pickerView.selectedRow(inComponent: 0)], month: months[pickerView.selectedRow(inComponent: 1)], day: days[row])
                    default:
                        return NSAttributedString.init(string: "\(days[row])日")
                    }
                }

            } else {

                if component == 0 {
                    return NSAttributedString.init(string: "\(enMonths[row])")
                } else if component == 1 {

                    switch days[row] {
                    case 29, 30, 31:
                        return self.ableOrUnableDay(pickerView, year: years[pickerView.selectedRow(inComponent: 2)], month: months[pickerView.selectedRow(inComponent: 0)], day: days[row])
                    default:
                        return NSAttributedString.init(string: "\(days[row])")
                    }

                } else {
                    return NSAttributedString.init(string: "\(years[row])")
                }
            }
            
        case .YM:

            if isJapanLanguage {
                
                if component == 0 {
                    return NSAttributedString.init(string: "\(years[row])年")
                } else {
                    return NSAttributedString.init(string: "\(months[row])月")
                }
                
            } else {
                
                if component == 0 {
                    return NSAttributedString.init(string: "\(enMonths[row])")
                } else {
                    return NSAttributedString.init(string: "\(years[row])")
                }
            }

        case .MD:
            
            if component == 0 {
                
                if isJapanLanguage {
                    return NSAttributedString.init(string: "\(months[row])月")
                } else {
                    return NSAttributedString.init(string: "\(enMonths[row])")
                }
                
            } else {
                
                switch days[row] {
                case 29, 30, 31:
                    return self.ableOrUnableDay(pickerView, year: self.cal.component(.year, from: Date()), month: months[pickerView.selectedRow(inComponent: 0)], day: days[row])
                default:
                    if isJapanLanguage {
                        return NSAttributedString.init(string: "\(days[row])日")
                    } else {
                        return NSAttributedString.init(string: "\(days[row])")
                    }
                }
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        var year: Int
        var month: Int
        var day: Int

        switch self.style {
        case .YMD:

            if isJapanLanguage {
                year = years[pickerView.selectedRow(inComponent: 0)]
                month = months[pickerView.selectedRow(inComponent: 1)]
                day = days[pickerView.selectedRow(inComponent: 2)]
            } else {
                year = years[pickerView.selectedRow(inComponent: 2)]
                month = months[pickerView.selectedRow(inComponent: 0)]
                day = days[pickerView.selectedRow(inComponent: 1)]
            }
            
            let dateString: String = String(format: "%d/%02d/%02d 00:00:00 +0900", year, month, day)
            let date: Date = Date.dateFromString(string: dateString, format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal)
            
            // 存在しない日付を変換した場合
            if dateString != date.string(format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal) {
                self.defaultSelectPickerRow(date: date)
            }
            
            self.dateUpdated(date)
            
        case .YM:
            
            if isJapanLanguage {
                year = years[pickerView.selectedRow(inComponent: 0)]
                month = months[pickerView.selectedRow(inComponent: 1)]
            } else {
                year = years[pickerView.selectedRow(inComponent: 1)]
                month = months[pickerView.selectedRow(inComponent: 0)]
            }
            
            let dateString: String = String(format: "%d/%02d/01 00:00:00 +0900", year, month)
            
            self.dateUpdated(Date.dateFromString(string: dateString, format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal))
            
        case .MD:
            
            year = self.cal.component(.year, from: Date())
            month = months[pickerView.selectedRow(inComponent: 0)]
            day = days[pickerView.selectedRow(inComponent: 1)]
            let dateString: String = String(format: "%d/%02d/%02d 00:00:00 +0900", year, month, day)
            let date: Date = Date.dateFromString(string: dateString, format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal)
            
            if dateString != date.string(format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal) {
                // 存在しない日付を変換した場合
                self.defaultSelectPickerRow(date: date)
            }
            
            self.dateUpdated(Date.dateFromString(string: dateString, format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal))
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        if isJapanLanguage {
            switch self.style {
            case .YMD:
                return pickerView.frame.width * 0.3
            case .YM:
                return pickerView.frame.width * 0.5
            case .MD:
                return pickerView.frame.width * 0.5
            }
        } else {
            switch self.style {
            case .YMD:
                if component == 0 {
                    return pickerView.frame.width * 0.4
                } else if component == 1 {
                    return pickerView.frame.width * 0.2
                } else {
                    return pickerView.frame.width * 0.4
                }
            case .YM:
                return pickerView.frame.width * 0.5
            case .MD:
                return pickerView.frame.width * 0.5
            }
        }
    }
    
    open class func preferredHeight() -> CGFloat {
        return 216
    }
    
    // MARK: Pickerのデフォルト値を設定
    
    final private func defaultSelectPickerRow(date: Date) {
        
        switch self.style {
        case .YMD:
            
            var yi: Int = 0
            if let yearIndex = years.index(of: self.cal.component(.year, from: date)) {
                yi = yearIndex
            }
            var mi: Int = 0
            if let monthIndex = months.index(of: self.cal.component(.month, from: date)) {
                mi = monthIndex
            }
            var di: Int = 0
            if let dayIndex = days.index(of: self.cal.component(.day, from: date)) {
                di = dayIndex
            }

            if isJapanLanguage {
                self.picker.selectRow(yi, inComponent:0, animated:true)
                self.picker.selectRow(mi, inComponent:1, animated:true)
                self.picker.selectRow(di, inComponent:2, animated:true)
            } else {
                self.picker.selectRow(yi, inComponent:2, animated:true)
                self.picker.selectRow(mi, inComponent:0, animated:true)
                self.picker.selectRow(di, inComponent:1, animated:true)
            }
            
        case .YM:
            
            var yi: Int = 0
            if let yearIndex = years.index(of: self.cal.component(.year, from: date)) {
                yi = yearIndex
            }
            var mi: Int = 0
            if let monthIndex = months.index(of: self.cal.component(.month, from: date)) {
                mi = monthIndex
            }

            if isJapanLanguage {
                self.picker.selectRow(yi, inComponent:0, animated:true)
                self.picker.selectRow(mi, inComponent:1, animated:true)
            } else {
                self.picker.selectRow(yi, inComponent:1, animated:true)
                self.picker.selectRow(mi, inComponent:0, animated:true)
            }
            
        case .MD:
            
            var mi: Int = 0
            if let monthIndex = months.index(of: self.cal.component(.month, from: date)) {
                mi = monthIndex
            }
            self.picker.selectRow(mi, inComponent:0, animated:true)
            
            var di: Int = 0
            if let dayIndex = days.index(of: self.cal.component(.day, from: date)) {
                di = dayIndex
            }
            self.picker.selectRow(di, inComponent:1, animated:true)
        }
    }
    
    // MARK: 存在する・しない日付で色を変更
    
    private func ableOrUnableDay(_ pickerView: UIPickerView, year: Int, month: Int, day: Int) -> NSAttributedString {
        
        let dateString: String = String(format: "%d/%02d/%02d 00:00:00 +0900", year, month, day)
        let date: Date = Date.dateFromString(string: dateString, format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal)
        
        if dateString != date.string(format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal) {
            
            // 存在しない日付を変換した場合
            if isJapanLanguage {
                return NSAttributedString.init(string: "\(day)日", attributes: [NSForegroundColorAttributeName: UIColor.unable()])
            } else {
                return NSAttributedString.init(string: "\(day)", attributes: [NSForegroundColorAttributeName: UIColor.unable()])
            }
            
        } else {
            if isJapanLanguage {
                return NSAttributedString.init(string: "\(day)日")
            } else {
                return NSAttributedString.init(string: "\(day)")
            }
        }
    }
}
