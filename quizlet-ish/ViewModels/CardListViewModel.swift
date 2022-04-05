//
//  CardListViewModel.swift
//  quizlet-ish
//
//  Created by Jordan Yee on 4/4/22.
//

import Foundation
import Combine

class CardListViewModel: ObservableObject {
  // 1
  @Published var cardViewModels: [CardViewModel] = []
  // 2
  private var cancellables: Set<AnyCancellable> = []

  // 3
  @Published var cardRepository = CardRepository()

  init() {
    // 1
    cardRepository.$cards.map { cards in
      cards.map(CardViewModel.init)
    }
    // 2
    .assign(to: \.cardViewModels, on: self)
    // 3
    .store(in: &cancellables)
  }

  // 4
  func add(_ card: Card) {
    cardRepository.add(card)
  }
}
