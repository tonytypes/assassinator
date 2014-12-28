class PlaysController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  # GET /plays
  # GET /plays.json
  def index
    @plays = Play.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plays }
    end
  end

  # GET /plays/1
  # GET /plays/1.json
  def show
    @play = Play.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @play }
    end
  end

  # GET /plays/new
  # GET /plays/new.json
  def new
    # @play = Play.new
    @play = current_user.plays.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @play }
    end
  end

  # GET /plays/1/edit
  def editkillcode
    # @play = Play.find(params[:id])
    @play = current_user.plays.find(params[:id])

  end

  def edittargetkillcode
    # @play = Play.find(params[:id])
    @play = current_user.plays.find(params[:id])

  end

  # POST /plays
  # POST /plays.json
  def create
    # @play = Play.new(params[:play])
    @play = current_user.plays.new(params[:play])

    respond_to do |format|
      if @play.save
        format.html { redirect_to @play, notice: 'Play was successfully created.' }
        format.json { render json: @play, status: :created, location: @play }
      else
        format.html { render action: "new" }
        format.json { render json: @play.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /plays/1
  # PUT /plays/1.json
  def updatekillcode
    # @play = Play.find(params[:id])
    @play = current_user.plays.find(params[:id])
    @play.updatekillcode = true
    respond_to do |format|
      if @play.update_attributes(params[:play])
        format.html { redirect_to @play, notice: 'Play was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "editkillcode" }
        format.json { render json: @play.errors, status: :unprocessable_entity }
      end
    end
  end

  def updatetargetkillcode
    # @play = Play.find(params[:id])
    # binding.pry
    @play = current_user.plays.find(params[:id])
    @game = @play.game
    @play.updatetargetkillcode = true
    @plays_in_this_game = Play.where('game_id' => @game)

    # This is where my code for reassigning targets begins
    
#    @play_as_assassin = Play.where('userone_id' => current_user).first
    @play_as_assassin = @play
    @play_as_target = @plays_in_this_game.where('targetuser_id' => current_user).first

    @current_target = @play_as_assassin.target
    @current_target_play = @plays_in_this_game.where('userone_id' => @current_target).first
    @correct_killcode = @current_target_play.useronekillcode
    @targetkillcode = params[:play][:targetkillcode]

# I used these flash notices to test that my variables were working
#    flash[:notice] = "Flash function is working: #{params[:play][:targetkillcode]}"
#    flash[:notice] = "Flash function is working: this play #{@play.id} play_as_assassin #{@play_as_assassin.id} play_as_target #{@play_as_target.id} current_target_play #{@current_target_play.id}"

    # Test to see if the submitted targetkillcode matches the useronekill code
    # entered by the target in his/her play
    if @targetkillcode == @correct_killcode
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
#    elsif @targetkillcode != nil && @correct_killcode != @targetkillcode
    end

    # This needs to change depending on success or error...
    # Maybe follow what's under "create" or "update" way down below

    respond_to do |format|
#      if @targetkillcode != nil
      if @targetkillcode != ""
        if @targetkillcode == @correct_killcode
          format.html { redirect_to @play, notice: 'Kill code matched!' }
          format.json { head :no_content }
        else
          ## insert what happens if we save params (i.e.: there's an entry in the
          ## text box), but it's not the right kill code.
          format.html { 
            @play.errors[:targetkillcode] = 'Kill code does not match.'
            render 'edittargetkillcode'  
          }
          format.json { head :no_content }
        end
      else
#        format.html { render action: "edittargetkillcode" }
#        format.json { render json: @play.errors, status: :unprocessable_entity }
        format.html { 
          @play.errors[:targetkillcode] = 'Cannot be blank.'
          render 'edittargetkillcode'  
        }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /plays/1
  # DELETE /plays/1.json
  def destroy
    # @play = Play.find(params[:id])
    @play = current_user.plays.find(params[:id])

    @play.destroy

    respond_to do |format|
      format.html { redirect_to plays_url }
      format.json { head :no_content }
    end
  end
end
