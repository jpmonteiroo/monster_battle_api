class Api::V1::MonstersController < ApplicationController
  def index
    monster = Monster.all
    render json: { data: monster }, status: :ok
  end

  def create
    monster = Monsters::CreateMonster.new(params: monster_params).call
    render json: { data: monster }, status: :created
  rescue StandardError => e
    render_error("Failed to create monster: #{e.message}", :unprocessable_entity)
  end

  def destroy
    monster = Monster.find_by(id: params[:id])

    if monster
      monster.destroy
      render json: { message: 'Monster deleted successfully' }, status: :ok
    else
      render_error('Monster not found', :not_found)
    end
  rescue StandardError => e
    render_error("Failed to delete monster: #{e.message}", :unprocessable_entity)
  end

  def import
    return render_error('File not provided', :bad_request) unless params[:file].present?

    begin
      Monsters::ImportMonstersService.new(file: params[:file]).call
      render json: { message: 'Monsters imported successfully' }, status: :created
    rescue StandardError => e
      render_error("Failed to import monsters: #{e.message}", :unprocessable_entity)
    end
  end

  private

  def monster_params
    params.require(:monster).permit(:name, :attack, :defense, :hp, :speed, :imageUrl)
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end
