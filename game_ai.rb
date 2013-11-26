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
    elsif analyze_traps
      prevent_entrapment(analyze_traps)
    elsif analyze_another_trap
      prevent_another_trap
    else
      look_three
    end
  end

  # checks if the human has 2 non-corner spaces & center space. If not, it goes on the offensive. If not possible, it does a random placement
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
    stack = [[0, 8], [2, 6]]
    if game_board[4] == 1
      stack.each { |combo| return true if game_board[combo[0]] != 0 && game_board[combo[1]] != 0 }
    end
  end

  # returns all corners that are open
  def open_corners
    [0, 2, 6, 8].select {|space| game_board[space] == 0 }
  end

  # looks for line of one computer space and two open spaces
  def look_three
    current_game.check_two(0, 2)
  end

  # checks if the human has 2 non-corner spaces & center space occupied (spaces 1, 3, 5, 7)
  def look_non_corner
    current_game.two_middle(1) && game_board[4] == 1
  end

  def traps
    [[1, 3], [1, 5], [5, 7], [3, 7]]
  end

  def analyze_traps
    trap_indexes = nil
    traps.each do |trap| 
      trap_indexes = trap if game_board[trap[0]] == 1 && game_board[trap[1]] == 1
    end
    trap_indexes
  end

  # prevents entrapment
  def prevent_entrapment(trap)
    (trap.reduce(:+) - 4)
  end

  # prevents other entrapment
  def analyze_another_trap
    player_positions = player_indexes(1)
    human_has_corner && player_positions[1] - player_positions[0] == 5
  end

  def prevent_another_trap
    return 0 if player_indexes(1).reduce(:+) == 7
    return 2 if player_indexes(1).reduce(:+) == 5
    return 8 if player_indexes(1).reduce(:+) == 9
    return 6 if player_indexes(1).reduce(:+) == 11
  end

  # returns the indexes of a player on the board
  def player_indexes(player)
    game_board.each_index.select { |index| game_board[index] == player}.sort
  end

  def human_has_corner
    [0, 2, 6, 8].map { |space| game_board[space] }.include?(1)
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