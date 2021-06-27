# ProximityAirQualityMonitor
## _Live air quality monitoring app_

Air Quality Monitoring App displays list of cities with their respective air quality indexs and plots the air quality index changes over the peroid of time for particular city in real-time. 
## Features
- List of Cities with there current AQI
- Last updated AQI for a City
- Real time visualization of city's AQI changes

Application uses MVVM architecture with Observer design pattern. 

> The Home Screen(**AirQualityVC**) of application displays a list of cities with there last updated AQI.
> The Home Screen Data is powered by the viewModel(**AirQualityVM**).
> The viewModel creates a connection with socket and receives city aqi data.
> City AQI Data(**CityAirQuality**) is send to the home screen when an **updateDisplayList** observer event is triggered from viewModel.
> On selection of any list item, the Real-time graphical visualization screen(**AirQualityVisualizationVC**) for the particular selected city opens.
> The data on this screen is powered by the same viewModel(**AirQualityVM**) listening to the (**updateCityAQI**) observer event.

#### ViewController's
- [AirQualityVC](https://github.com/crickabhi/ProximityAirQualityMonitor/blob/main/ProximityAirQualityMonitor/ViewController/AirQualityVC.swift) - List of Cities with latest AQI.
- [AirQualityStandardsVC](https://github.com/crickabhi/ProximityAirQualityMonitor/blob/main/ProximityAirQualityMonitor/ViewController/AirQualityStandardsVC.swift) - Central Pollution Board's Air Quality Standard.
- [AirQualityVisualizationVC](https://github.com/crickabhi/ProximityAirQualityMonitor/blob/main/ProximityAirQualityMonitor/ViewController/AirQualityVisualizationVC.swift) - Real-time graphical representation of city's AQI.
#### ViewModel
- [AirQualityVM](https://github.com/crickabhi/ProximityAirQualityMonitor/blob/main/ProximityAirQualityMonitor/ViewModel/AirQualityVM.swift) - Creates required socket connection to listen its messages and renders required information on the UI.
#### Model
- Enum [AirQualityRange](https://github.com/crickabhi/ProximityAirQualityMonitor/blob/main/ProximityAirQualityMonitor/Model/CityAirQuality.swift) 
- Enum [AirQualityIndex](https://github.com/crickabhi/ProximityAirQualityMonitor/blob/main/ProximityAirQualityMonitor/Model/CityAirQuality.swift)
- Protocol [CityAQI](https://github.com/crickabhi/ProximityAirQualityMonitor/blob/main/ProximityAirQualityMonitor/Model/CityAirQuality.swift) - City name and aqi value.
- Struct [CityAirQuality](https://github.com/crickabhi/ProximityAirQualityMonitor/blob/main/ProximityAirQualityMonitor/Model/CityAirQuality.swift) which adheres to CityAQI with lastUpdatedTime.
