class KillcodechecksController < ApplicationController
  before_filter :authenticate_user!, except: [:index]

  # GET /killcodechecks
  # GET /killcodechecks.json
  def index
#    @killcodechecks = Killcodecheck.all

    respond_to do |format|
      format.html { redirect_to new_killcodecheck_path } # index.html.erb
      format.json { render json: @killcodechecks }
    end
  end

  # GET /killcodechecks/1
  # GET /killcodechecks/1.json
  def show
    @killcodecheck = Killcodecheck.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @killcodecheck }
    end
  end

  # GET /killcodechecks/new
  # GET /killcodechecks/new.json
  def new
    @killcodecheck = Killcodecheck.new
    # @killcodecheck = current_user.killcodechecks.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @killcodecheck }
    end
  end

  # GET /killcodechecks/1/edit
  def edit
    @killcodecheck = Killcodecheck.find(params[:id])
    # @killcodecheck = current_user.killcodechecks.find(params[:id])

  end

  # POST /killcodechecks
  # POST /killcodechecks.json
#  def create
#    @killcodecheck = Killcodecheck.new(params[:killcodecheck])
    # @killcodecheck = current_user.killcodechecks.new(params[:killcodecheck])

#    respond_to do |format|
#      if @killcodecheck.save
#        format.html { redirect_to @killcodecheck, notice: 'Killcodecheck was successfully created.' }
#        format.json { render json: @killcodecheck, status: :created, location: @killcodecheck }
#      else
#        format.html { render action: "new" }
#        format.json { render json: @killcodecheck.errors, status: :unprocessable_entity }
#      end
#    end
#  end

  # PUT /killcodechecks/1
  # PUT /killcodechecks/1.json
  def update
    @killcodecheck = Killcodecheck.find(params[:id])
    # @killcodecheck = current_user.killcodechecks.find(params[:id])

    respond_to do |format|
      if @killcodecheck.update_attributes(params[:killcodecheck])
        format.html { redirect_to @killcodecheck, notice: 'Killcodecheck was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @killcodecheck.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /killcodechecks/1
  # DELETE /killcodechecks/1.json
  def destroy
    @killcodecheck = Killcodecheck.find(params[:id])
    # @killcodecheck = current_user.killcodechecks.find(params[:id])

    @killcodecheck.destroy

    respond_to do |format|
      format.html { redirect_to plays_url }
      format.json { head :no_content }
    end
  end

  # Here's the code to get the next target, executed upon submission of target kill code
  def create
    @killcodecheck = Killcodecheck.new(params[:killcodecheck])

    @game = Game.where('id' => @killcodecheck.game_id).first
#    @game = Game.find(params[:id])
    # This will let me display the plays for each game, in Show view
    @plays = @game.plays.all
    # This is where my code for saving the shuffled targets begins
    
    @play_as_assassin = @game.plays.where('userone_id' => current_user).first
    @play_as_target = @game.plays.where('targetuser_id' => current_user).first

    @current_target = @play_as_assassin.target
    @current_target_play = @game.plays.where('userone_id' => @current_target).first
    @correct_killcode = @current_target_play.useronekillcode

    # Test to see if the submitted targetkillcode matches the useronekill code
    # entered by the target in his/her play
    if @correct_killcode == @killcodecheck.targetkillcode
      # Retrieve the new target
      @new_target_id = @current_target_play.target.id
      # For the current user (as assassin) play, replace the current target id
      # with the new target id
      @play_as_assassin.update_attribute(:targetuser_id, @new_target_id)
      # Clear the targetuser_id column for the current (now old) target's play
      @current_target_play.update_attribute(:targetuser_id, nil)
      # Change the "status" column for that old target's play to the number 2,
      # which will signify "assassinated"
      @current_target_play.update_attribute(:useronestatus, 2)
      # Finally, add +1 to the "kills" column for the assassin's play
      # (May need to add this with a migration, still.)
      @play_as_assassin.increment!(:kills)
    end

    # This needs to change depending on success or error...
    # Maybe follow what's under "create" or "update" way down below
    respond_to do |format|
      if @correct_killcode == @killcodecheck.targetkillcode
        format.html { redirect_to @game, notice: 'Kill code was correct. Here is your new target.' }
        format.json { head :no_content }
      else
#        format.html { redirect_to @game, notice: 'Kill code was incorrect. Try again.' }
        format.html { render action: "new" }
        format.json { render json: @killcodecheck.errors, status: :unprocessable_entity }
      end
    end

  end




end
