class TranscriptsController < ApplicationController
  before_action :set_transcript, only: [:show, :edit, :update, :destroy]
 before_action :authenticate_user!
 
  # GET /transcripts
  # GET /transcripts.json
  def index
    @user = current_user
    @transcripts = @user.transcripts

     # format.json { render json: @transcript.lines.to_json, status: :ok }
  end

  # GET /transcripts/1
  # GET /transcripts/1.json
  def show
    respond_to do |format|
      format.html   
      format.text { response.headers['Content-Disposition'] = "attachment; filename=transcript_#{ @transcript.name}_#{Time.now.strftime("%Y-%m-%d_%R")}.txt" }
      format.sbv { response.headers['Content-Disposition'] = "attachment; filename=transcript_#{ @transcript.name}_#{Time.now.strftime("%Y-%m-%d_%R")}.sbv" }
      format.srt { response.headers['Content-Disposition'] = "attachment; filename=transcript_#{ @transcript.name}_#{Time.now.strftime("%Y-%m-%d_%R")}.srt" }
  
    end
  end

  # GET /transcripts/new
  def new
     @user = current_user
    @transcript = @user.transcripts.new(:date => Time.now.strftime("%d/%m/%Y"), :youtubeurl => "http://youtu.be/")

  end

  # GET /transcripts/1/edit
  def edit
  end

  # POST /transcripts
  # POST /transcripts.json
  def create
  # render plain: params[:sbv_file].original_filename.inspect
    @user = current_user
    @transcript =  @user.transcripts.create(transcript_params)

    # if TRANSCRIPT IF SBV CALLL SBV METHOD
    if params[:sbv_file].original_filename.split(".")[1]=="sbv"
      @transcript.read_sbv_file(params[:sbv_file])
    

 # IF TRANSCRIPT IS SRT CALL SRT METHOD
  elsif params[:sbv_file].original_filename.split(".")[1]=="srt"
     @transcript.read_srt_file(params[:sbv_file])

     # render plain: params[:sbv_file].original_filename.inspect

  end#end if

    respond_to do |format|
      if @transcript.save
        format.html { redirect_to @transcript, notice: 'Transcript was successfully created.' }
        format.json { render :show, status: :created, location: @transcript }
         # intercom_custom_data.user['Created_New_Transcript'] = Time.now
      else
        format.html { render :new }
        format.json { render json: @transcript.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transcripts/1
  # PATCH/PUT /transcripts/1.json
  def update
    # render plain: params[:id].inspect
    @user = current_user
    @transcript =  @user.transcripts.find( params[:id])

    respond_to do |format|
      if @transcript.update(transcript_params)
        format.html { redirect_to @transcript, notice: 'Transcript was successfully updated.' }
        format.json { render :show, status: :ok, location: @transcript }
      else
        format.html { render :edit }
        format.json { render json: @transcript.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transcripts/1
  # DELETE /transcripts/1.json
  def destroy
    @transcript.destroy
    respond_to do |format|
      format.html { redirect_to transcripts_url, notice: 'Transcript was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transcript
       @user = current_user
    @transcript =  @user.transcripts.find(params[:id])
      # @transcript = Transcript.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transcript_params
      params.require(:transcript).permit(:filename, :speakername, :date, :youtubeurl, :reel, :tc_meta,:name)
    end
end
