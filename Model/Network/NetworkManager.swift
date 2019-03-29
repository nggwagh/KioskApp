//
//  NetworkManager.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 23/04/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

class KioskNetworkManager {
    
 // static let serverUrl = "https://www.hdccontacts.com" //PROD
    static let serverUrl = "https://test.hdccontacts.com" // DEV
    static let devUrl = ""
    static let liveUrl = serverUrl + "/api/v1/"
    static let baseURL = liveUrl
    
    static let shared = KioskNetworkManager()
    
    private var disposeBag = DisposeBag()
    
    func registerDevice(success : @escaping (Bool) -> Void) {
        
        let stringURL = KioskNetworkManager.liveUrl + "device"
        
        let manager = SessionManager.default
        
        let deviceInfo = DeviceInformation.mr_findFirst()!
        var deviceInfoDict = deviceInfo.getDictionary()
        deviceInfoDict["deviceID"] = DeviceUniqueIDManager.shared.uniqueID
        deviceInfoDict["tokenID"] = UserDefaults.standard.string(forKey: "Push_Token") ?? "FakeTokenAsOriginalIsAbsent"
        
        let currentCoords = LocationService.shared.getCurrentCoordinates()
        deviceInfoDict["latitude"] = currentCoords?.latitude
        deviceInfoDict["longitude"] = currentCoords?.longitude
        
        manager.rx.request(.post, stringURL, parameters: deviceInfoDict, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["application/json"])
            .json()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                print("Response -> \(response)")
            }, onError: { error in
                print("Error -> \(error)")
                success(false)
            }, onCompleted: {
                success(true)
            }).disposed(by: disposeBag)
        
    }
    
    func postEntries (_ arrayOfEntryDicts : [[String : Any]],
                      completion : @escaping (Bool, Error?)->Void) {
        
        if arrayOfEntryDicts.count > 0 {
            
            let stringURL = KioskNetworkManager.liveUrl + "entry"
            
            let manager = SessionManager.default
            do {
                var request = try urlRequest(.post, stringURL)
                request.setValue("application/json", forHTTPHeaderField: "content-type")
                request.httpBody = try JSONSerialization.data(withJSONObject: arrayOfEntryDicts, options: .sortedKeys)
                
                manager.rx.request(urlRequest: request)
                    .validate(statusCode: 200 ..< 300)
                    .validate(contentType: ["application/json"])
                    .json()
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { response in
                        print("Response -> \(response)")
                    }, onError: { networkError in
                        completion(false, networkError)
                    }, onCompleted: {
                        completion(true, nil)
                    }).disposed(by: disposeBag)
                
            } catch {
                completion(false, error)
            }
        } else {
            completion(true, nil)
        }
    }
    
    func getScreenSaverInfo (forDeviceId deviceId : String,
                             completion : @escaping ([String : Any]?, Error?)->Void) {
        
        let stringURL = KioskNetworkManager.liveUrl + "device/\(deviceId)/"
        let manager = SessionManager.default
        
        let screensaverRequest = manager.rx.request(.get, stringURL)
        
        screensaverRequest
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["application/json"])
            .json()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                print(response)
                
                if let deviceGroupAndScreenSaverInfo = response as? [String : Any] {
                    completion(deviceGroupAndScreenSaverInfo, nil)
                } else {
                    //there was some problem
                    completion(nil, NSError(domain: "SomeDomain", code: 1000, userInfo: nil))
                }
                
            }, onError: { error in
                print(error)
                completion(nil, error)
            }, onCompleted: {
                
            }).disposed(by: disposeBag)
        
    }
    
    func downloadScreensaver(for id : String, strUrl : String, completion : @escaping (String, String?, Error?) -> Void) {
        
        let otherdestination = DownloadRequest.suggestedDownloadDestination()
        
        Alamofire.download(strUrl, to: otherdestination).responseData { response in
            if let destinationUrl = response.destinationURL {
                completion(id, destinationUrl.lastPathComponent, nil)
            }
        }
    }
    
    func downloadContestRules(for id : String, strUrl : String, completion : @escaping (String, String?, Error?) -> Void) {
        
        let otherdestination = DownloadRequest.suggestedDownloadDestination()
        
        Alamofire.download(strUrl, to: otherdestination).responseData { response in
            if let destinationUrl = response.destinationURL {
                completion(id, destinationUrl.lastPathComponent, nil)
            }
        }
    }
    
    func getWinner(from startDate: Date, to endDate: Date, totalWinner count: Int, completion : @escaping ([[String:Any]]?) -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let strStartDate = dateFormatter.string(from: startDate)
        let strEndDate = dateFormatter.string(from: endDate)
        
        let parameters = ["StartDate":strStartDate,
                          "EndDate":strEndDate,
                          "deviceID":DeviceUniqueIDManager.shared.uniqueID,
                          "count": count] as [String : Any]
        
        let stringURL = KioskNetworkManager.liveUrl + "entry/winner"
        let manager = SessionManager.default
        
        manager.rx.request(.post, stringURL, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["application/json"])
            .json()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                print(response)
                
                let winners = response as! [[String : Any]]
                completion(winners)
            }, onError: { error in
                print(error)
                completion(nil)
            }, onCompleted: {
                
            }).disposed(by: disposeBag)
    }
    
    func redrawWinner(id winnerId: Int,from startDate: Date, to endDate: Date, totalWinner count: Int, completion : @escaping (Bool, [String : Any]?) -> Void) {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let strStartDate = dateFormatter.string(from: startDate)
        let strEndDate = dateFormatter.string(from: endDate)
        
        let parameters = ["StartDate":strStartDate,
                          "EndDate":strEndDate,
                          "deviceID":DeviceUniqueIDManager.shared.uniqueID,
                          "count": count] as [String : Any]
        
        var stringURL = KioskNetworkManager.liveUrl + "winner"
        let manager = SessionManager.default
        stringURL = stringURL + "/\(winnerId)" + "/replace"
        
        manager.rx.request(.post, stringURL, parameters: parameters, encoding: URLEncoding.default)

            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["application/json"])
            .json()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                print(response)
                let response = response as! [String : Any]
                completion(true, response)
            }, onError: { error in
                if error is AFError  {
                    completion(false, nil)
                    
                } else {
                    completion(false, nil)
                    
                }
                print(error)
            }, onCompleted: {
                
            }).disposed(by: disposeBag)

    }
    
    
    func contactWinner(id: Int, completion : @escaping (Bool) -> Void) {
        
        let parameters = [id]
        
        let stringURL = KioskNetworkManager.liveUrl + "winner/notify"
        let manager = SessionManager.default

        do {
            var request = try urlRequest(.post, stringURL)
            request.setValue("application/json", forHTTPHeaderField: "content-type")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .sortedKeys)

            manager.rx.request(urlRequest: request)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .json()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (response) in
                    print(response)
                }, onError: { (error) in
                    print(error)
                    completion(false)
                }, onCompleted: {
                    completion(true)
                }).disposed(by: disposeBag)

        } catch {
            completion(false)
        }
 
    }
    
    func sendResults(ids:[Int]?, email: String?, completion : @escaping (Bool) -> Void) {
        
        guard let email = email, let ids = ids else {
            return
        }
        
        let parameters = ["winners": ids,"email": email] as [String: Any]
        
        let stringURL = KioskNetworkManager.liveUrl + "winner/notifyFSR"
        let manager = SessionManager.default
        
        manager.rx.request(.post, stringURL, parameters: parameters, encoding: URLEncoding.default)
            
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["application/json"])
            .json()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                print(response)
                completion(true)
            }, onError: { error in
                print(error)
                completion(false)
            }, onCompleted: {
                
            }).disposed(by: disposeBag)
    }
    
    
    // MARK:- Questionnaire
    
    func getQuestions(for surveyId: Int, completion : @escaping ([String: Any]?) -> Void) {
        
        let stringURL = KioskNetworkManager.liveUrl + "survey/\(surveyId)"
        let manager = SessionManager.default
        
        manager.rx.request(.get, stringURL, parameters: nil, encoding: URLEncoding.default)
            
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["application/json"])
            .json()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                
                let response = response as! [String: Any]
                print(response)
                completion(response)
                
            }, onError: { error in
                if error is AFError  {
                    completion(nil)
                    
                } else {
                    completion(nil)
                }
                print(error)
            }, onCompleted: {
                
            }).disposed(by: disposeBag)
        
    }
    
}


