//
//  PairingFlow.swift
//  Pero
//
//  Created by Junsung Park on 2020/10/29.
//  Copyright © 2020 Junsung Park. All rights reserved.
//

import Cocoa
import CoreBluetooth
import RxSwift
//import RxBluetoothKit

enum PairingStep {
    case none
    case waitingForBluetooth
    case scanning
    case peripheralDiscovered(peripheral: String)
    case connecting
    case connected
    case receivingInitialData
    case paired
}
enum Services: ServiceIdentifier {
    case battery
    
    var uuid: CBUUID { return CBUUID(string: "180F") }
}
 
enum Characteristics: CharacteristicIdentifier {
    case batteryLevel
    
    var uuid: CBUUID { return CBUUID(string: "2A19") }
    var service: ServiceIdentifier { return Services.battery }
}
extension Observable {
    func timeoutIfNoEvent(_ dueTime: RxTimeInterval) -> Observable<Element> {
        let timeout = Observable
            .never()
            .timeout(dueTime, scheduler: MainScheduler.instance)
        
        return self.amb(timeout)
    }
}
class PairingFlow: NSObject {
    
    let expectedNamePrefix = "GoPro" // TODO: replace with value specific for your BLE device
    let timeout = 30.0
    
    // 1.
    let manager = CentralManager(queue: .main)
    
    func pair() -> Observable<PairingStep>  {
        return Observable.create { observer in
            
            let flow = self.waitForBluetooth(observer)
                .flatMap { _ in self.scanForPeripheral(observer) }
                .flatMap { self.connect(to: $0, progress: observer) }
                .flatMap { self.getData(from: $0, progress: observer) }
       
            let subscription = flow
                // 10.
                .do(onNext: {
                    observer.onNext(.paired)
                    observer.onCompleted()
                    print([UInt8]($0.value ?? Data()))
                }, onError: {
                    observer.onError($0)
                })
                .catchError { _ in Observable.never() }
                .subscribe()
            
            return Disposables.create { subscription.dispose() }
        }
    }
    
    // Step 1. Wait for Bluetooth
    private func waitForBluetooth(_ progress: AnyObserver<PairingStep>) -> Observable<BluetoothState> {
        progress.onNext(.waitingForBluetooth)
        return self.manager
            .observeState()
            .startWith(self.manager.state)
            .filter { $0 == .poweredOn }
            // 2.
            .take(1)
    }
    
    // Step 2. Scan
    private func scanForPeripheral(_ progress: AnyObserver<PairingStep>) -> Observable<ScannedPeripheral> {
        progress.onNext(.scanning)
        return self.manager
            // 3.
            .scanForPeripherals(withServices: nil)
            // 4.
            .filter { $0.peripheral.name?.starts(with: self.expectedNamePrefix) ?? false }
            // 5.
            .take(1)
            // 6.
           // .timeoutIfNoEvent(RxTimeInterval(self.timeout))
            // 7.
            .do(onNext: { progress.onNext(.peripheralDiscovered(peripheral: $0.peripheral.name ?? "")) })
    }
    
    // Step 3. Connect
    private func connect(to peripheral: ScannedPeripheral, progress: AnyObserver<PairingStep>) -> Observable<Peripheral> {
        progress.onNext(.connecting)
        return peripheral.peripheral
            .establishConnection()
          //  .timeoutIfNoEvent(self.timeout)//
            .do(onNext: { _ in progress.onNext(.connected) })
    }
    
    // Step 4. Receive initial data
    private func getData(from peripheral: Peripheral, progress: AnyObserver<PairingStep>) -> Observable<Characteristic> {
        progress.onNext(.receivingInitialData)
        
        // 8.
        // some characteristics may return data in chunks, that's why you may need to subscribe for notifications
        let notifications = peripheral.observeValueUpdateAndSetNotification(for: Characteristics.batteryLevel)
        let readValue = peripheral.readValue(for: Characteristics.batteryLevel)
        
        // 9.
        return Observable.concat(readValue.asObservable(), notifications.skip(1))
    }
}


