//
//  ViewController.swift
//  week6hw3
//
//  Created by Melih Cüneyter on 10.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var parser = XMLParser()
    var arrDetail: [String] = []
    var arrFinal: [[String]] = []
    var content: String = ""
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str = "https://www.cnnturk.com/feed/rss/all/news"
        let url = URL(string: str)
        parser = XMLParser(contentsOf: url!) ?? XMLParser()
        parser.delegate = self
        parser.parse()
        
        collectionView.register(ContentCVC.nib(), forCellWithReuseIdentifier: "ContentCVC")
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

// MARK: - CollectionView Delegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

// MARK: - CollectionView DataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFinal.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCVC", for: indexPath) as! ContentCVC
        let tempArr = arrFinal[indexPath.row]
        let content = tempArr[0]
        let imageURL = tempArr[1]
        cell.configure(with: imageURL, content: content)
        return cell
    }
}

