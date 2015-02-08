class PapereditsController < ApplicationController
  before_action :set_paperedit, only: [:show, :edit, :update, :destroy]
 before_action :authenticate_user!
  # GET /paperedits
  # GET /paperedits.json
  def index
    @user =current_user
    @paperedits = @user.paperedits
  end

  # GET /paperedits/1
  # GET /paperedits/1.json
  def show
     @user =current_user
    @paperedit = @user.paperedits.find(params[:id])

     # @paperedit = Paperedit.find(params[:id])
     if ! @paperedit.lines.blank?
       @lines = @paperedit.lines
       # @numberOfWords=  @paperedit.lines.find(:all).map(&:text).to_s.scan(/\w+/).size
     end
  end

  # GET /paperedits/new
  def new
      @user =current_user
    @paperedit =   @user.paperedits.new
   
  end

  # GET /paperedits/1/edit
  def edit
  end

  # POST /paperedits
  # POST /paperedits.json
  def create
     @user =current_user
    @paperedit =    @user.paperedits.new(paperedit_params)
    # @paperedit = Paperedit.new(paperedit_params)

    respond_to do |format|
      if @paperedit.save
        format.html { redirect_to paperedit_papercuts_path(@paperedit), notice: 'Paperedit was successfully created.' }
        format.json { render :show, status: :created, location: @paperedit }
      else
        format.html { render :new }
        format.json { render json: @paperedit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /paperedits/1
  # PATCH/PUT /paperedits/1.json
  def update
    @user = current_user
    @paperedit =  @user.paperedits.find( params[:id])


    respond_to do |format|
      if @paperedit.update(paperedit_params)
        format.html { redirect_to paperedit_papercuts_path(@paperedit), notice: 'Paperedit was successfully updated.' }
        format.json { render :show, status: :ok, location: @paperedit }
      else
        format.html { render :edit }
        format.json { render json: @paperedit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paperedits/1
  # DELETE /paperedits/1.json
  def destroy
    @paperedit.destroy
    respond_to do |format|
      format.html { redirect_to paperedits_url, notice: 'Paperedit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  def save_paper_edit

paperEditId = params[:paperediting_id]
## finds the paper edit we are working on using params hash
 @paperedit = Paperedit.find(paperEditId)
lines = params[:lines]

linesArray = lines.split("$")# ie ["line_id0,position_0", " line_id2,position_1", " line_idLastRow,position_2", " "]
linesArray.shift # remove first element ie "line_id,position_0"
linesArray.pop # remove last element ie " "
linesArray.pop #removes redundant element ie " line_idLastRow,position_2"
n = linesArray.length  #exclude first and last
 
  # for i in 0...n
  i = 0 
    collectionOflinedAndpositionArray =[]
  linesArray.each do |lineInArray|
      line_id = linesArray[i].split(",")[0] #To find Line ID ie " line_id140"
      line_id = line_id.split("line_id")[1] # gives you the number  ie 140
      position_id = linesArray[i].split(",")[1] # tp update position ie "position_1"
      position_id = position_id.split("position_")[1]  #ie 1
      linedAndpositionArray =[]
      linedAndpositionArray<< line_id
      linedAndpositionArray << position_id

      collectionOflinedAndpositionArray << linedAndpositionArray
      i+=1
end 

collectionOflinedAndpositionArray.each do |linePosition|

line_id = linePosition[0]
position_id = linePosition[1]

 @line = Line.find(line_id)
# IF LINE NOT IN PAPER EDIT
if Papercut.where(:line_id => line_id).blank? #true => line is not in paper edit
#so we add the line to the paper edit
@paperedit.lines << @line

######WORKS IN CONSOLE
# Paperedit.last.lines << Line.first
 # Paperedit.last.save 
############################
#we set the position 
@paperedit.lines.last.position = position_id.to_i
@paperedit.save

# IF LINE ALREADY IN PAPER EDIT
else#if !LinePaperediting.where(:line_id => line_id).blank?
# I delete the line from the paper edit, so that I can then re add it
#  not a great solution, mmomentary patch while I figure out proper way to do it.
Papercut.where(:line_id => line_id).last.destroy
@paperedit.lines << @line
@paperedit.lines.first.position = position_id.to_i
@paperedit.save!
end

end

respond_to do |format|  
     # format.json { render json: {},send_data @paperediting.lines.to_json, filename: "paper-edit_#{ @paperediting.projectname}_#{Time.now.strftime("%Y-%m-%d_%R")}.json", status: :ok }
    format.json { render json: params, status: :ok} #   
    ###use following commented line if want to see what is in the json params that is getting passed
    ## by returning it to the view, and looking at it int he console. 
    ##format.json { render json: params, status: :ok} #    
    format.js { render :nothing => true }
    format.html 
    ## Other format
  end # end of respond to format



  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paperedit
      @paperedit = Paperedit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def paperedit_params
      params.require(:paperedit).permit(:projectname, :papercuts_attributes =>[:position])
      # supported nested strong params? :papercuts_attributes =>[:position]
      # http://www.sitepoint.com/rails-4-quick-look-strong-parameters/
    end
end
