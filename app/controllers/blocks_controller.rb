class BlocksController < ApplicationController
  def index
  end

  def new
    @block = Block.new
  end
end
