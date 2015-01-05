module Pyrite
  class ReservationsController < PyriteController
    helper "pyrite/application"
    include BlocksHelper

    skip_authorization_check :only => [:show]

    before_filter :check_settings, :except => [:show]

    respond_to :js, :only => [:update, :create]

    def show
      authorize! :read, :timetables
      @room = Room.find(params[:room_id])
      # TODO implement with event_id
      @events = convert_blocks_to_events_for_viewing(@room.blocks)
    end

    def new
      authorize! :manage, :reservations
      @rooms = Room.all
      @block = Block.new
    end

    def create
      authorize! :manage, :reservations
      @block = Block.new(form_params)
      @rooms = Room.all

      @block.reservation = true
      if @block.save
        flash.now[:notice] = t("notice_block_has_been_created")
        respond_with(@block, :status => :ok)
      else
        respond_with(@block, :status => :unprocessable_entity)
      end
    end

    private

      def form_params
        params.required(:block).permit(:start_time, :day_with_date,
          { :lecturer_ids => [], :room_ids => []}, :comments, :end_time, :variant_id, :name, :custom_block_dates)
      end

      def check_settings
        academic_year_for_editing = AcademicYear.for_editing
        if academic_year_for_editing.blank?
          flash[:notice] = t("notice.missing.academic_year")
          redirect_to dashboard_index_path
        end
      end
  end
end
