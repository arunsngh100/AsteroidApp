//
//  AsteroidTableCell.swift
//  Asteroid Neo App
//
//  Created by Kashware Dev on 10/11/21.
//

import UIKit

class AsteroidTableCell: UITableViewCell {

    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var bgShadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgShadowView.draw3DShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCellUI(data: SMAsteroid) {
        lbltitle.text = "Asteroid Id: " + data.id
        lblSubTitle.text = "Asteroid Name: " + data.name
    }
    
    func configureCellUISpeedSorted(data: SMAsteroid) {
        lbltitle.text = "Asteroid Id: " + data.id
        lblSubTitle.text = "Speed: " + data.closeApproachData.kilometersPerHour + " Km/hr"
    }
    
    func configureCellUIDistanceSorted(data: SMAsteroid) {
        lbltitle.text = "Asteroid Id: " + data.id
        lblSubTitle.text = "Distance: " + data.closeApproachData.kilometers + " Kms"
    }
    
    func configureCellUIAvgSizeSorted(data: SMAsteroid) {
        lbltitle.text = "Asteroid Id: " + data.id
        lblSubTitle.text = "Avg. Size: " + data.formattedAvgSize + " Km"
    }
    
    
}
