//
//  BLEManager.swift
//  MenuLight
//
//  Created by Dan Diemer on 7/30/24.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
  var centralManager: CBCentralManager!
  var peripheral: CBPeripheral?
  var ledCharacteristic: CBCharacteristic?
  
  override init() {
    print("-ble init")
    super.init()
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }
  
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    print("-ble updated state")
    switch central.state {
    case .unknown:
      print("Bluetooth state is unknown")
    case .resetting:
      print("Bluetooth is resetting")
    case .unsupported:
      print("Bluetooth is not supported on this device")
    case .unauthorized:
      print("Bluetooth is not authorized")
    case .poweredOff:
      print("Bluetooth is powered off")
    case .poweredOn:
      print("Bluetooth is powered on")
      centralManager.scanForPeripherals(withServices: [], options: nil)
    @unknown default:
      print("A previously unknown central manager state occurred")
    }
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
    
    if let name = peripheral.name, name.contains("ELK-BLEDOM") {
      //          "ELK-BLEDOM " {
      print(peripheral)
      self.peripheral = peripheral
      self.peripheral?.delegate = self
      centralManager.stopScan()
      centralManager.connect(peripheral, options: nil)
    }
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("-discovering")
    peripheral.discoverServices([CBUUID(string: "FFF0")])
  }
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    print("-discovered services")
    if let service = peripheral.services?.first {
      peripheral.discoverCharacteristics([CBUUID(string: "FFF3")], for: service)
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    if let characteristic = service.characteristics?.first {
      ledCharacteristic = characteristic
      turnOn()
    }
  }
  
  func turnOn() {
    guard let peripheral = peripheral, let ledCharacteristic = ledCharacteristic else { return }
    // turn on: 7e0404f00000ff00ef
    let data = Data(hex:"7e0404f00000ff00ef")
    print("turning on")
    print(data)
    peripheral.writeValue(data, for: ledCharacteristic, type: .withoutResponse)
  }
  
  func turnOff() {
    guard let peripheral = peripheral, let ledCharacteristic = ledCharacteristic else { return }
    // turn off: 7e0404000001ff00ef
    let data = Data(hex:"7e0404000001ff00ef")
    print("turning on")
    print(data)
    peripheral.writeValue(data, for: ledCharacteristic, type: .withoutResponse)
  }
  
  func setBrightness(_ brightness: Int) {
    guard let peripheral = peripheral, let ledCharacteristic = ledCharacteristic else { return }
    let hexValue = String(format:"%02X", brightness)
    let data = Data(hex:"7e0001\(hexValue)00000000ef")
    peripheral.writeValue(data, for: ledCharacteristic, type: .withoutResponse)
  }
  
  func setColor(_ color: String) {
    guard let peripheral = peripheral, let ledCharacteristic = ledCharacteristic else { return }
    let data = Data(hex: color)
    print(color)
    print(data)
    peripheral.writeValue(data, for: ledCharacteristic, type: .withoutResponse)
    peripheral.readValue(for: ledCharacteristic)
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
    print(characteristic.value?.hexDescription)
  }
}
