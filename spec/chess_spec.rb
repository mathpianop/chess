require './chess'

# Disyere is my sample game
game = Game.new
      @white_king = King.new("white")
      @white_king.instance_variable_set(:@position, [6,0])
            white_pieces = [Piece.new([4,6], "white", "rook"),
                              Piece.new([3,0], "white", "rook"), 
                              Piece.new([0,2], "white", "bishop"), 
                              Piece.new([3,2], "white", "bishop"),
                              Piece.new([0,3], "white", "queen"), 
                              @white_king,
                              Pawn.new([0,1], "white"),
                              Pawn.new([5,5], "white"),
                              Pawn.new([2,2], "white"),
                              Pawn.new([5,1], "white"),
                              Pawn.new([6,1], "white"),
                              Pawn.new([7,1], "white")]
  
  
              red_pieces = [Piece.new([1,7], "red", "rook"), 
                              Piece.new([6,7], "red", "rook"),
                              Piece.new([2,5], "red", "knight"), 
                              Piece.new([1,5], "red", "bishop"), 
                              Piece.new([1,6], "red", "bishop"),
                              Piece.new([5,2], "red", "queen"), 
                              @red_king = King.new("red"),
                              Pawn.new([0,6], "red"),
                              Pawn.new([2,6], "red"),
                              Pawn.new([3,6], "red"),
                              Pawn.new([5,6], "red"),
                              Pawn.new([7,6], "red")]
  
  
      Piece.class_variable_set(:@@white_pieces, white_pieces)
      Piece.class_variable_set(:@@red_pieces, red_pieces)
      Piece.class_variable_set(:@@pieces, red_pieces + white_pieces)


describe Move do
  describe "#path_clear?" do
    it "returns true for all one-space moves" do
      piece = Piece.pieces.select { |piece| piece.position == [4,6]}[0]
      move1 = Move.new(piece,[4,7])
      expect(move1.path_clear?).to eql(true)
    end

    it "returns true for pawn-first-move if next space is open" do
      piece = Piece.pieces.select { |piece| piece.position == [7,1]}[0]
      move1 = Move.new(piece,[7,3])
      expect(move1.path_clear?).to eql(true)
    end

    it "returns false for pawn-first-move if middle space is blocked" do
      piece = Piece.pieces.select { |piece| piece.position == [5,1]}[0]
      move2 = Move.new(piece,[5,3])
      expect(move2.path_clear?).to eql(false)
    end

    it "returns true for rook clear vertical downward move" do
      piece = Piece.pieces.select { |piece| piece.position == [6,7]}[0]
      move1 = Move.new(piece,[6,1])
      expect(move1.path_clear?).to eql(true)
    end

    it "returns false for rook blocked vertical downward move" do
      piece = Piece.pieces.select { |piece| piece.position == [6,7]}[0]
      move1 = Move.new(piece,[6,0])
      expect(move1.path_clear?).to eql(false)
    end

    it "returns true for rook clear horizontal left move" do
      piece = Piece.pieces.select { |piece| piece.position == [6,7]}[0]
      move1 = Move.new(piece,[7,7])
      expect(move1.path_clear?).to eql(true)
    end

    it "returns false for rook blocked horizontal left move" do
      piece = Piece.pieces.select { |piece| piece.position == [6,7]}[0]
      move1 = Move.new(piece,[2,7])
      expect(move1.path_clear?).to eql(false)
    end

    it "returns true for bishop clear right-up" do
      piece = Piece.pieces.select { |piece| piece.position == [0,2]}[0]
      move1 = Move.new(piece,[3,5])
      expect(move1.path_clear?).to eql(true)
    end

    it "returns false for bishop blocked right-up" do
      piece = Piece.pieces.select { |piece| piece.position == [0,2]}[0]
      move1 = Move.new(piece,[5,7])
      expect(move1.path_clear?).to eql(false)
    end

    it "returns true for bishop clear left-down" do
      piece = Piece.pieces.select { |piece| piece.position == [1,6]}[0]
      move1 = Move.new(piece,[0,5])
      expect(move1.path_clear?).to eql(true)
    end

    it "returns false for bishop blocked right-down" do
      piece = Piece.pieces.select { |piece| piece.position == [1,6]}[0]
      move1 = Move.new(piece,[3,4])
      expect(move1.path_clear?).to eql(false)
    end

    it "returns true for queen clear vertical up" do
      piece = Piece.pieces.select { |piece| piece.position == [5,2]}[0]
      move1 = Move.new(piece,[5,5])
      expect(move1.path_clear?).to eql(true)
    end

    it "returns false for queen blocked horizontal left" do
      piece = Piece.pieces.select { |piece| piece.position == [5,2]}[0]
      move1 = Move.new(piece,[2,2])
      expect(move1.path_clear?).to eql(true)
    end

    it "returns true for queen clear right-up" do
      piece = Piece.pieces.select { |piece| piece.position == [5,2]}[0]
      move1 = Move.new(piece,[7,4])
      expect(move1.path_clear?).to eql(true)
    end

    it "returns true for queen blocked right-down" do
      piece = Piece.pieces.select { |piece| piece.position == [5,2]}[0]
      move1 = Move.new(piece,[7,7])
      expect(move1.path_clear?).to eql(true)
    end
  end

  describe "#allowed_for_piece?" do
    it "returns true for rook-shaped move" do
      piece = Piece.pieces.select { |piece| piece.position == [6,7]}[0]
      move1 = Move.new(piece,[6,0])
      expect(move1.allowed_for_piece?).to eql(true)
    end

    it "returns false for non-rook-shaped move" do
      piece = Piece.pieces.select { |piece| piece.position == [6,7]}[0]
      move1 = Move.new(piece,[4,5])
      expect(move1.allowed_for_piece?).to eql(false)
    end

    it "returns true for knight-shaped move" do
      piece = Piece.pieces.select { |piece| piece.position == [2,5]}[0]
      move1 = Move.new(piece,[4,4])
      expect(move1.allowed_for_piece?).to eql(true)
    end

    it "returns true for knight-shaped move (orientation 2)" do
      piece = Piece.pieces.select { |piece| piece.position == [2,5]}[0]
      move1 = Move.new(piece,[3,7])
      expect(move1.allowed_for_piece?).to eql(true)
    end

    it "returns true for knight-shaped move (orientation 3)" do
      piece = Piece.pieces.select { |piece| piece.position == [2,5]}[0]
      move1 = Move.new(piece,[0,6])
      expect(move1.allowed_for_piece?).to eql(true)
    end

    it "returns false for non-knight-shaped move" do
      piece = Piece.pieces.select { |piece| piece.position == [2,5]}[0]
      move1 = Move.new(piece,[3,4])
      expect(move1.allowed_for_piece?).to eql(false)
    end

    it "returns true for bishop-shaped move" do
      piece = Piece.pieces.select { |piece| piece.position == [0,2]}[0]
      move1 = Move.new(piece,[1,3])
      expect(move1.allowed_for_piece?).to eql(true)
    end

    it "returns false for non-bishop-shaped move" do
      piece = Piece.pieces.select { |piece| piece.position == [0,2]}[0]
      move1 = Move.new(piece,[1,2])
      expect(move1.allowed_for_piece?).to eql(false)
    end

    it "returns true for queen-shaped move" do
      piece = Piece.pieces.select { |piece| piece.position == [5,2]}[0]
      move1 = Move.new(piece,[2,5])
      expect(move1.allowed_for_piece?).to eql(true)
    end

    it "returns false for non-queen-shaped move" do
      piece = Piece.pieces.select { |piece| piece.position == [5,2]}[0]
      move1 = Move.new(piece,[2,4])
      expect(move1.allowed_for_piece?).to eql(false)
    end

    it "returns true for king-shaped move" do
      piece = Piece.pieces.select { |piece| piece.position == [6,0]}[0]
      move1 = Move.new(piece,[5,0])
      expect(move1.allowed_for_piece?).to eql(true)
    end

    it "returns false for non-king-shaped move" do
      piece = Piece.pieces.select { |piece| piece.position == [6,0]}[0]
      move1 = Move.new(piece,[4,0])
      expect(move1.allowed_for_piece?).to eql(false)
    end
  end

  describe "#capture?" do
    it "returns true if an enemy piece occupies end square" do
      piece = Piece.pieces.select { |piece| piece.position == [4,6]}[0]
      move1 = Move.new(piece,[4,7])
      expect(move1.capture?).to eql(true)
    end

    it "works for red pieces too" do
      piece = Piece.pieces.select { |piece| piece.position == [6,7]}[0]
      move1 = Move.new(piece,[6,1])
      expect(move1.capture?).to eql(true)
    end

    it "returns false if it's moving to an unoccupied square" do
      piece = Piece.pieces.select { |piece| piece.position == [4,6]}[0]
      move1 = Move.new(piece,[4,5])
      expect(move1.capture?).to eql(false)
    end
  end
end

describe King do
  describe "#check?" do
    it "returns true if a piece threatens the king" do
      red_king = game.instance_variable_get(:@red_king)
      expect(red_king.check?).to eql(true)
    end

    it "returns false if no piece is threatening the king" do
      white_king = game.instance_variable_get(:@white_king)
      expect(white_king.check?).to eql(false)
    end
  end
end