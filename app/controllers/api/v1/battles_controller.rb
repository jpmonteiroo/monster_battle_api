class Api::V1::BattlesController < ApplicationController
  def create
    result = Battles::CreateBattleService.call(params[:monsterA_id], params[:monsterB_id])

    if result.success
      render json: {
        battle_id: result.battle.id,
        winner: {
          id: result.battle.winner_id,
          name: result.battle.winner_name
        }
      }, status: :created
    else
      render json: { error: result.error }, status: result.status
    end
  end

  def destroy
    battle = Battle.find_by(id: params[:id])

    if battle
      battle.destroy
      render json: { message: 'Battle deleted successfully' }, status: :ok
    else
      render json: { error: 'Battle not found' }, status: :not_found
    end
  end
end
