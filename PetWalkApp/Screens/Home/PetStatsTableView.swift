//
//  PetStatsTableView.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 3.12.21.
//

import UIKit
import Charts

class PetStatsTableViewCell: UITableViewCell {
    
    static var identifier = "PetStatsTableView"
    
    private let typeOfStat = UILabel()
    
    private let detailedInformation = UILabel()
    
    private lazy var energyCurrentPieChart = PieChartDataEntry(value: 0)
    private lazy var totalEnergyPieChart = PieChartDataEntry(value: 0)
    
    private let pieCharts = PieChartView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(typeOfStat)
        contentView.addSubview(pieCharts)
        contentView.addSubview(detailedInformation)
        
        [typeOfStat, detailedInformation, pieCharts].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            typeOfStat.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            typeOfStat.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            detailedInformation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            detailedInformation.topAnchor.constraint(equalTo: typeOfStat.bottomAnchor, constant: 5),
            
            pieCharts.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            pieCharts.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pieCharts.widthAnchor.constraint(equalToConstant: 100),
            pieCharts.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        contentView.backgroundColor = UIColor(named: "BackgroundCell")
        
        typeOfStat.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        
        pieCharts.legend.enabled = false
        pieCharts.isUserInteractionEnabled = false
        
        detailedInformation.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var statText: String = "" {
        didSet {
            typeOfStat.text = statText
        }
    }
    
    var energyCurrentInt: Int = 0 {
        didSet {
            energyCurrentPieChart.value = Double(energyCurrentInt)
            updateChars()
        }
    }
    
    var energyTotalInt: Int = 0 {
        didSet {
            totalEnergyPieChart.value = Double(energyTotalInt)
            updateChars()
        }
    }
    
    var detailedInfo: String = "" {
        didSet {
            detailedInformation.text = detailedInfo
        }
    }
    
    func updateChars() {
        let chardDataSet = PieChartDataSet(entries: [energyCurrentPieChart, totalEnergyPieChart], label: nil)
        let chardData = PieChartData(dataSets: [chardDataSet])
        chardData.setDrawValues(false)
        
        let colors = [UIColor.systemTeal, UIColor.systemGray5]
        chardDataSet.colors = colors
        
        pieCharts.data = chardData
    }
}
