//
//  ExperienceView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 16.03.2022.
//

import SwiftUI

struct ExperienceView: View {
    
    let experience: Int
    
    var level: Int {
        LevelManager.currentLevel(experience: experience)
    }
    
    var nextLevelExperience: Int {
        LevelManager.nextLevelExperience(experience: experience)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(Strings.level + " " + level.string + ":")
                    .font(.system(.headline, design: .rounded))
                Spacer()
                Text(experience.string + "/" + nextLevelExperience.string)
            }
            ProgressBar(progress: CGFloat(experience) / CGFloat(nextLevelExperience))
                .frame(height: 6)
        }
    }
}

struct ExperienceView_Previews: PreviewProvider {
    static var previews: some View {
        ExperienceView(experience: 22)
            .previewLayout(.sizeThatFits)
    }
}
