//
//  CSVControl.swift
//  ARTest
//
//  Created by Takuya kato on 2018/07/06.
//  Copyright © 2018 Takuya kato. All rights reserved.
//

import Foundation

//多次元配列からDocuments下にCSVファイルを作る
func createFile(fileName : String, fileArrData : [[Float]]){
    let filePath = NSHomeDirectory() + "/Documents/" + fileName + ".csv"
    print(filePath)
    var fileStrData:String = ""
    
    //StringのCSV用データを準備
    for singleArray in fileArrData{
        for singleString in singleArray{
            fileStrData += String(singleString)
            if singleString != singleArray[singleArray.count-1]{
                fileStrData += ", "
            }
        }
        fileStrData += "\n"
    }
    //print(fileStrData)
    
    do{
        try fileStrData.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        print("Success to Wite the File")
    }catch let error as NSError{
        print("Failure to Write File\n\(error)")
    }
}
