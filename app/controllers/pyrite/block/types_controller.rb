module Pyrite
  class Block::TypesController < PyriteController
    helper "pyrite/blocks"

    def index
      authorize! :manage, Block
      @block_types = Block::Variant.all
    end

    def new
      authorize! :manage, Block
      @block_type = Block::Variant.new
    end

    def edit
      authorize! :manage, Block
      @block_type = Block::Variant.find(params[:id])
    end

    def create
      authorize! :manage, Block
      @block_type = Block::Variant.new(form_params)

      if @block_type.save
        flash[:notice] = t("notice_block_type_created")
        redirect_to block_types_path
      else
        render :new
      end
    end

    def update
      authorize! :manage, Block
      @block_type = Block::Variant.find(params[:id])

      if @block_type.update_attributes(form_params)
        flash[:notice] = t("notice_block_type_updated")
        redirect_to block_types_path
      else
        render :edit
      end
    end

    def destroy
      authorize! :manage, Block
      @block_type = Block::Variant.find(params[:id])
      @block_type.destroy

      redirect_to block_types_path
    end

    private

      def form_params
        params.require(:block_variant).permit(:description, :name, :short_name, :color)
      end
  end
end
