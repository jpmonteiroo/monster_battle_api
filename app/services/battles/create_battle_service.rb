# frozen_string_literal: true

module Battles
  class CreateBattleService
    Result = Struct.new(:success, :battle, :error, :status)

    def self.call(monster_a_id, monster_b_id)
      if monster_a_id.blank? || monster_b_id.blank?
        return Result.new(success: false, battle: nil, error: 'Monster IDs cannot be blank',
                          status: :bad_request)
      end

      monster_a = Monster.find_by(id: monster_a_id)
      monster_b = Monster.find_by(id: monster_b_id)

      unless monster_a && monster_b
        return Result.new(success: false, battle: nil, error: 'One or both monsters do not exist',
                          status: :bad_request)
      end

      winner = Battles::BattlesService.fight(monster_a, monster_b)
      battle = Battle.create(monsterA_id: monster_a.id, monsterB_id: monster_b.id,
                            winner_id: winner.id)

      if battle.persisted?
        Result.new(success: true, battle: battle, error: nil, status: :created)
      else
        Result.new(success: false, battle: nil, error: 'Failed to create battle',
                  status: :internal_server_error)
      end
    end
  end
end
