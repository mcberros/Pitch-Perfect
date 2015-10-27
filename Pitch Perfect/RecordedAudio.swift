//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Carmen Berros on 25/10/15.
//  Copyright © 2015 mcberros. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathURL: NSURL!
    var title:String!
    
    init(filePathURL: NSURL, title: String){
       self.filePathURL = filePathURL
       self.title = title
    }
}
