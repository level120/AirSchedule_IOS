//
//  PublicDataParse.swift
//  AirSchedule_IOS
//
//  Created by Chenny on 18/08/2018.
//  Copyright © 2018  Gusam Park. All rights reserved.
//

import Foundation

/*
 # 항공기 정보
 <airFln>LJ594</airFln>
 <airlineEnglish>JINAIR</airlineEnglish>
 <airlineKorean>진에어</airlineKorean>
 <airport>CJU</airport>
 <arrivedEng>GWANGJU</arrivedEng>
 <arrivedKor>광주</arrivedKor>
 <boardingEng>JEJU</boardingEng>
 <boardingKor>제주</boardingKor>
 <city>KWJ</city>
 <etd>1900</etd>
 <gate>12</gate>
 <io>O</io>
 <line>국내</line>
 <rmkEng>PROCESSING</rmkEng>
 <rmkKor>수속중</rmkKor>
 <std>1900</std>
 */
struct AirPlain {
    var airFln:String!
    var airlineEnglish:String!, airlineKorean:String!
    var airport:String!
    var arrivedEng:String!, arrivedKor:String!
    var boardingEng:String!, boardingKor:String!
    var city:String!
    var gate:Int!
    var io:Character!
    var line:String!
    var rmkEng:String!, rmkKor:String!
    var std:Int!
    var etd:Int!
    
    func title() -> String {
        return "편명 : \(airFln!)\t\(boardingKor!) \(String(format: "%02d:%02d", std!/100, std!%100)) -> \(arrivedKor!)\n변경시간 : \(String(format: "%02d:%02d", etd!/100, etd!%100))\t\t상태 : \(rmkKor!)"
    }
    
}

struct AirInfo {
    private var schStTime:String = "0700", schEdTime:String = "0100"
    private var schLineType:Character = "D", schIOType:Character = "O", schAirCode:String = "PUS"
    /* status : 실시간 운항 정보, domestic : 국내선 운항 정보(일) */
    private let urls: [String: String] = [
        "status" : "http://openapi.airport.co.kr/service/rest/FlightStatusList/getFlightStatusList",
        "domestic" : "http://openapi.airport.co.kr/service/rest/DflightScheduleList/getDflightScheduleList"
    ]
    private let serviceKey:String = "JF77bK9ik6W0XvXACLnaOQjOcWh4mTsjZ0J1ADBlOBXdFVO2Ba7e3OExSHPrBp6V27EPNweEbFKyu0617c0Sqw%3D%3D"
    
//    init() {}   // Bebugging only
    
    init(schLineType: Character, schIOType: Character, schAirCode: String) {
        self.schLineType = schLineType
        self.schIOType = schIOType
        self.schAirCode = schAirCode
    }
    
    init(schStTime:String, schEdTime:String ,schLineType: Character, schIOType: Character, schAirCode: String) {
        self.schStTime = schStTime
        self.schEdTime = schEdTime
        self.schLineType = schLineType
        self.schIOType = schIOType
        self.schAirCode = schAirCode
    }
    
    func url() -> String {
        return "\(urls["status"]!)?ServiceKey=\(serviceKey)&schStTime=\(schStTime)&schEdTime=\(schEdTime)&schLineType=\(schLineType)&schIOType=\(schIOType)&schAirCode=\(schAirCode)"
    }
    
}

class PublicDataParse: NSObject, XMLParserDelegate {
    var airItems = [AirPlain]() // 항공편 item Dictional Array
    
    private var xmlParser = XMLParser()
    private var currentElement = ""                // 현재 Element
    private var contents: AirPlain!
    
    override init() {
        super.init()
        request()
    }
    
    func request() {
        let airInfo = AirInfo(schStTime: "0700", schEdTime: "2200", schLineType: "D", schIOType: "O", schAirCode: "PUS")  // 비행정보
        
        guard let xmlParser = XMLParser(contentsOf: URL(string: airInfo.url())!) else { return }
        
        xmlParser.delegate = self;
        xmlParser.parse()
    }
    
    // XMLParserDelegate 함수
    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if (elementName == "item") {
            contents = AirPlain()
        }
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName == "item") {
            airItems.append(contents)
        }
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters data: String)
    {
        switch currentElement {
        case "airFln": contents.airFln = data
        case "airlineEnglish": contents.airlineEnglish = data
        case "airlineKorean": contents.airlineKorean = data
        case "airport": contents.airport = data
        case "arrivedEng": contents.arrivedEng = data
        case "arrivedKor": contents.arrivedKor = data
        case "boardingEng": contents.boardingEng = data
        case "boardingKor": contents.boardingKor = data
        case "city": contents.city = data
        case "etd": contents.etd = Int(data)!
        case "gate": contents.gate = Int(data)!
        case "io": contents.io = Character(data)
        case "line": contents.line = data
        case "rmkEng": contents.rmkEng = data
        case "rmkKor": contents.rmkKor = data
        case "std": contents.std = Int(data)!
        default: print("No datas")
        }
    }
    
}
