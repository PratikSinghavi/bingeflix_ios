//
//  CommunicatorService.swift
//  swifthw
//
//  Created by Pratik Singhavi on 4/15/21.
//

import Foundation
import Alamofire
import SwiftyJSON

/*
class CommService{
    
    let baseURL = self.base_url+"/"
    
    func getData(endPoint:String) -> JSON{
        
        var json = JSON()
        AF.request(self.baseURL+endPoint,method: .get)
            .responseJSON{ response in
                
                if response.data != nil{
                    json = try! JSON(data: response.data!)
                    }
                    
                }
       return json
    }
}
 
 
 //    init(){
 //        let service = CommService()
 //        service.getData(endPoint: "now-playing")
 //
 //    }
 
 */


class CarouselViewModel: ObservableObject{
    @Published var mainCarouselData = [CarouselModel]()
    @Published var TRCardCarData = [CardCarouselModel]()
    @Published var PopCardCarData = [CardCarouselModel]()
    @Published var isLoading = true
    
    var base_url = "https://angnodehw-309323.wl.r.appspot.com"
//    var base_url = "http://localhost:8080"
    
    init(){
        
        // ------------------ Main Carousel Data ------------------
        
        var url =  self.base_url+"/now-playing"
        
        AF.request(url).responseData{(data) in
            
    
            let json = try! JSON(data:data.data!) // JSON part is from SwiftyJSON
            
            var count = 0
            for i in json{


                self.mainCarouselData.append(CarouselModel(id:count
                                           , mediaID: i.1["id"].intValue
                                           ,name: i.1["name"].stringValue
                                           ,image: i.1["image"].stringValue
                                    ))
                count+=1
            }
            
            //here
            
            // ------------------ Top Rated Card Carousel Data ------------------
            
            url =  self.base_url+"/car/movie/top_rated"
            
            AF.request(url).responseData{(data) in
                
        
                let json = try! JSON(data:data.data!) // JSON part is from SwiftyJSON
                
                var count = 0
                for i in json{


                    self.TRCardCarData.append(CardCarouselModel(id:count
                                                ,mediaID: i.1["id"].intValue
                                               , year: i.1["release_date"].stringValue
                                               ,name: i.1["name"].stringValue
                                               ,image: i.1["image"].stringValue
                                        ))
                    count+=1
                }
                
                //here
                
                // ------------------ Popular Card Carousel Data ------------------
                url =  self.base_url+"/car/movie/popular"
                
                AF.request(url).responseData{(data) in
                    
            
                    let json = try! JSON(data:data.data!) // JSON part is from SwiftyJSON
                    
                    var count = 0
                    for i in json{


                        self.PopCardCarData.append(CardCarouselModel(id:count
                                                    ,mediaID: i.1["id"].intValue
                                                   , year: i.1["release_date"].stringValue
                                                   ,name: i.1["name"].stringValue
                                                   ,image: i.1["image"].stringValue
                                            ))
                        count+=1
                    }
                    
                    self.isLoading = false
                }
            }
        }
        
       
        
        
     
        
        
        
        
       
        
        
    }
    
    
    fileprivate func getTRCardCarData(_ url: String,MovieTvMode:Bool) {
        self.TRCardCarData.removeAll()
        AF.request(url).responseData{(data) in
            
            
            let json = try! JSON(data:data.data!) // JSON part is from SwiftyJSON
            
            var count = 0
            for i in json{
                
                
                self.TRCardCarData.append(CardCarouselModel(id:count
                                                            ,mediaID: i.1["id"].intValue
                                                            , year: i.1["release_date"].stringValue
                                                            ,name: i.1["name"].stringValue
                                                            ,image: i.1["image"].stringValue
                ))
                count+=1
                
               
            }
            let url  = MovieTvMode ? self.base_url+"/car/movie/popular" : self.base_url+"/car/tv/popular"
            
            self.getPopCardCarData(url,MovieTvMode:MovieTvMode)
        }
    }
    
    fileprivate func getPopCardCarData(_ url: String,MovieTvMode:Bool) {
        self.PopCardCarData.removeAll()
        AF.request(url).responseData{(data) in
            
            
            let json = try! JSON(data:data.data!) // JSON part is from SwiftyJSON
            
            var count = 0
            for i in json{
                
                
                self.PopCardCarData.append(CardCarouselModel(id:count
                                                             ,mediaID: i.1["id"].intValue
                                                             , year: i.1["release_date"].stringValue
                                                             ,name: i.1["name"].stringValue
                                                             ,image: i.1["image"].stringValue
                ))
                count+=1
            }
            
            self.isLoading = false
        }
    }
    
    fileprivate func getCarouselData(_ url: String,MovieTvMode: Bool) {
        // ------------------ Main Carousel Data ------------------
        
        self.mainCarouselData.removeAll()
        AF.request(url).responseData{(data) in
            
            
            let json = try! JSON(data:data.data!) // JSON part is from SwiftyJSON
            
            var count = 0
            for i in json{
                
                
                self.mainCarouselData.append(CarouselModel(id:count
                                                           ,mediaID: i.1["id"].intValue
                                                           ,name: i.1["name"].stringValue
                                                           ,image: i.1["image"].stringValue
                ))
                count+=1
                
                
               
            }
            let url  = MovieTvMode ? self.base_url+"/car/movie/top_rated" : self.base_url+"/car/tv/top_rated"
            
            self.getTRCardCarData(url,MovieTvMode:MovieTvMode)
        }
    }
    
    func switchMode(MovieTvMode:Bool) {
        let url  = MovieTvMode ? self.base_url+"/now-playing" : self.base_url+"/airing-today"
        getCarouselData(url,MovieTvMode:MovieTvMode)
        
        
        // ------------------ Top Rated Card Carousel Data ------------------
        
     
        
        
        // ------------------ Popular Card Carousel Data ------------------
        
       
//        self.isLoading = false
        
            
    }
    

    
}


struct CarouselModel: Identifiable {
    var id:Int
//    var year: Int
    var mediaID:Int
    var name: String
    var image: String
}


struct CardCarouselModel: Identifiable {
    var id:Int
    var mediaID:Int
    var year: String
    var name: String
    var image: String
}
