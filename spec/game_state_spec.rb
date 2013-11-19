require_relative('spec_helper')


describe GameState do

  let(:game) { Game.new('Kevin', 'Bob') }
  let(:game_state) { GameState.new(game) }

  describe '#new' do

    context 'with valid parameters' do
      it 'creates a new game state object' do
        expect(game_state).to be_an_instance_of(GameState)
      end

      it 'has a current game' do
        expect(game_state.current_game).to be_an_instance_of(Game)
      end

      it 'has an array of avaialable moves' do
        expect(game_state.available_moves).to be_an_instance_of(Array)
      end

      it 'has the current player\'s turn' do
        expect(game_state.current_turn).to eq(1)
      end
    end
  end

  describe '#next_move' do
    context 'with valid parameters' do
      it 'takes the player\'s turn as input' do
        expect(game_state).to receive(:next_move).with(:current_turn)
      end
    end

    context 'when its the computer\'s turn' do
      it 'something' do
        pending
      end
    end
  end


end