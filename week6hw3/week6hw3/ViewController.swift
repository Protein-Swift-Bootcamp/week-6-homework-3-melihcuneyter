//
//  ViewController.swift
//  week6hw3
//
//  Created by Melih Cüneyter on 10.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var layout = PinterestLayout()
    
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
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.collectionViewLayout = layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ContentCVC.nib(), forCellWithReuseIdentifier: "ContentCVC")
        
        layout.columnsCount = 2
        layout.delegate = self
        layout.contentPadding = PinterestLayout.Padding(horizontal: 5, vertical: 5)
        layout.cellsPadding = PinterestLayout.Padding(horizontal: 10, vertical: 10)
        
        collectionView.setContentOffset(CGPoint.zero, animated: false)
        collectionView.reloadData()
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

extension ViewController: PinterestLayoutDelegate {
    func cellSize(indexPath: IndexPath) -> CGSize {
//        guard let width = image.thumbnail?.width, let height = image.thumbnail?.height else { return .zero }
//        let cellWidth = layout.width
//        let size = CGSize(width: Int(cellWidth), height: Int((height/width) * cellWidth))
//        return size
        return CGSize(width: 200, height: 200)
    }
}

