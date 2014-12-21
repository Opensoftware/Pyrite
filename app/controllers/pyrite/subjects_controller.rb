module Pyrite
  class SubjectsController < PyriteController

    def index
      authorize! :manage, Subject
      page = params[:page].to_i < 1 ? 1 : params[:page]
      per_page = params[:per_page].to_i < 1 ? 15 : params[:per_page]
      @subjects = Subject.order(:name).paginate(:page => page, :per_page => per_page)
    end

    def new
      authorize! :manage, Subject
      @subject = Subject.new
    end

    def edit
      authorize! :manage, Subject
      @subject = Subject.where(:id => params[:id]).first
    end

    def create
      authorize! :manage, Subject
      @subject = Subject.new(form_params)

      if @subject.save
        flash[:notice] = t("pyrite.notice.subject_has_been_created")
        redirect_to subjects_path
      else
        render action: "new"
      end
    end

    def update
      authorize! :manage, Subject
      @subject = Subject.where(:id => params[:id]).first

      if @subject.update_attributes(form_params)
        flash[:notice] = t("pyrite.notice.subject_has_been_updated")
        redirect_to subjects_path
      else
        render :edit
      end
    end

    def destroy
      authorize! :manage, Subject
      @subject = Subject.where(:id => params[:id]).first
      @subject.destroy

      redirect_to subjects_path
    end

    private

      def form_params
        params.require(:subject).permit(:name)
      end
  end
end
