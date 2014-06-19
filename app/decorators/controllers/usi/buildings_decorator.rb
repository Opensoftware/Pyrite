BuildingsController.class_eval do

  before_filter :load_rooms, :only => :show


  private

    def load_rooms
      @rooms = Building.find(params[:id]).rooms
    end

end
