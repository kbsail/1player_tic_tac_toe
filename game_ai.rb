class GameAI

  attr_accessor :current_game, :available_moves, :winning_move, :game_board

  attr_reader :current_turn

  def initialize(game)
    self.current_game = game
    self.game_board = game.board
    @available_moves = game.open_spaces
    @current_turn = game.current_player_turn
    @winning_move = nil
  end

  def first_move_center?
    game_board[4] == 1
  end

  def ai_first_move
    first_move_center? ? 0 : 4
  end

  def ai_second_move
    if first_move_center?
      check_two(1)
    else
      available_moves.first
    end

  end


  def move
    if current_game.turns == 1
      ai_first_move
    else
      [0, 2, 6, 8].find {|space| game_board[space] == 0 }
    end
  end


end