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
    format.csv { send_data @paperedit.lines.to_csv, filename: "paper-edit_#{ @paperedit.projectname}_#{Time.now.strftime("%Y-%m-%d_%R")}.csv" }
    format.xml {send_data @paperedit.lines.to_xml(skip_instruct: true, except: [ :id, :n, :created_at, :updated_at ]), filename: "Paperedit.xml" }
    format.edl { response.headers['Content-Disposition'] = "attachment; filename=paperEdit.edl" }
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

@paperedit = Paperedit.find(params[:paperedit_id])
n= params[:lines].length # = numberOfelementsInTable 

temp1 = "hello from controller"
linesHash = params[:lines]
 linesHash.delete("0") #deletes this ie "0"=>{"line_id"=>"00", "position_id"=>"0"}

temp2 =[]#for troubleshooting
linesHash.each do |key, value|
line = Line.find(value[:line_id])

# IF LINE IN PAPER EDIT THEN UPDATE POSITION
if @paperedit.lines.include?(line)
papercut = Papercut.where(line_id: line.id).first #for now only working with one instance of line per paper edit need to refactor this to support multiple lines.
papercut.position = value[:position_id].to_i
papercut.save
# IF LINE NOT IN PAPER EDIT CREATE &&&&&& ADD POSITION
else 
  @paperedit.lines << line
papercut = Papercut.where(line_id: line.id).first #for now only working with one instance of line per paper edit need to refactor this to support multiple lines.
papercut.position = value[:position_id].to_i
papercut.save
end#end of if else statment
# temp2<<value[:line_id]
# temp2<<value[:position_id]
end#end of .each on hash
temp={hello: "#{temp1}"}

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
