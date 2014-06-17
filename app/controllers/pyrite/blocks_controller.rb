module Pyrite
  class BlocksController < PyriteController

    respond_to :js, :only => [:update, :destroy, :move, :resize, :create, :create_part_time]
    before_filter :check_settings

    def new
      authorize! :manage, Block
      @block = Block.new
      @groups = Group.all
      @rooms = Room.all
    end

    def new_part_time
      authorize! :manage, Block
      @block = Block.new
      @groups = Group.all
      @rooms = Room.all
      @meetings = AcademicYear::Meeting.for_editing
      unless @meetings.first
        flash[:notice] = t("notice_missing_academic_year_meeting",
          :url => view_context.link_to(t("link_in_flash_academic_year_edit"),
          main_app.edit_academic_year_path(AcademicYear.for_editing))).html_safe
        redirect_to dashboard_index_path
      end
    end

    def edit
      authorize! :manage, Block
      @block = Block.find(params[:id])
      @groups = Group.all
      @rooms = Room.all
      @lecturers = Lecturer.all
      @block_variants = Block::Variant.all
      render :layout => false
    end

    def update
      authorize! :manage, Block
      @block = Block.find(params[:id])
      if @block.update_attributes(form_params_update)
        flash[:notice] = t("notice_block_has_been_updated")
        respond_with(@block)
      else
        respond_with(@block, :status => :unprocessable_entity)
      end
    end

    def create
      authorize! :manage, Block
      @block = Block.new(form_params)
      if @block.save
        flash[:notice] = t("notice_block_has_been_created")
        respond_with(@block, :status => :ok)
      else
        respond_with(@block, :status => :unprocessable_entity)
      end
    end

    def create_part_time
      authorize! :manage, Block
      @block = Block.new(form_part_time_params)
      @meetings = AcademicYear::Meeting.for_editing

      if @block.save
        flash[:notice] = t("notice_block_has_been_created")
        respond_with(@block, :status => :ok)
      else
        respond_with(@block, :status => :unprocessable_entity)
      end
    end

    def destroy
      authorize! :manage, Block
      @block = Block.find(params[:id])
      @block.destroy
      respond_with(@block)
    end

    def move
      authorize! :manage, Block
      @block = Block.find(params[:id])
      day_delta = params[:day_delta]
      minute_delta = params[:minute_delta]
      if @block.move_to(day_delta.to_i, minute_delta.to_i)
        respond_with(@block, :status => :ok)
      else
        respond_with(@block, :status => :unprocessable_entity)
      end
    end

    def resize
      authorize! :manage, Block
      @block = Block.find(params[:id])
      day_delta = params[:day_delta]
      minute_delta = params[:minute_delta]
      if @block.resize(day_delta.to_i, minute_delta.to_i)
        respond_with(@block, :status => :ok)
      else
        respond_with(@block, :status => :unprocessable_entity)
      end
    end

    private

      def form_params
        params.required(:block).permit(:start_time, :day_with_date, :variant_id, { :group_ids => [] },
          :lecturer_id, :comments, :end_time, :event_id, :room_id, :name)
      end

      def form_part_time_params
        params.required(:block).permit(:start_time, :day_with_date, :variant_id, { :group_ids => [] },
          :lecturer_id, :comments, :end_time, :meeting_id, :room_id, :name)
      end

      def form_params_update
        params.required(:block).permit(:lecturer_id, :room_id, :comments, :variant_id, :name, { :group_ids => [] })
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
