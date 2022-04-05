//
//  CardRepository.swift
//  quizlet-ish
//
//  Created by Jordan Yee on 4/4/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class CardRepository: ObservableObject {
  // 3
  private let path: String = "cards"
  private let store = Firestore.firestore()

  // 1
  @Published var cards: [Card] = []

  // 1
  var userId = ""
  // 2
  private let authenticationService = AuthenticationService()
  // 3
  private var cancellables: Set<AnyCancellable> = []

  init() {
    // 1
    authenticationService.$user
      .compactMap { user in
        user?.uid
      }
      .assign(to: \.userId, on: self)
      .store(in: &cancellables)

    // 2
    authenticationService.$user
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        // 3
        self?.get()
      }
      .store(in: &cancellables)
  }

  func get() {
    // 3
    store.collection(path)
      .whereField("userId", isEqualTo: userId)
      .addSnapshotListener { querySnapshot, error in
        // 4
        if let error = error {
          print("Error getting cards: \(error.localizedDescription)")
          return
        }

        // 5
        self.cards = querySnapshot?.documents.compactMap { document in
          // 6
          try? document.data(as: Card.self)
        } ?? []
      }
  }

  // 4
  func add(_ card: Card) {
    do {
      var newCard = card
      newCard.userId = userId
      _ = try store.collection(path).addDocument(from: newCard)
    } catch {
      fatalError("Unable to add card: \(error.localizedDescription).")
    }
  }

  func update(_ card: Card) {
    // 1
    guard let cardId = card.id else { return }

    // 2
    do {
      // 3
      try store.collection(path).document(cardId).setData(from: card)
    } catch {
      fatalError("Unable to update card: \(error.localizedDescription).")
    }
  }

  func remove(_ card: Card) {
    // 1
    guard let cardId = card.id else { return }

    // 2
    store.collection(path).document(cardId).delete { error in
      if let error = error {
        print("Unable to remove card: \(error.localizedDescription)")
      }
    }
  }
}
