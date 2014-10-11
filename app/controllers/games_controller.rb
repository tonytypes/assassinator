class GamesController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  # GET /games
  # GET /games.json
  def index
    @games = Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])
    # This will let me display the plays for each game, in Show view
    @plays = @game.plays.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # Here's the code to execute upon click, to actually edit the table
  def begingame
    @game = Game.find(params[:id])
    # This will let me display the plays for each game, in Show view
    @plays = @game.plays.all
    # This is where my code for saving the shuffled targets begins
    shuffled = @game.plays.pluck(:userone_id).shuffle
    hash = Hash[shuffled.map.with_index.to_a]
    @plays.each { |n| n.update_attribute(:targetuser_id, shuffled[hash[n.userone_id]-1]) }
    # Change the status of this game to "1," which means "started"
    @game.update_attribute(:status, 1)
    # Upon clicking "Begin Game," redirect to game's show screen
    # and pass a notice that the game was succeffully started.
    respond_to do |format|
      format.html { redirect_to @game, notice: 'Game was successfully started.'  }
      format.json { head :no_content }
    end

  end

  # GET /games/new
  # GET /games/new.json
  def new
    # @game = Game.new
    @game = current_user.games.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    # @game = Game.find(params[:id])
    @game = current_user.games.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    # @game = Game.new(params[:game])
    @game = current_user.games.new(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    # @game = Game.find(params[:id])
    @game = current_user.games.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    # @game = Game.find(params[:id])
    @game = current_user.games.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end



end
