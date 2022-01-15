//
//  MachineDataMapper.swift
//  ImageMachine
//
//  Created by mac on 16/1/22.
//

final class MachineDataMapper {
    
    static func mapMachineEntityToModel(input mapEntities: [MachinDataEntity]) -> [MachineDataModel] {
        
        return mapEntities.map { result in
            return MachineDataModel(
                machineId: result.id,
                machineName: result.name,
                machineType: result.type,
                machineQRCode: result.qrCode,
                createAt: result.createAt,
                updateAt: result.updateAt)
        }
        
    }
    
    static func mapMachineDataModelToEntity(input machineData: MachineDataModel) -> MachinDataEntity {
        let newMachineData = MachinDataEntity()
        newMachineData.id = machineData.machineId!
        newMachineData.name = machineData.machineName!
        newMachineData.type = machineData.machineType!
        newMachineData.qrCode = machineData.machineQRCode ?? ""
        newMachineData.createAt = machineData.createAt ?? ""
        newMachineData.updateAt = machineData.updateAt ?? ""
        return newMachineData
    }
    
}
