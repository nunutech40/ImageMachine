//
//  RealmManager.swift
//  ImageMachine
//
//  Created by mac on 15/1/22.
//

import Foundation
import RealmSwift
import RxSwift

protocol MachineDataLocaleProtocol: class {
    func saveMachineData(from machineData: MachinDataEntity) -> Observable<Bool>
    func deleteMachineData(id: String) -> Observable<Bool>
    func getListMachineData() -> Observable<[MachinDataEntity]>
    func getMachineDataById(id: String) -> Observable<[MachinDataEntity]>
    func getMachineDataByQrCode(qrcode: String) -> Observable<[MachinDataEntity]>
}



final class MachineDataLocalDataSource: NSObject {
    
    private let realm: Realm?
    private init(realm: Realm?) {
        self.realm = realm
    }
    
    static let sharedInstance: (Realm?) -> MachineDataLocalDataSource = { realmDb in
        return MachineDataLocalDataSource(realm: realmDb)
    }
    
}

extension MachineDataLocalDataSource: MachineDataLocaleProtocol {
    
    func saveMachineData(from machineData: MachinDataEntity) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            if let realm = self.realm {
                do {
                    try realm.write {
                        realm.add(machineData, update: .all)
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                } catch {
                    observer.onError(DatabaseError.requestFailed)
                }
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            
            return Disposables.create()
        }
    }
    
    func deleteMachineData(id: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            
            if let realm = self.realm {
                do {
                    try realm.write {
                        let machineData: Results<MachinDataEntity> = {
                          realm.objects(MachinDataEntity.self)
                                .filter("id == \(id)")
                        }()
                        realm.delete(machineData)
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                } catch {
                    observer.onError(DatabaseError.requestFailed)
                }
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            
            return Disposables.create()
        }
    }
    
    func getListMachineData() -> Observable<[MachinDataEntity]> {
        
        return Observable<[MachinDataEntity]>.create { observer in
            if let realm = self.realm {
                let machineData: Results<MachinDataEntity> = {
                    realm.objects(MachinDataEntity.self)
                        .sorted(byKeyPath: "id", ascending: true)
                }()
                observer.onNext(machineData.toArray(ofType: MachinDataEntity.self))
                observer.onCompleted()
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
        
    }
    
    func getMachineDataById(id: String) -> Observable<[MachinDataEntity]> {
        
        return Observable<[MachinDataEntity]>.create { observer in
            if let realm = self.realm {
              let machineData: Results<MachinDataEntity> = {
                realm.objects(MachinDataEntity.self)
                      .filter("id == \(id)")
              }()
                observer.onNext(machineData.toArray(ofType: MachinDataEntity.self))
                observer.onCompleted()
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    
    func getMachineDataByQrCode(qrcode: String) -> Observable<[MachinDataEntity]> {
        
        return Observable<[MachinDataEntity]>.create { observer in
            if let realm = self.realm {
              let machineData: Results<MachinDataEntity> = {
                realm.objects(MachinDataEntity.self)
                      .filter("qrCode == '\(qrcode)'")
              }()
                observer.onNext(machineData.toArray(ofType: MachinDataEntity.self))
                observer.onCompleted()
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    
    
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
      var array = [T]()
      for index in 0 ..< count {
        if let result = self[index] as? T {
          array.append(result)
        }
      }
      return array
    }
}
