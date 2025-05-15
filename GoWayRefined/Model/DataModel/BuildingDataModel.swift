import Foundation

let foodData: [Food] = [
    Food(name: "Pizza Margherita", image: "pizza_margherita.png", price: 9.99, description: "A classic pizza with tomato, mozzarella, and basil."),
    Food(name: "Cheeseburger", image: "cheeseburger.png", price: 5.99, description: "A juicy beef patty with melted cheese, lettuce, and tomato in a toasted bun."),
    Food(name: "Pasta Alfredo", image: "pasta_alfredo.png", price: 12.99, description: "Creamy Alfredo sauce served with fettuccine pasta and parmesan."),
    Food(name: "Sushi Roll", image: "sushi_roll.png", price: 14.99, description: "Fresh sushi rolls with salmon, avocado, and cucumber wrapped in seaweed."),
    Food(name: "Chicken Caesar Salad", image: "chicken_caesar_salad.png", price: 8.99, description: "Grilled chicken on a bed of romaine lettuce, with Caesar dressing, croutons, and parmesan."),
    Food(name: "Tacos", image: "tacos.png", price: 6.99, description: "Soft tortillas filled with seasoned beef, lettuce, cheese, and salsa."),
    Food(name: "Vegan Burger", image: "vegan_burger.png", price: 7.99, description: "A plant-based burger served with lettuce, tomato, and avocado on a whole-grain bun."),
    Food(name: "Ice Cream Sundae", image: "ice_cream_sundae.png", price: 4.99, description: "Vanilla ice cream topped with chocolate syrup, whipped cream, and a cherry."),
    Food(name: "BBQ Ribs", image: "bbq_ribs.png", price: 15.99, description: "Tender ribs coated with smoky BBQ sauce and served with mashed potatoes."),
    Food(name: "Vegetable Stir-fry", image: "vegetable_stirfry.png", price: 11.99, description: "Mixed vegetables stir-fried in soy sauce, served with steamed rice.")
]
let movieData : [Movie] = [
    Movie(name: "The Matrix", image: "matrix.jpg", price: 12.99, label: ._18Plus),
    Movie(name: "The Lion King", image: "lion_king.jpg", price: 8.99, label: ._2D),
    Movie(name: "Inception", image: "inception.jpg", price: 10.99, label: ._18Plus),
    Movie(name: "Frozen", image: "frozen.jpg", price: 7.99, label: ._2D),
    Movie(name: "Deadpool", image: "deadpool.jpg", price: 14.99, label: ._18Plus),
    Movie(name: "Toy Story 4", image: "toy_story_4.jpg", price: 9.99, label: ._2D),
]

let clothData: [Cloth] = [
    Cloth(name: "T-shirt", image: "tshirt.png", price: 15.99, label: .boy),
    Cloth(name: "Dress", image: "dress.png", price: 25.99, label: .girl),
    Cloth(name: "Jeans", image: "jeans.png", price: 29.99, label: .boy),
    Cloth(name: "Skirt", image: "skirt.png", price: 20.00, label: .girl),
    Cloth(name: "Sweater", image: "sweater.png", price: 35.00, label: .boy)
]

let routeData: [Route] = [
    Route(name: "Route A", dayName: "Monday", image: "routeA.png"),
    Route(name: "Route B", dayName: "Tuesday", image: "routeB.png"),
    Route(name: "Route C", dayName: "Wednesday", image: "routeC.png"),
    Route(name: "Route D", dayName: "Thursday", image: "routeD.png"),
    Route(name: "Route E", dayName: "Friday", image: "routeE.png")
]

let scheduleData: [Schedule] = [
    Schedule(dayName: "Monday", hour: "9:00 AM"),
    Schedule(dayName: "Tuesday", hour: "10:00 AM"),
    Schedule(dayName: "Wednesday", hour: "2:00 PM"),
    Schedule(dayName: "Thursday", hour: "3:30 PM"),
    Schedule(dayName: "Friday", hour: "5:00 PM")
]

let tarifData: [Tarif] = [
    Tarif(vehicleType: "Car", price: 10.00, firstHourRate: 5.00, hourlyRate: 2.00),
    Tarif(vehicleType: "Motorcycle", price: 5.00, firstHourRate: 3.00, hourlyRate: 1.00),
    Tarif(vehicleType: "Truck", price: 20.00, firstHourRate: 10.00, hourlyRate: 5.00),
    Tarif(vehicleType: "Bus", price: 15.00, firstHourRate: 7.00, hourlyRate: 3.00),
    Tarif(vehicleType: "Bicycle", price: 2.00, firstHourRate: 1.00, hourlyRate: 0.50)
]

let stepData: [Step] = [
    Step(image: "step1.png", description: "Take the first left after the bus stop."),
    Step(image: "step2.png", description: "Turn right at the traffic light."),
    Step(image: "step3.png", description: "Walk straight until you reach the parking lot."),
    Step(image: "step4.png", description: "Cross the street at the zebra crossing."),
    Step(image: "step5.png", description: "Take the elevator to the 3rd floor.")
]


func getRandomItems<T>(from data: [T]) -> [T] {
    var dataset: [T] = []
    for _ in 0..<Int.random(in: 1...3) {
        dataset.append(data[Int.random(in: 0..<data.count)])
    }
    return dataset
}

func generateVendors(type: VendorType, count: Int) -> [Vendor] {
    var vendors: [Vendor] = []
    
    for index in 0..<count {
        let vendor: Vendor
        
        // Create starting point and destination steps
        let startingStep = Step(image: "busway", description: "Starting point")
        let destinationStep = Step(image: "busway", description: "Destination Reached")
        
        // Get random middle steps
        let middleSteps = getRandomItems(from: stepData)
        
        // Combine all steps in the correct order
        let completeStepList = [startingStep] + middleSteps + [destinationStep]
        
        switch type {
        case .food:
            vendor = Vendor(name: "Food Vendor \(index)", image: "food", type: type,
                            foodList: getRandomItems(from: foodData),
                            movieList: nil,
                            routeList: nil,
                            tarifList: nil,
                            clothList: nil,
                            scheduleList: nil,
                            stepList: completeStepList)
        case .entertainment:
            vendor = Vendor(name: "Entertainment Vendor \(index)", image: "entertainment", type: type,
                            foodList: nil,
                            movieList: getRandomItems(from: movieData),
                            routeList: nil,
                            tarifList: nil,
                            clothList: nil,
                            scheduleList: nil,
                            stepList: completeStepList)
        case .busway:
            vendor = Vendor(name: "Busway Vendor \(index)", image: "busway", type: type,
                            foodList: nil,
                            movieList: nil,
                            routeList: getRandomItems(from: routeData),
                            tarifList: nil,
                            clothList: nil,
                            scheduleList: nil,
                            stepList: completeStepList)
        case .parkingLot:
            vendor = Vendor(name: "Parking Lot Vendor \(index)", image: "parking", type: type,
                            foodList: nil,
                            movieList: nil,
                            routeList: nil,
                            tarifList: getRandomItems(from: tarifData),
                            clothList: nil,
                            scheduleList: nil,
                            stepList: completeStepList)
        case .lifestyle:
            vendor = Vendor(name: "Lifestyle Vendor \(index)", image: "lifestyle", type: type,
                            foodList: nil,
                            movieList: nil,
                            routeList: nil,
                            tarifList: nil,
                            clothList: getRandomItems(from: clothData),
                            scheduleList: nil,
                            stepList: completeStepList)
        case .worship:
            vendor = Vendor(name: "Worship Vendor \(index)", image: "praying", type: type,
                            foodList: nil,
                            movieList: nil,
                            routeList: nil,
                            tarifList: nil,
                            clothList: nil,
                            scheduleList: getRandomItems(from: scheduleData),
                            stepList: completeStepList)
        case .other:
            vendor = Vendor(name: "Other Vendor \(index)", image: "other", type: type,
                            foodList: nil,
                            movieList: nil,
                            routeList: nil,
                            tarifList: nil,
                            clothList: nil,
                            scheduleList: nil,
                            stepList: nil)
        }
        
        vendors.append(vendor)
    }
    
    return vendors
}

func generateBuilding(name: String = "Green Office Park", latitude: Double = -6.30064, longitude: Double = 106.65054, vendorCount: Int = 5, count: Int) -> [Building] {
    var buildings: [Building] = []
    let realBuilding: Building = Building(name: "Green Office Park 9", image: "gop_9", latitude: -6.30263, longitude: 106.65336, vendors: [Vendor(name: "Shower Room", image: "shower_room", type: .other, stepList: [Step(image: "shower_step1", description: "Find this starting point"), Step(image: "shower_step2", description: "Go straight, the  go down by lift or stairs"), Step(image: "shower_step3", description: "Turn Left"), Step(image: "shower_step4", description: "Turn Left"), Step(image: "shower_step5", description: "You Have Arrived")])], rating: 5)
    
    for index in 0..<count {
        // Generate vendors for each of the 7 types
        let foodVendors = generateVendors(type: .food, count: vendorCount)
        let entertainmentVendors = generateVendors(type: .entertainment, count: vendorCount)
        let buswayVendors = generateVendors(type: .busway, count: vendorCount)
        let parkingLotVendors = generateVendors(type: .parkingLot, count: vendorCount)
        let lifestyleVendors = generateVendors(type: .lifestyle, count: vendorCount)
        let worshipVendors = generateVendors(type: .worship, count: vendorCount)
        let otherVendors = generateVendors(type: .other, count: vendorCount)
        
        // Combine all vendor lists into one
        let allVendors = foodVendors + entertainmentVendors + buswayVendors + parkingLotVendors + lifestyleVendors + worshipVendors + otherVendors
        
        // Generate a random rating between 1.0 and 5.0
        let rating = (Double(Int.random(in: 1...25)) / 5.0)
        
        let building = Building(
            name: "\(name) \(index)",
            image: "office",
            latitude: latitude,
            longitude: longitude,
            vendors: allVendors,
            rating: rating
        )
        
        
        buildings.append(building)
    }
    buildings.append(realBuilding)
    return buildings
}





class BuildingDataModel {
    
    // Single shared instance of the BuildingDataModel class
    static let shared = BuildingDataModel()
    
    private let buildings: [Building]
    
    // Private initializer to prevent instantiating more than one instance
    private init() {
        self.buildings = generateBuilding(count: 5)  // Generate buildings only once
    }
    
    // Get vendors of a specific type grouped by building name
    func getVendors(forType vendorType: VendorType) -> [String: [Vendor]] {
        var vendorsByBuilding: [String: [Vendor]] = [:]
        
        // Loop through all buildings
        for building in buildings {
            // Filter vendors by the specified vendorType for this building
            let vendorsOfType = building.vendors.filter { $0.type == vendorType }
            
            if !vendorsOfType.isEmpty {
                // If vendors of this type exist for the building, add them to the dictionary
                vendorsByBuilding[building.name] = vendorsOfType
            }
        }
        
        return vendorsByBuilding
    }
    
    func getRandomBuildingsWithVendors(count: Int) -> [Building] {
        var randomBuildings: [Building] = []
        
        // Generate a list of random buildings with vendors
        for _ in 0..<count {
            // Select a random building
            let randomBuilding = buildings[Int.random(in: 0..<buildings.count)]
            
            // Select a random vendor from that building (if any vendors exist)
            if randomBuilding.vendors.randomElement() != nil {
                // Create a copy of the building to avoid modifying the original
                let buildingWithRandomVendor = randomBuilding
                
                // Optionally, you can modify or mark the selected vendor here
                // For now, just add the building with the vendor to the list
                randomBuildings.append(buildingWithRandomVendor)
            }
        }
        
        return randomBuildings
    }
    
    // Get all buildings
    func getAllBuildings() -> [Building] {
        return buildings
    }
    //Testing purposes
    //        func printAllBuildings() {
    //            for building in buildings {
    //                // Print the building's name
    //                print("Building Name: \(building.name)")
    //                print("Location: \(building.latitude), \(building.longitude)")
    //                print("Rating: \(building.rating)")
    //                print("--------------------")
    //
    //                // Iterate over vendors and print information about each one
    //                for vendor in building.vendors {
    //                    print("Vendor Name: \(vendor.name)")
    //                    print("Vendor Image: \(vendor.image)")
    //                    print("Vendor Type: \(vendor.type)")
    //
    //                    // Optionally, print the vendor's list items based on type
    //                    if let foodList = vendor.foodList, !foodList.isEmpty {
    //                        print("Food Vendors:")
    //                        for food in foodList {
    //                            print("  - \(food.name) for \(food.price)")
    //                        }
    //                    }
    //
    //                    if let movieList = vendor.movieList, !movieList.isEmpty {
    //                        print("Movies:")
    //                        for movie in movieList {
    //                            print("  - \(movie.name) (\(movie.label)) for \(movie.price)")
    //                        }
    //                    }
    //
    //                    if let routeList = vendor.routeList, !routeList.isEmpty {
    //                        print("Routes:")
    //                        for route in routeList {
    //                            print("  - \(route.name) from \(route.dayName)")
    //                        }
    //                    }
    //
    //                    if let tarifList = vendor.tarifList, !tarifList.isEmpty {
    //                        print("Tarifs:")
    //                        for tarif in tarifList {
    //                            print("  - \(tarif.vehicleType) costs \(tarif.price)")
    //                        }
    //                    }
    //
    //                    if let clothList = vendor.clothList, !clothList.isEmpty {
    //                        print("Clothes:")
    //                        for cloth in clothList {
    //                            print("  - \(cloth.name) for \(cloth.price)")
    //                        }
    //                    }
    //
    //                    if let scheduleList = vendor.scheduleList, !scheduleList.isEmpty {
    //                        print("Schedules:")
    //                        for schedule in scheduleList {
    //                            print("  - \(schedule.dayName) at \(schedule.hour)")
    //                        }
    //                    }
    //
    //                    if let stepList = vendor.stepList, !stepList.isEmpty {
    //                        print("Steps:")
    //                        for step in stepList {
    //                            print("  - \(step.description)")
    //                        }
    //                    }
    //
    //                    print("--------------------") // Separator between vendors
    //                }
    //
    //                print("=====================================") // Separator between buildings
    //            }
    //        }
    
    
}

