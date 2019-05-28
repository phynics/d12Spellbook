//
//  FeatDataViewModel.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 3.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import UIKit
import CoreStore

class FeatDataInternalModel: CoreStoreObject {
    
    let featBenefit = Value.Required<String>("benefit", initial: "")
    let featNormal = Value.Required<String>("normal", initial: "")
    let featSpecial = Value.Required<String>("special", initial: "")
    let featGoal = Value.Required<String>("goal", initial: "")
    let featCompletionBenefit = Value.Required<String>("completionBenefit", initial: "")
    let featNote = Value.Required<String>("note", initial: "")
    let featSource = Value.Required<String>("source", initial: "")
    let featName = Value.Required<String>("name", initial: "")
    let featPrerequisites = Value.Required<String>("prerequisites", initial: "")
    let featShortDescription = Value.Required<String>("shortDesc", initial: "")
    let featType = Value.Required<String>("type", initial: "")
    let featAdditionalTypes = Value.Required<String>("additionalTypes", initial: "")
    let featId = Value.Required<Int>("id", initial: -1)
    
    func populate(withModel feat: FeatDataModelJSON) {
        featBenefit.value = feat.benefit
        featNormal.value = feat.normal
        featSpecial.value = feat.special
        featGoal.value = feat.goal
        featCompletionBenefit.value = feat.completionBenefit
        featNote.value = feat.note
        featSource.value = feat.source
        featName.value = feat.name
        featPrerequisites.value = feat.prerequisites
        featShortDescription.value = feat.description
        featType.value = feat.type
        featAdditionalTypes.value = feat.additionalTypes
        featId.value = feat.id
    }
}
