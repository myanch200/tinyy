class LinksController < ApplicationController
  protect_from_forgery with: :exception

  def new
    @link = Link.new
  end

  def create
    normalized = Link.normalize_url_str(link_params[:original_url])

    # Find existing by the normalized value, otherwise create new
    @link = Link.find_or_initialize_by(original_url: normalized)
    if @link.persisted? || @link.save
      redirect_to @link, notice: "Short link created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @link = Link.find(params[:id])
  end

  # GET /:slug
  def redirect
    link = Link.find_by(slug: params[:slug])
    return render plain: "Short link not found.", status: :not_found if link.nil?

    Link.increment_counter(:clicks, link.id)
    response.set_header("Cache-Control", "public, max-age=3600")
    redirect_to link.original_url, allow_other_host: true, status: :moved_permanently
  end

  private

  def link_params
    params.require(:link).permit(:original_url)
  end
end
