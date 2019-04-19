//
//  CardView.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/29/18.
//  Copyright © 2019 Golden Age Technologies LLC. All rights reserved.
//

import UIKit

class CardView: UICollectionViewCell {
    
    private static let CELL_ID: String = "CardTableCell"
    private static let CORNER_RADIUS: CGFloat = 16.0
    private static let BORDER_WIDTH: CGFloat = 4.0

    @IBOutlet weak var tableView: UITableView!

    public private(set) var data: Meal = Meal(name: "", date: "", halls: [], foods: []) {
        didSet {
//            label_title.text = data.name
//            label_subtitle.text = data.date
        }
    }
    private var hallToShow: Int = 0

    /*programmatic init     */override init(frame: CGRect) {              super.init(frame: frame);       loadNib()}
    /*interface builder init*/required init?(coder aDecoder: NSCoder) {   super.init(coder: aDecoder);    loadNib()}
    private func loadNib() {Bundle.main.loadNibNamed("CardView", owner: self, options: nil)}


    func oneTimeSetup(withData data: Meal? = nil, butOnlyShow hallToShow: Int = 0) {
        if let data = data {self.data = data}
        self.hallToShow = hallToShow
        roundCorners()
        engageTableView()
    }

//    func update(withData data: Meal) {
//        self.data = data
//        tableView.reloadData()
//    }

    func roundCorners(toRadius radius: CGFloat = CardView.CORNER_RADIUS) {
        contentView.layer.cornerRadius = radius
        contentView.layer.masksToBounds = true
    }

    func addBorder(withWidth width: CGFloat = CardView.BORDER_WIDTH) {
        contentView.layer.borderColor = contentView.backgroundColor?.cgColor
        contentView.layer.borderWidth = width
        contentView.layer.masksToBounds = true
    }
}
    

extension CardView: UITableViewDataSource, UITableViewDelegate {
    
    /*header height*/func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {return 30}
    /*cell height  */func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return 40}
    /*footer height*/func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {return 0}
    
    /*number of sections*/func numberOfSections(in tableView: UITableView) -> Int {return 1}
    /*number of rows    */func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return data.filteredFoods[hallToShow].count}

    //header title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data.name + " for " + data.date
    }
    //header view
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else {return}
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.groupTableViewBackground
        headerView.backgroundView = backgroundView
    }
    
    //cell generation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardView.CELL_ID, for: indexPath) as! CardTableCell
        cell.label.text = data.filteredFoods[hallToShow][indexPath.row].name
        return cell
    }
    
    //MARK: - convenience functions
    func engageTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CardTableCell", bundle: nil), forCellReuseIdentifier: CardView.CELL_ID)
        tableView.reloadData()
    }
}
