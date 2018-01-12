//
//  CalendarViewController.swift
//  WEC2018
//
//  Created by Nathan Tannar on 1/12/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import Hero
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryColor
        view.apply(Stylesheet.Global.shadow)
        return view
    }()
    
    var monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 36, weight: .medium)
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.adjustsImageWhenHighlighted = false
        button.setImage(#imageLiteral(resourceName: "icon_add").withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        return button
    }()
    
    var daysOfWeekHeader: UIStackView = {
        let days = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        let dayLabels: [UILabel] = days.map {
            let label = UILabel()
            label.font = .boldSystemFont(ofSize: 15)
            label.text = $0
            label.textAlignment = .center
            label.textColor = .white
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
    
    lazy var collectionView: UICollectionView = { [weak self] in
        let layout = CardsCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        layout.itemSize = CGSize(width: 300, height: 180)
        return collectionView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Calendar"
        tabBarItem = UITabBarItem(title: title, image: #imageLiteral(resourceName: "icon_calendar"), tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        setupCalendarView()
    }
    
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState){
        
        guard let validCell = cell as? CalendarCell else { return }
        
        if validCell.isSelected {
            validCell.dateLabel.textColor = UIColor.white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = UIColor.black
            } else { //i.e. case it belongs to inDate or outDate
                validCell.dateLabel.textColor = UIColor.gray
            }
        }
    }
    
    
    func setupCalendarView(){
        
        view.addSubview(headerView)
        headerView.addSubview(monthLabel)
        headerView.addSubview(daysOfWeekHeader)
        headerView.addSubview(addButton)
        view.addSubview(calendarView)
        view.addSubview(collectionView)
        
        headerView.anchor(view.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 130)
        
        monthLabel.anchor(view.safeAreaLayoutGuide.topAnchor, left: headerView.leftAnchor, bottom: nil, right: addButton.leftAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 50)
        
        addButton.anchor(monthLabel.topAnchor, left: nil, bottom: daysOfWeekHeader.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 50, heightConstant: 50)
        
        daysOfWeekHeader.anchor(monthLabel.bottomAnchor, left: headerView.leftAnchor, bottom: headerView.bottomAnchor, right: headerView.rightAnchor)
        
        calendarView.anchor(headerView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor)
        calendarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        collectionView.anchor(calendarView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        calendarView.backgroundColor = .secondaryColor
        calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.reuseIdentifier)
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.scrollDirection = .horizontal
        calendarView.showsHorizontalScrollIndicator = false
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.selectDates([Date()], triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: false)
        monthLabel.text = Date().monthNameFull.capitalized
    }
    
    @objc
    func didTapAdd() {
        
        let newEvent = EventDetailViewController(event: nil)
        present(newEvent, animated: true, completion: nil)
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
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        guard let date = visibleDates.monthDates.first else { return }
        monthLabel.text = date.date.monthNameFull.capitalized
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CalendarCell.reuseIdentifier, for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        

        handleCellTextColor(cell: cell, cellState: cellState)
        
        return cell
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = cell as! CalendarCell
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
}

extension CalendarViewController: UICollectionViewDataSource {
    
    func mockEvent() -> PlannerEvent {
        let event = PlannerEvent()
        event.startDate = Date()
        event.endDate = Date().addDay(1)
        event.notes = "• Lorem ipsum dolor\n• Sit amet, consectetur\n• Adipisicing elit, sed"
        event.title = "Lorem Ipsum Dolor"
        return event
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.reuseIdentifier, for: indexPath) as! EventCell
        cell.controller = self
        cell.dataSourceItem = mockEvent()
        return cell
    }
}

extension CalendarViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = EventDetailViewController(event: mockEvent())
        vc.isHeroEnabled = true
        isHeroEnabled = true
        let cellId = UUID().uuidString
        vc.cell.heroID = cellId
        (collectionView.cellForItem(at: indexPath) as! EventCell).heroID = cellId
        vc.tableView.heroModifiers = [.fade]
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        UIView.animate(withDuration: 0.3) {
            cell.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowRadius = 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        UIView.animate(withDuration: 0.3) {
            cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            cell.layer.shadowColor = UIColor.darkGray.cgColor
            cell.layer.shadowRadius = 2
        }
    }
}
