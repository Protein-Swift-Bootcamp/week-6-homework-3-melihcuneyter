//
//  ViewController.swift
//  week6hw3
//
//  Created by Melih Cüneyter on 10.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var parser = XMLParser()
    var arrDetail: [String] = []
    var arrFinal: [[String]] = []
    var content: String = ""

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    // MARK: - Fetch Data With XMLParser
    private func fetchData() {
        let str = "https://www.cnnturk.com/feed/rss/all/news"
        let url = URL(string: str)
        DispatchQueue.global(qos: .background).async {
            self.parser = XMLParser(contentsOf: url!) ?? XMLParser()
            self.parser.delegate = self
            self.parser.parse()
        }
    }
}

// MARK: - XMLParser Delegate Methods
extension ViewController: XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        arrFinal.removeAll()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            arrDetail.removeAll()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "image" || elementName == "description" {
            arrDetail.append(content)
        } else if elementName == "item" {
            arrFinal.append(arrDetail)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        content = string
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print(arrFinal)
    }
}

