module Pyrite
  class BlocksController < PyriteController

    respond_to :js, :only => [:update, :destroy, :move, :resize, :create, :create_part_time]
    before_filter :check_settings

    def new
      authorize! :manage, Block
      @block = Block.new
      @groups = Group.includes(:studies).order(:name)
      @optgroups = Studies.all
      @rooms = Room.all
      @subjects = Subject.all
      prepare_group_categories
    end

    def new_part_time
      authorize! :manage, Block
      @block = Block.new
      @groups = Group.includes(:studies).order(:name)
      @rooms = Room.all
      @meetings = AcademicYear::Meeting.for_editing
      @optgroups = Studies.all
      @subjects = Subject.all
      prepare_group_categories
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
      @subjects = Subject.all
      @lecturers = Lecturer.order(:surname)
      @block_variants = Block::Variant.all
      render :layout => false
    end

    def update
      authorize! :manage, Block
      @block = Block.find(params[:id])
      if @block.update_attributes(form_params_update)
        flash.now[:notice] = t("notice_block_has_been_updated")
        respond_with(@block)
      else
        respond_with(@block, :status => :unprocessable_entity)
      end
    end

    def create
      authorize! :manage, Block
      @block = Block.new(form_params)
      if @block.save
        flash.now[:notice] = t("notice_block_has_been_created")
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
      def prepare_group_categories
        category_groups_aggregate = Group.category_aggregate
        optgroup_name = I18n.t("pyrite.label.group_categories")
        optgroup_elements = []
        category_groups_aggregate.each do |category_name, groups_ids|
          # We are adding v_ prefix to the value to avoid problems with id
          # conflicts between tags and group_id. When tag will have the same name
          # as group_id, selec2 will remove it from the list if the group_id will
          # be selected.
          optgroup_elements << [category_name, "v_" + category_name, :class => "group_category", "data-group-ids" => groups_ids.to_a.join(",")]
        end
        @optgroups_hash = { optgroup_name => optgroup_elements }
      end


      def form_params
        params.required(:block).permit(:start_time, :day_with_date, :variant_id, { :group_ids => [],
          :lecturer_ids => [], :room_ids => [] }, :comments, :end_time, :event_id, :subject_id, :custom_block_dates)
      end

      def form_part_time_params
        params.required(:block).permit(:start_time, :day_with_date, :variant_id, { :group_ids => [],
          :lecturer_ids => [], :room_ids => [] }, :comments, :end_time, :meeting_id, :subject_id)
      end

      def form_params_update
        params.required(:block).permit(:comments, :variant_id, :subject_id,
                                       {:room_ids => [], :lecturer_ids => [], :group_ids => [] })
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
