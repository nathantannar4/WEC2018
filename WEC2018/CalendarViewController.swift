//
//  CalendarViewController.swift
//  WEC2018
//
//  Created by Nathan Tannar on 1/12/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    var monthLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var daysOfWeekHeader: UIStackView = {
        let days = ["SUN","MON","TUE","WED","THU","FRI","SAT"]
        let dayLabels: [UILabel] = days.map {
            let label = UILabel()
            label.font = .boldSystemFont(ofSize: 18)
            label.text = $0
            label.textAlignment = .center
            return label
        }
        let stackView = UIStackView(arrangedSubviews: dayLabels)
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var calendarView: JTAppleCalendarView = {
        let calendarView = JTAppleCalendarView()
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        return calendarView
    }()
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter
    }()
    
    let persianDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCalendarView()
    }
    
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState){
        
        guard let validCell = cell as? CalendarCell else { return }
        
        if validCell.isSelected {
            
        } else {
            let today = Date()
            persianDateFormatter.dateFormat = "yyyy MM dd"
            let todayDateStr = persianDateFormatter.string(from: today)
            dateFormatter.dateFormat = "yyyy MM dd"
            let cellDateStr = dateFormatter.string(from: cellState.date)
            
            if todayDateStr == cellDateStr {
                validCell.dateLabel.textColor = UIColor.yellow
            } else {
                if cellState.dateBelongsTo == .thisMonth {
                    validCell.dateLabel.textColor = UIColor.black
                } else { //i.e. case it belongs to inDate or outDate
                    validCell.dateLabel.textColor = UIColor.gray
                }
            }
        }
    }
    
    
    func setupCalendarView(){
        
        view.addSubview(calendarView)
        view.addSubview(daysOfWeekHeader)
        
        daysOfWeekHeader.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        calendarView.backgroundColor = .clear
        calendarView.anchor(daysOfWeekHeader.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 400)
        calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.reuseIdentifier)
        calendarView.register(CalendarHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CalendarHeader.reuseIdentifier)
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.scrollDirection = .horizontal
        calendarView.showsHorizontalScrollIndicator = false
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.selectDates([Date()], triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: false)
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let persianCalendar = Calendar(identifier: .persian)
        
        let testFotmatter = DateFormatter()
        testFotmatter.dateFormat = "yyyy/MM/dd"
        testFotmatter.timeZone = persianCalendar.timeZone
        testFotmatter.locale = persianCalendar.locale
        
        let startDate = testFotmatter.date(from: "2000/01/01")!
        let endDate = testFotmatter.date(from: "2030/12/30")!
        
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: nil, calendar: persianCalendar, generateInDates: nil, generateOutDates: nil, firstDayOfWeek: nil, hasStrictBoundaries: nil)
        
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let date = range.start
        let month = Calendar.current.component(.month, from: date)
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: CalendarCell.reuseIdentifier, for: indexPath) as! CalendarHeader
        header.title.text = date.monthNameShort
        
        return header
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CalendarCell.reuseIdentifier, for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        
        //        handleCellSelected(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
        
        return cell
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // The code here is the same as cellForItem function
        let cell = cell as! CalendarCell
        cell.dateLabel.text = cellState.text
        
//        handleCellSelected(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print(cellState.dateBelongsTo)
//        handleCellSelected(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        handleCellSelected(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    
}
