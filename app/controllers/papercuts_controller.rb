class PapercutsController < ApplicationController
  require 'csv'

  before_action :set_papercut, only: [:show, :edit, :update, :destroy]
   before_action :authenticate_user!
  # attr_accessible :position #not sure if this is needed?
  # GET /papercuts
  # GET /papercuts.json
  def index
    @user = current_user

    @transcripts = @user.transcripts

    @allUserLines  =[]
    @transcripts.each do |t|
      t.lines.order("n asc").each do |l|
       @allUserLines << l
     end #end of loop
   end#end of loop

     @paperedit =  @user.paperedits.find(params[:paperedit_id])
     @papercuts = @paperedit.papercuts

respond_to do |format|
    format.html   
    # format.text{ send_data @paperedit.lines, filename: "paper-edit_#{ @paperedit.projectname}_#{Time.now.strftime("%Y-%m-%d_%R")}.txt" }
    format.text { response.headers['Content-Disposition'] = "attachment; filename=paper-edit_#{ @paperedit.projectname}_#{Time.now.strftime("%Y-%m-%d_%R")}.txt" }
    format.csv { send_data @paperedit.lines.to_csv, filename: "paper-edit_#{ @paperedit.projectname}_#{Time.now.strftime("%Y-%m-%d_%R")}.csv" }
    format.xml {send_data @paperedit.lines.to_xml(skip_instruct: true, except: [ :id, :n, :created_at, :updated_at ]), filename: "paper-edit_#{ @paperedit.projectname}_#{Time.now.strftime("%Y-%m-%d_%R")}.xml" }
    format.edl { response.headers['Content-Disposition'] = "attachment; filename=paper-edit_#{ @paperedit.projectname}_#{Time.now.strftime("%Y-%m-%d_%R")}.edl" }
    format.json { send_data @paperedit.lines.to_json, filename: "paper-edit_#{ @paperedit.projectname}_#{Time.now.strftime("%Y-%m-%d_%R")}.json" }
    # format.json { render json: @paperediting.lines }
end # end of looop


  end

  # GET /papercuts/1
  # GET /papercuts/1.json
  def show

  end



  # GET /papercuts/new
  def new
    @papercut = Papercut.new
  end

  # GET /papercuts/1/edit


  # POST /papercuts
  # POST /papercuts.json
  def create
    @papercut = Papercut.new(papercut_params)

    respond_to do |format|
      if @papercut.save
        format.html { redirect_to @papercut, notice: 'Papercut was successfully created.' }
        format.json { render :show, status: :created, location: @papercut }
      else
        format.html { render :new }
        format.json { render json: @papercut.errors, status: :unprocessable_entity }
      end
    end
  end


  def edit
 
    @paperedit =  Paperedit.find(params[:paperedit_id])
    @papercut = @paperedit.papercuts.find(params[:id])
  end
  # PATCH/PUT /papercuts/1
  # PATCH/PUT /papercuts/1.json
  def update
       # render plain: params[:id].inspect
  @paperedit = Paperedit.find(params[:papercut][:paperedit_id])
  @papercut = @paperedit.papercuts.find(params[:id])
#    position = params[:line][:position]

# lpe = LinePaperediting.where(:line_id => (params[:id]), :paperediting_id => (params[:paperediting_id]))
# lpe.first.update(:position => position)


#   if @line.update(line_params)
#     # render params.inspect
#     redirect_to @paperediting
#   else
#     render 'edit'
#   end

    respond_to do |format|
      if @papercut.update(papercut_params)
        format.html { redirect_to paperedit_path(@paperedit), notice: 'Papercut was successfully updated.' }
        format.json { render :show, status: :ok, location: @papercut }
      else
        format.html { render :edit }
        format.json { render json: @papercut.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /papercuts/1
  # DELETE /papercuts/1.json
  def destroy
    @paperedit = Paperedit.find(params[:paperedit_id])
    @papercut = @paperedit.papercuts.find(params[:id])
    @papercut.destroy
    respond_to do |format|
      format.html { redirect_to paperedit_papercuts_path(@paperedit), notice: 'Papercut was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def save_paper_edit
# THIS CODE NEEDS REFACTORING IN CONJUNCTION WITH JQUERY AJAX on INDEX.HTML.ERB
# Params hash looks like this if line row beeing moved from transcript table
# "{"1"=>{"line_id"=>"331Transcription", "position_id"=>"1"}, "2"=>{"line_id"=>"326Transcription", "position_id"=>"2"}}"
# Params hash looks like this if line row beeing moved within paper edit table
# "{"1"=>{"line_id"=>"326Position1", "position_id"=>"1"}, "2"=>{"line_id"=>"331Position1", "position_id"=>"2"}, "3"=>{"line_id"=>"331Position1", "position_id"=>"3"}, "4"=>{"line_id"=>"326Position1", "position_id"=>"4"}, "5"=>{"line_id"=>"326Position2", "position_id"=>"5"}, "6"=>{"line_id"=>"326Position2", "position_id"=>"6"}, "7"=>{"line_id"=>"331Position2", "position_id"=>"7"}}"

#The idea is simple,  if it has 331Transcription in the line_id then comes from transcription table
#  if it has 331Position1 in the line_id then it comes from the paper edit table, and the old position can be
# taken from there to uniquely identify the paper cut, ie for this one 331Position1 old position would be 1 and line number 331.

@paperedit = Paperedit.find(params[:paperedit_id])

linesHash = params[:lines]
 linesHash.delete("0") #deletes first useless element ie "0"=>{"line_id"=>"00", "position_id"=>"0"} , need to refactor in Jquery to avoid including it.
# temp 1 is sends the line hash back to view to troubleshoot in browser console.
temp1 = linesHash.inspect  #####

# iterates through all of the elements of the hash, 
# where a key, value pair looks either lik this {"1"=>{"line_id"=>"326Position1", "position_id"=>"1"}
#  or like this {"1"=>{"line_id"=>"331Transcription", "position_id"=>"1"}
#  so to get position or line_id we call on value[:line_id] and value[:position]
linesHash.each do |key, value|
#returns true if Transcription is contained in value[:line_id]
  if !value[:line_id].split(/Transcr/)[1].nil? 
    # isolate line_id from transcription "tag"
    lineID = value[:line_id].split(/Transcription/)[0]
    # find line by ID
    line = Line.find(lineID)
    # adds line to paper edit, because it comes from transcription table
    # and we want to allow to add same line from transcript more then once in the paper edit
    @paperedit.lines << line
    # finds the paper cut corresponding to the line added to the paper edit
    # to uniquely identify we use the line_id,and we also know that a position as not been set by default so
    # se uniquely idenfity it looking for line with that id and positon attribute null.
    # because .where returs a collection array, we take first or last, to have a unique element.
    papercut = Papercut.where(line_id: lineID, position: nil).last #for now only working with one instance of line per paper edit need to refactor this to support multiple lines.
    # now that we have the papercut we can set it's position to the one passed into the params hash
    # not sure if it needs .to_i, but updating position has been temperamental, so for now it works like this.
    papercut.position = value[:position_id].to_i
    # then we save paper cut to close this off.
    papercut.save
    # IF it's not from transcript table then  line is it's from paper edit table
    # I initially had these two checks but decided to get rid of them to simply the code, as only two possibility are possible for now
      # elsif value[:line_id].split(/Transcr/)[1].nil?

      # elsif !value[:line_id].split(/Pos/)[1].nil?

else
  # to be able to update line's paper cuts, when changed in position within the paper edit
  # we identify line_id and position, with method similar to one discussed above.
    old_position = value[:line_id].split(/Position/)[1]
    lineID = value[:line_id].split(/Position/)[0]
    line = Line.find(lineID)
    #we uniquely identify the line's paper cut, using the old position before it was moved.
    # once again .where it returns a collection of one element , so we use .first to have a unique element. 
    papercut = Papercut.where(line_id: line.id, position: old_position).first 
    # we set the new upodate position to the one we passed
    papercut.position = value[:position_id].to_i
    # and save the paper cut
    papercut.save
end #of test if else stamtnt
end#end of .each on hash

# for troubleshooting
temp={hello: "#{temp1}"}

# format support.
respond_to do |format|  
     # format.json { render json: {},send_data @paperediting.lines.to_json, filename: "paper-edit_#{ @paperediting.projectname}_#{Time.now.strftime("%Y-%m-%d_%R")}.json", status: :ok }
    format.json { render json: temp, status: :ok} #   
    ###use following commented line if want to see what is in the json params that is getting passed
    ## by returning it to the view, and looking at it int he console. 
    ##format.json { render json: params, status: :ok} #    
    format.js { render :nothing => true }
    format.html 
    ## Other format
  end # end of respond to format
end #end of save paperedit

# Method to empty all lines in Paper edit at once.

def clear_all
  # render plain: params.inspect
    @user = current_user

    @paperedit =  @user.paperedits.find(params[:id])

    @paperedit.papercuts.each do |pc|
    pc.destroy 
  end 
  redirect_to paperedit_papercuts_path(@paperedit)

end #end of clear_all
############################################################PRIVATE
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_papercut
      @papercut = Papercut.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def papercut_params
      params.require(:papercut).permit(:position, :line_id, :paperedit_id, :comment)
    end
end
