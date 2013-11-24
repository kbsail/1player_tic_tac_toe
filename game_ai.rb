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
    if win_lose
      win_lose
    else
      open_corner
    end
  end

  def open_corner
    [0, 2, 6, 8].find {|space| game_board[space] == 0 }
  end

  def oposite_corners
    if game_board[0] == game_board[8] || game_board[2] == game_board[6]
      open_corner
    end
  end

  def win_lose
    if current_game.check_two(2)
      current_game.check_two(2)
    elsif current_game.check_two(1)
      current_game.check_two(1)
    end
  end

  def ai_other_moves
    if win_lose
      win_lose
    elsif open_corner
      open_corner
    else
      available_moves.first.to_i
    end
  end

  def move
    if current_game.turns == 1
      ai_first_move
    elsif current_game.turns == 3
      ai_second_move
    else
      ai_other_moves
    end
  end


end