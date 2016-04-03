//
//  ViewController.swift
//  ScrollviewTest
//
//  Created by Yung-Tien Chu on 11/18/15.
//  Copyright © 2015 Yung-Tien Chu. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageContainer: UIView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentPageView: UIView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentLowTempLabel: UILabel!
    @IBOutlet weak var currentHighTempLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentRainLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentDewPointLabel: UILabel!
    @IBOutlet weak var currentWindSpeedLabel: UILabel!
    @IBOutlet weak var currentVisibilityLabel: UILabel!
    @IBOutlet weak var currentSunriseLabel: UILabel!
    @IBOutlet weak var currentSunsetLabel: UILabel!
    @IBOutlet weak var dailyWeekday: UILabel!
    @IBOutlet weak var dailyTempRange: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    
    var address = "138 N Beaudry Ave"
    var city = "Los Angeles"
    var state = "CA"
    var unitIndex = 0
    var unit = "si"
    var temperatureUnit = "ºC"
    var windSpeedUnit = "m/s"
    var dewPointUnit = "ºC"
    var visibilityUnit = "km"
    var pressureUnit = "hPa"
    var lat: Double = 0
    var lng: Double = 0
    var backgroundImage: UIImage!
    var summary = ""
    var FBiconString = ""

    var allHourlyWeather: [HourlyWeather] = []
    var weeklyWeather: [DailyWeather] = []
    
    // setup for horizontal page scroll
    var horizontalScroll: UIScrollView!
    var colors:[UIColor] = [UIColor.redColor(), UIColor.blueColor(), UIColor.greenColor()]
    var frame: CGRect = CGRectMake(0,0,0,0)
    var pageControl : UIPageControl!
    var hourlyPage : UITableView!
    var dailyPage : UITableView!
   
    // setup for scrolling using gesture recognizer
    var swipeUp = false
    var swipeDown = false
    
    // handle swipe
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let velocity = recognizer.velocityInView(scrollView)
        
        if (velocity.y < 0) {
            scrollView.setContentOffset(CGPoint(x: 0,y: 300), animated: true)
            swipeUp = true
        } else {
            scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            swipeUp = false
        }
        if (swipeUp == false) {
            self.pageContainer.fadeOut()
        } else {
            self.pageContainer.hidden = false
            self.pageContainer.fadeIn()
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAllUnits()
        
        // configure the horizontall scrollview
        configureHorizontalScroll()
        
        // hide the page container
        self.pageContainer.hidden = true
        
        // retrieving weather data
        retrieveWeather()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        setPageViewInScroll()
    }
    
    func setAllUnits() {
        if (self.unitIndex == 0) {
            unit = "si"
            temperatureUnit = "ºC"
            windSpeedUnit = "m/s"
            dewPointUnit = "ºC"
            visibilityUnit = "km"
            pressureUnit = "hPa"
        } else {
            unit = "us"
            temperatureUnit = "ºF"
            windSpeedUnit = "mph"
            dewPointUnit = "ºF"
            visibilityUnit = "mi"
            pressureUnit = "mb"
        }
    }
    
    @IBAction func facebookShare(sender: AnyObject) {
//        let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
//        content.contentURL = NSURL(string: "https://forecast.io/")
//        content.contentTitle = "Current Weather in \(self.city), \(self.state)"
//        content.contentDescription = "\(self.summary), \(currentTemperatureLabel.text!)"
//        content.imageURL = NSURL(string: "http://cs-server.usc.edu:18489/HW8/\(self.FBiconString)")
//        FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil )
        let login: FBSDKLoginManager = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile", "email"], fromViewController: self) { (result, error) -> Void in
            if ((error) != nil) {
                print("Process error");
            } else if (result.isCancelled) {
                print("Cancelled");
            } else {
                print("Logged in");
            }
        }
    }
    
    
    func configureHorizontalScroll() {
        let pageContainerWidth:CGFloat = 320
        let pageContainerHeight:CGFloat = 275
        self.horizontalScroll = UIScrollView(frame: CGRectMake(0, 0, pageContainerWidth, pageContainerHeight))
        self.pageControl = UIPageControl(frame: CGRectMake(0, 280, self.pageContainer.frame.width, 30))
        horizontalScroll.delegate = self
        configurePageControl()
        self.pageContainer.addSubview(horizontalScroll)
    }
    
    func setPageViewInScroll() {
        
        // adding current detail page
        frame.origin.x = self.horizontalScroll.frame.size.width * CGFloat(0)
        frame.size = self.horizontalScroll.frame.size
        self.horizontalScroll.pagingEnabled = true
        self.horizontalScroll.addSubview(currentPageView)
        let horizontalConstraint = NSLayoutConstraint(item: currentPageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: horizontalScroll, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        horizontalScroll.addConstraint(horizontalConstraint)
        
        // adding hourly detail page
        frame.origin.x = self.horizontalScroll.frame.size.width * CGFloat(1)
        frame.size = self.horizontalScroll.frame.size
        self.hourlyPage = UITableView(frame: frame)
        self.hourlyPage.backgroundColor = UIColor.clearColor()
        self.hourlyPage.separatorColor = UIColor.clearColor()
        self.horizontalScroll.addSubview(hourlyPage)
        
        //adding weekly detail page
        frame.origin.x = self.horizontalScroll.frame.size.width * CGFloat(2)
        frame.size = self.horizontalScroll.frame.size
        self.horizontalScroll.pagingEnabled = true
        self.dailyPage = UITableView(frame: frame)
        self.dailyPage.backgroundColor = UIColor.clearColor()
        self.dailyPage.separatorColor = UIColor.clearColor()
        self.horizontalScroll.addSubview(dailyPage)
        
        // tableview setup
        self.hourlyPage.delegate = self
        self.hourlyPage.dataSource = self
        self.hourlyPage.registerNib(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
        self.hourlyPage.allowsSelection = false
        self.dailyPage.delegate = self
        self.dailyPage.dataSource = self
        self.dailyPage.registerNib(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
        self.dailyPage.allowsSelection = false
        
        self.horizontalScroll.contentSize = CGSizeMake(self.horizontalScroll.frame.size.width * 3, self.horizontalScroll.frame.size.height)
        
        pageControl.addTarget(self, action: Selector("changePage:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func configurePageControl() {
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.redColor()
        self.pageControl.pageIndicatorTintColor = UIColor.blackColor()
        self.pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        self.pageContainer.addSubview(pageControl)
    }
    
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * horizontalScroll.frame.size.width
        horizontalScroll.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if (tableView == dailyPage) {
            return weeklyWeather.count
        } else if (tableView == hourlyPage) {
            return allHourlyWeather.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell", forIndexPath: indexPath) as! WeatherTableViewCell
        if (tableView == dailyPage) {
            let dailyWeather = weeklyWeather[indexPath.row]
            if let maxTemp = dailyWeather.maxTemperature, minTemp = dailyWeather.minTemperature {
                cell.tempLabel.text = "↓\(minTemp)º↑\(maxTemp)º"
            }
            cell.iconLabel.image = dailyWeather.icon
            cell.timeLabel.text = dailyWeather.day
            
        
        } else if (tableView == hourlyPage) {
            let hourlyWeather = allHourlyWeather[indexPath.row]
            if let hourlyTemp = hourlyWeather.temperature {
                cell.tempLabel.text = "\(hourlyTemp)º"
            }
            cell.iconLabel.image = hourlyWeather.icon
            cell.timeLabel.text = hourlyWeather.hour
            return cell
        }
        return cell
    }
    
    func retrieveWeather() {
        let forecastService = ForecastService(address: address, city: city, state: state, unit: unit)
        forecastService.getForecast() {
            (let forecast) in
            if let weatherForecast = forecast,
                let currentWeather = weatherForecast.currentWeather {
                    // Update UI
                    // concurrent programming
                    // in the background queue, want to get into main queue call dispatch
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        // current data
                        if let temperature = currentWeather.temperature {
                            self.currentTemperatureLabel?.text = "\(temperature)\(self.temperatureUnit)"
                        }
                        
                        if let temperatureMin = currentWeather.temperatureMin {
                            self.currentLowTempLabel?.text = "\(temperatureMin)"
                        }
                        
                        if let temperatureMax = currentWeather.temperatureMax {
                            self.currentHighTempLabel?.text = "\(temperatureMax)"
                        }
                        
                        if let humidity = currentWeather.humidity {
                            self.currentHumidityLabel?.text = "\(humidity)%"
                        }
                        
                        if let precipitation = currentWeather.precipitation {
                            self.currentPrecipitationLabel?.text = "\(precipitation)"
                        }
                        
                        if let chanceRain = currentWeather.chanceRain {
                            self.currentRainLabel?.text = "\(chanceRain)%"
                        }
                        
                        if let windSpeed = currentWeather.windSpeed {
                            self.currentWindSpeedLabel?.text = "\(windSpeed)\(self.windSpeedUnit)"
                        }
                        
                        if let dewPoint = currentWeather.dewPoint {
                            self.currentDewPointLabel?.text = "\(dewPoint)\(self.dewPointUnit)"
                        }
                        
                        if let visibility = currentWeather.visibility {
                            self.currentVisibilityLabel?.text = "\(visibility)\(self.visibilityUnit)"
                        }
                        
                        if let sunriseTime = currentWeather.sunriseTime {
                            self.currentSunriseLabel?.text = "\(sunriseTime)"
                        }
                        
                        if let sunsetTime = currentWeather.sunsetTime {
                            self.currentSunsetLabel?.text = "\(sunsetTime)"
                        }
                        
                        if let summary = currentWeather.summary, let city = currentWeather.city, let state = currentWeather.state {
                            self.currentSummaryLabel?.text = "\(summary) in \(city), \(state)"
                        }
                        
                        self.backgroundImage = currentWeather.background
                        self.imageView.image = currentWeather.background
                        self.lat = weatherForecast.lat!
                        self.lng = weatherForecast.lng!
                        self.summary = currentWeather.summary!
                        self.FBiconString = currentWeather.iconString!
                        // hourly data
                        self.allHourlyWeather = weatherForecast.hourly
                        
                        // daily data
                        self.weeklyWeather = weatherForecast.weekly
                        
                        self.hourlyPage.reloadData()
                        self.dailyPage.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goBackToFormSegue") {
            let svc = segue.destinationViewController as! SearchFormViewController;
            
            svc.address = self.address
            svc.city = self.city
            svc.state = self.state
            svc.unitIndex = self.unitIndex
        }
        if (segue.identifier == "goToMapSegue") {
            let svc = segue.destinationViewController as! MapViewController;
            
            svc.address = self.address
            svc.city = self.city
            svc.state = self.state
            svc.unitIndex = self.unitIndex
            svc.lat = self.lat
            svc.lng = self.lng
        }
    }

}

