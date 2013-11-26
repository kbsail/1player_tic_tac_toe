class GameController

  attr_accessor :current_game, :view

  def initialize(player)
    self.current_game = Game.new(player, 'Computer')
    self.view = View.new
  end

  # runs the game from the start - acts as a method of driver code
  def run_game
    until current_game.finished?
      if current_game.current_player_turn == 1
        view.print_board(current_game.board)
        move = get_player_input(player_turn)
        make_move(player_turn, move)
        check_winner(player_turn)
        change_turns
      else
        computer = GameAI.new(current_game)
        make_move(player_turn, computer.move)
        check_winner(player_turn)
        change_turns
      end
    end
    view.finished_view(current_game)
  end

  # private

  # checks to see if a space is open or not, used in the human input
  def check_space_availability(space)
    if current_game.space_open?(space)
      true
    else
      self.view.invalid_entry
      false
    end
  end

  # returns the current player's turn
  def player_turn
    current_game.current_player_turn
  end

  # checks for a winner
  def check_winner(player)
    current_game.check_win(player)
  end

  # places the players move onto the board
  def make_move(player, move)
    current_game.set_player(move, player)
    self.view.give_feedback(move, player)
  end

  # get's the human's input
  def get_player_input(player)
    space_available = nil

    until space_available
      input = self.view.get_input
      space_available = check_space_availability(input)
    end

    input
  end

  # changes the turn to the next person after the turn is over
  def change_turns
    current_game.next_turn
  end
  
end
