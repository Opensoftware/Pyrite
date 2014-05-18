module Pyrite
  class Block::TypesController < PyriteController

    def index
      @block_types = Block::Variant.all
    end

    def new
      @block_type = Block::Variant.new
    end

    def edit
      @block_type = Block::Variant.find(params[:id])
    end

    def create
      @block_type = Block::Variant.new(form_params)

      if @block_type.save
        flash[:notice] = t("notice_block_type_created")
        redirect_to block_types_path
      else
        render :new
      end
    end

    def update
      @block_type = Block::Variant.find(params[:id])

      if @block_type.update_attributes(form_params)
        flash[:notice] = t("notice_block_type_updated")
        redirect_to block_types_path
      else
        render :edit
      end
    end

    def destroy
      @block_type = Block::Variant.find(params[:id])
      @block_type.destroy

      redirect_to block_types_url
    end

    private

      def form_params
        params.require(:block_variant).permit(:description, :name, :short_name, :color)
      end
  end
end
