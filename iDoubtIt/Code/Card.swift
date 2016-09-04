/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SpriteKit

enum CardType :NSString {
  case Hearts,
  Spades,
  Clubs,
  Diamonds,
  NOSUIT

  static let allValues = [Hearts,
                          Spades,
                          Clubs,
                          Diamonds,
                          NOSUIT]
}

enum Value :NSString {
    case Ace,
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven,
    Eight,
    Nine,
    Ten,
    Jack,
    Queen,
    King,
    Joker
    
    static let allValues = [Ace,
                            Two,
                            Three,
                            Four,
                            Five,
                            Six,
                            Seven,
                            Eight,
                            Nine,
                            Ten,
                            Jack,
                            Queen,
                            King,
                            Joker]
}

enum cardBack :String {
    case cardBack_blue1,
    cardBack_blue2,
    cardBack_blue3,
    cardBack_blue4,
    cardBack_blue5,
    cardBack_green1,
    cardBack_green2,
    cardBack_green3,
    cardBack_green4,
    cardBack_green5,
    cardBack_red1,
    cardBack_red2,
    cardBack_red3,
    cardBack_red4,
    cardBack_red5
    
    static let allValues = [cardBack_blue1,
                            cardBack_blue2,
                            cardBack_blue3,
                            cardBack_blue4,
                            cardBack_blue5,
                            cardBack_green1,
                            cardBack_green2,
                            cardBack_green3,
                            cardBack_green4,
                            cardBack_green5,
                            cardBack_red1,
                            cardBack_red2,
                            cardBack_red3,
                            cardBack_red4,
                            cardBack_red5]
}

class Card : SKSpriteNode {
  let cardType :CardType
  let frontTexture :SKTexture
  let backTexture :SKTexture
  let value :Value
    
  var cardName :String
  var faceUp = true
  var enlarged = false
  var savedPosition = CGPoint.zero
  
  let largeTextureFilename :String
  var largeTexture :SKTexture?
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoding not supported")
  }
  
    init(cardType: CardType, value: Value) {
    self.cardType = cardType
    self.value = value
    backTexture = SKTexture(imageNamed: cardCover)
    
    if (value != .Joker || cardType != .NOSUIT) {
        cardName = String(format: "%@of%@", value.rawValue, cardType.rawValue)
    }
    else {
        cardName = String(format: "Joker")
    }

    frontTexture = SKTexture(imageNamed: cardName)
    largeTextureFilename = cardName

    super.init(texture: frontTexture, color: .clearColor(), size: frontTexture.size())
  }
  
  func flip() {
    let firstHalfFlip = SKAction.scaleXTo(0.0, duration: 0.4)
    let secondHalfFlip = SKAction.scaleXTo(1.0, duration: 0.4)
    
    setScale(1.0)
    
    if faceUp {
      runAction(firstHalfFlip) {
        self.texture = self.backTexture
        
        self.runAction(secondHalfFlip)
      }
    } else {
      runAction(firstHalfFlip) {
        self.texture = self.frontTexture
        
        self.runAction(secondHalfFlip)
      }
    }
    faceUp = !faceUp
  }
  
  func enlarge() {
    if enlarged {
      let slide = SKAction.moveTo(savedPosition, duration:0.3)
      let scaleDown = SKAction.scaleTo(1.0, duration:0.3)
      runAction(SKAction.group([slide, scaleDown])) {
        self.enlarged = false
        self.zPosition = CardLevel.board.rawValue
      }
    } else {
      enlarged = true
      savedPosition = position
      
      if largeTexture != nil {
        texture = largeTexture
      } else {
        largeTexture = SKTexture(imageNamed: largeTextureFilename)
        texture = largeTexture
      }
      
      zPosition = CardLevel.enlarged.rawValue
      
      if let parent = parent {
        removeAllActions()
        zRotation = 0
        let newPosition = CGPoint(x: parent.frame.midX, y: parent.frame.midY)
        let slide = SKAction.moveTo(newPosition, duration:0.3)
        let scaleUp = SKAction.scaleTo(5.0, duration:0.3)
        runAction(SKAction.group([slide, scaleUp]))
      }
    }
  }
    
    func getIcon() -> String {
        switch (value, cardType) {
        case (.Joker, .NOSUIT): return "🃏"
        case (.Joker, .Hearts): return "🃏♥️"
        case (.Joker, .Spades): return "🃏♠️"
        case (.Joker, .Clubs): return "🃏♣️"
        case (.Joker, .Diamonds): return "🃏♦️"
            
        case (.Ace, .Hearts): return "🂱♥️"
        case (.Two, .Hearts): return "🂲♥️"
        case (.Three, .Hearts): return "🂳♥️"
        case (.Four, .Hearts): return "🂴♥️"
        case (.Five, .Hearts): return "🂵♥️"
        case (.Six, .Hearts): return "🂶♥️"
        case (.Seven, .Hearts): return "🂷♥️"
        case (.Eight, .Hearts): return "🂸♥️"
        case (.Nine, .Hearts): return "🂹♥️"
        case (.Ten, .Hearts): return "🂺♥️"
        case (.Jack, .Hearts): return "🂻♥️"
        case (.Queen, .Hearts): return "🂽♥️"
        case (.King, .Hearts): return "🂾♥️"
            
        case (.Ace, .Spades): return "🂡♠️"
        case (.Two, .Spades): return "🂢♠️"
        case (.Three, .Spades): return "🂣♠️"
        case (.Four, .Spades): return "🂤♠️"
        case (.Five, .Spades): return "🂥♠️"
        case (.Six, .Spades): return "🂦♠️"
        case (.Seven, .Spades): return "🂧♠️"
        case (.Eight, .Spades): return "🂨♠️"
        case (.Nine, .Spades): return "🂩♠️"
        case (.Ten, .Spades): return "🂪♠️"
        case (.Jack, .Spades): return "🂫♠️"
        case (.Queen, .Spades): return "🂭♠️"
        case (.King, .Spades): return "🂮♠️"
            
        case (.Ace, .Clubs): return "🃑♣️"
        case (.Two, .Clubs): return "🃒♣️"
        case (.Three, .Clubs): return "🃓♣️"
        case (.Four, .Clubs): return "🃔♣️"
        case (.Five, .Clubs): return "🃕♣️"
        case (.Six, .Clubs): return "🃖♣️"
        case (.Seven, .Clubs): return "🃗♣️"
        case (.Eight, .Clubs): return "🃘♣️"
        case (.Nine, .Clubs): return "🃙♣️"
        case (.Ten, .Clubs): return "🃚♣️"
        case (.Jack, .Clubs): return "🃜♣️"
        case (.Queen, .Clubs): return "🃝♣️"
        case (.King, .Clubs): return "🃞♣️"
            
        case (.Ace, .Diamonds): return "🃁♦️"
        case (.Two, .Diamonds): return "🃂♦️"
        case (.Three, .Diamonds): return "🃃♦️"
        case (.Four, .Diamonds): return "🃄♦️"
        case (.Five, .Diamonds): return "🃅♦️"
        case (.Six, .Diamonds): return "🃆♦️"
        case (.Seven, .Diamonds): return "🃇♦️"
        case (.Eight, .Diamonds): return "🃈♦️"
        case (.Nine, .Diamonds): return "🃉♦️"
        case (.Ten, .Diamonds): return "🃊♦️"
        case (.Jack, .Diamonds): return "🃋♦️"
        case (.Queen, .Diamonds): return "🃍♦️"
        case (.King, .Diamonds): return "🃎♦️"
            
        default: return "❗️"
        }
    }
}
