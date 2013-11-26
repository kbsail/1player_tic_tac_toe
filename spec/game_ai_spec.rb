require_relative('spec_helper')

describe GameAI do

  let(:game) { Game.new('Kevin', 'Bob') }
  let(:game_ai) { GameAI.new(game) }

  describe '#new' do

    context 'with valid parameters' do
      it 'creates a new game state object' do
        expect(game_ai).to be_an_instance_of(GameAI)
      end

      it 'has a current game' do
        expect(game_ai.current_game).to be_an_instance_of(Game)
      end

      it 'has an array of avaialable moves' do
        expect(game_ai.available_moves).to be_an_instance_of(Array)
      end

      it 'has a game board state' do
        expect(game_ai.game_board).to be_an_instance_of(Array)
      end

      it 'has the current player\'s turn' do
        expect(game_ai.current_turn).to eq(1)
      end
    end
  end

  describe '#win' do
    before do
      game_ai.stub(:current_turn).and_return(1)
    end

    context 'with a winning space' do 
      before { game_ai.current_game.stub(:board).and_return([1, 1, 0, 2, 2, 0, 0, 0, 0]) }
      
      it 'returns the space a computer can win' do
        expect(game_ai.win).to eq(5)
      end
    end

    context 'without a winning space' do
      before { game_ai.current_game.stub(:board).and_return([1, 1, 2, 2, 0, 0, 0, 0, 0]) }

      it 'returns nil' do
        expect(game_ai.win).to eq(nil)
      end
    end
  end

  describe '#move' do
    describe 'the computer\'s first turn' do
      before do
        game_ai.current_game.board = [1, 0, 0, 0, 0, 0, 0, 0, 0]
        game_ai.current_game.stub(:turns).and_return(1)
      end

      it 'calls #ai_first_move' do
        game_ai.stub(:ai_first_move)
        expect(game_ai).to receive(:ai_first_move)
        game_ai.move
      end
        
      it 'checks if the center space has been taken' do
        expect(game_ai.first_move_center?).to eq(false)
      end

      context 'with the center space open' do
        it 'returns the center space as the available move' do
          expect( game_ai.move ).to eq(4)
        end
      end

      context 'with the center space taken' do
        before { game_ai.current_game.board = [0, 0, 0, 0, 1, 0, 0, 0, 0] }

        it 'returns the first corner space' do
          expect( game_ai.move ).to eq(0)
        end
      end
    end

      ##########################################################

    describe 'the computer\'s second turn' do
      before do
        game_ai.current_game.stub(:turns).and_return(3)
      end

      it 'calls #ai_second_move' do
        game_ai.stub(:ai_second_move)
        expect(game_ai).to receive(:ai_second_move)
        game_ai.move
      end
      
      context 'when the human can win' do
        it 'returns the space to block the human' do
          game_ai.current_game.board = [1, 1, 0, 0, 2, 0, 0, 0, 0]
          expect( game_ai.move ).to eq(2)
        end
      end

      context 'when the human has the center and the corner opposite the computer' do
        it 'takes a corner space' do
          game_ai.current_game.board = [2, 0, 0, 0, 1, 0, 0, 0, 1]
          expect( game_ai.move ).to eq(2)
        end
      end

      context 'with the human in opposite corners' do
        it 'takes a middle space' do
          game_ai.current_game.board = [1, 0, 0, 0, 2, 0, 0, 0, 1] 
          game_ai.move
          expect(current_game.check_two(2, 0)).to eq(3)
        end
      end

      context 'without needing a defensive move' do
        it 'takes begins attacking' do
          game_ai.current_game.board = [0, 1, 0, 0, 2, 0, 0, 1, 0] 
          expect( game_ai.move ).to eq(3)
        end
      end

    end 



  #     context 'with a winning move' do
  #       before do
  #         game_ai.current_game.board = [0, 0, 0, 2, 2, 0, 1, 1, 0]
  #         # game_ai.stub(:win).and_return(8)
  #       end

  #       it 'checks for the winning move' do
  #         game_ai.current_game.stub(:check_two)
  #         expect(game_ai.current_game).to receive(:check_two).with(1, 0)
  #         game_ai.move
  #       end

  #       it 'finds the winning move space' do
  #         game_ai.move
  #         expect(game_ai.winning_move).to eq(8)
  #       end

  #       it 'makes a move' do
  #         expect{ game_ai.move }.to change{ game_ai.available_moves.count }.from(5).to(4)
  #       end

  #       it 'win\'s the game' do
  #         game_ai.move
  #         game_ai.current_game.check_win(1)
  #         expect( game_ai.current_game.winner ).to eq(1)
  #       end
  #     end

  #     context 'when the human has a winning move' do
  #       before { game_ai.current_game.board = [1, 0, 0, 2, 2, 0, 0, 1, 0] }       

  #       it 'finds the winning space' do
  #         game_ai.move
  #         expect( game_ai.winning_move ).to eq(5)
  #       end

  #       it 'makes a move' do
  #         expect{ game_ai.move }.to change{ game_ai.available_moves.count }.from(5).to(4)
  #       end

  #       it 'blocks the win' do
  #         game_ai.move
  #         expect( game_ai.board_state[5]).to eq(1)
  #       end
  
    
  #   end
  # end

  # describe "#final_state_value" do

  #   context 'when player 1 has won' do
  #     it 'returns the value 1' do
  #       game_ai.current_game.stub(:winner).and_return(1)
  #       expect(game_ai.final_state_value).to eq(1)
  #     end
  #   end

  #   context 'when player 2 (computer) has won' do
  #     it 'returns the value -1' do
  #       game_ai.current_game.stub(:winner).and_return(2)
  #       expect(game_ai.final_state_value).to eq(-1)
  #     end
  #   end

  #   context 'when the game is a draw' do
  #     it 'returns the value 0' do
  #       game_ai.current_game.stub(:draw?).and_return(true)
  #       expect(game_ai.final_state_value).to eq(0)
  #     end
  #   end 

  # end

  # describe "#analyze_state" do
    
  #   context 'when the the game is completed' do
      
  #     before do
  #       game_ai.current_game.stub(:finished?).and_return(true)
  #       game_ai.current_game.stub(:winner).and_return(1)
  #     end

  #     it 'checks to see if the game_ai is finished' do
  #       game_ai.analyze_state
  #       expect(game_ai.current_game).to have_received(:finished?)
  #     end

  #     it 'returns the final state value' do
  #       expect(game_ai.analyze_state).to eq(1)
  #     end

  #   end

  #   context 'when the game is incomplete' do
  #     it 'calculates the route value' do
  #       pending
  #     end
      
  #   end

  end

end