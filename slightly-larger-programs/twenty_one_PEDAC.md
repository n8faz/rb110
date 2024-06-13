Pseudo Code

1. Initialize deck
2. Deal cards to player and dealer
3. Player turn: hit or stay
   - repeat until bust or "stay"
4. If player bust, dealer wins.
5. Dealer turn: hit or stay
   - repeat until total >= 17
6. If dealer bust, player wins.
7. Compare cards and declare winner.

1. Initialize deck
   - hash
     - Key: Suits 
     - Value: Card (Array)

2. deal card
   - return array
     - Suit and card
10. Player Turn: Hit or stay

Bonus Feature Ideas:

- symbols for suits
- ascii cards
- display hard and soft values when player has ace 
  - eg. 7 (or 17)
- change values
  - 21 -> 31
  - dealer stays value
  - make constants
- Add rounds
  - first to x amount of points is winner
- include rules and a proper intro
  - personalize game
- 