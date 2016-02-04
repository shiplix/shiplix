class BlocksController < ApplicationController
  include CurrentBuildable

  def index
    authorize current_repo, :show?
    
    title_variables[:repo] = current_repo.full_name

    return unless current_build
    @blocks = current_build.
                blocks.
                where("blocks.type = ? or blocks.smells_count > 0", Blocks::Namespace).
                order("blocks.rating desc, blocks.smells_count desc").
                paginate(page: params[:page], per_page: 20)
  end
end
