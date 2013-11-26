class GameAI

  attr_accessor :current_game, :available_moves, :winning_move

  attr_reader :current_turn

  def initialize(game)
    self.current_game = game
    @available_moves = game.open_spaces
    @current_turn = game.current_player_turn
    @winning_move = nil
  end

  # all of the moves in one method so all we have to do is call the same method
  def move
    return win_lose if win_lose
    
    if current_game.turns == 1
      ai_first_move
    elsif current_game.turns == 3
      ai_second_move
    elsif current_game.turns == 5
      ai_third_move
    else
      ai_other_moves
    end

  end

  # private

  # Analysis of the firt move, which effects AI first move
  def first_move_center?
    game_board[4] == 1
  end

  # The first move always is a simple question, center or not?
  def ai_first_move
    first_move_center? ? 0 : 4
  end

  # after checking for an opponents three in a row (and to stop it, in the move method), looks for if other player has 'stacked', if not, it goes on the offensive (look_three)
  def ai_second_move
    if stacked?
      open_corners.first
    else
      look_three
    end
  end

  # checks if the human has 2 non-corner / center placements. If not, it goes on the offensive. If not possible, it does a random placement
  def ai_third_move
    if look_non_corner
      open_corners.last
    elsif look_three
      look_three
    else
      random
    end
  end

  # after 3 turns the computer's space selection
  def ai_other_moves
    if look_three
      look_three
    else
      random
    end
  end

  ##############################
  
  # checks for placing a winner
  def win
    current_game.check_two(2, 0)
  end

  # checks if human has two in a row
  def prevent_lose
    current_game.check_two(1, 0)
  end

  # checks for the win or preventing a lose
  def win_lose
    return win if win
    return prevent_lose if prevent_lose
  end

  # Checks the opposite corenr of the computer space and the center space - dangerous on the second move
  def stacked?
    if game_board[4] == 1
      game_board[0] == 1 && game_board[8] == 2 || 
      game_board[2] == 1 && game_board[6] == 2 ||
      game_board[6] == 1 && game_board[2] == 2 ||
      game_board[8] == 1 && game_board[0] == 2
    end
  end

  # returns all corners that are open
  def open_corners
    [0, 2, 6, 8].select {|space| game_board[space] == 0 }
  end

  # looks three spaces in a row that does not have a human blocking it (can have the computer already in the row or not)
  def look_three
    current_game.check_two(0, 2)
  end

  # checks if the human has 2 non-corner / center spaces occupied (spaces 1, 3, 5, 7)
  def look_non_corner
    current_game.two_middle(1)
  end

  # shows the game's board
  def game_board
    current_game.board
  end

  # returns a random available move
  def random
    available_moves.sample.to_i
  end


  ## didn't use this, but was designed to check if the human selected two corners with only 2 moves
  # def opposite_corners
  #   game_board[0] == game_board[8] && game_board[0] == 1 || game_board[2] == game_board[6] && game_board[2] == 1
  # end
end