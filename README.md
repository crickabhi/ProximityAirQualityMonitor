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
> City AQI Data(**CityAirQuality**) is send to the home screen when an `updateDisplayList` observer event is triggered from viewModel.
> When city's AQI changes from normal to poor than cell's background colour updates based on AQI standard. 
> On selection of any list item, the Real-time graphical visualization screen(**AirQualityVisualizationVC**) for the particular selected city opens.
> The data on this screen is powered by the same viewModel(**AirQualityVM**) listening to the `updateCityAQI` observer event.

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

| Pod | Description |
| ------ | ------ |
| Starscream | [Starscream is a conforming WebSocket (RFC 6455) library in Swift](https://github.com/daltoniam/Starscream) |
| Charts | [A beautiful Charts library](https://github.com/danielgindi/Charts) |

## Screenshots

Fetching Data             |  List of City AQI          |  AQI Standard    
:-------------------------:|:-------------------------:|:-------------------------:
![Screen Shot 1](https://user-images.githubusercontent.com/10657329/123536139-154d4480-d746-11eb-8431-fe9d39f7c8e2.png)  |  ![Screen Shot 2](https://user-images.githubusercontent.com/10657329/123537178-bee30480-d74b-11eb-9c09-d5ad234d87e5.png) | !![Screen Shot 3](https://user-images.githubusercontent.com/10657329/123537376-b3dca400-d74c-11eb-962f-7a1e39166750.png)
  Graphical Representation of City AQI |   Real-time City AQI
![Screen Shot 4](https://user-images.githubusercontent.com/10657329/123536137-141c1780-d746-11eb-8ee2-67ef931f8d20.png)  |  ![Screen Shot 5](https://user-images.githubusercontent.com/10657329/123536138-14b4ae00-d746-11eb-9801-5ec9c5a1127c.png)

