class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

         has_many :paperedits, dependent: :destroy
         has_many :transcripts, dependent: :destroy





#  after_create :create_default_paperedit_example           
#    #method for creating default paper edit example album
#    def create_default_paperedit_example

#   #     Album.create(user_id: self.id, title:"Default Story Album", description:"This is your Default Story Album, where you are prompted to save your tracks by default." )
#   @user = current_user
#   @user.transcripts.create(filename: "Q_and_A_Sir_Ken_Robinson.mp4", name: "YouTube Interview with Sir Ken Robinson", speakername: "Sir Ken Robinson", date: Time.now, youtubeurl: "http://youtu.be/AxkaApEbQek", reel: "CARD?  ", tc_meta: "00:00:00:00")
  
#   # create transcriptions
#   # create paper edit
#   # add first and last line of transcription to paper edit
# end
#  end
end
