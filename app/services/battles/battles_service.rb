# frozen_string_literal: true

module Battles
  class BattlesService
    def self.fight(monster_a, monster_b)
      new(monster_a, monster_b).fight
    end

    def initialize(monster_a, monster_b)
      @original_monster_a = monster_a
      @original_monster_b = monster_b

      @a = monster_a.dup
      @b = monster_b.dup

      @attacker, @defender = determine_first_attacker(@a, @b)
    end

    def fight
      loop do
        apply_damage

        return winner if defender_defeated?

        switch_turns
      end
    end

    private

    attr_reader :a, :b, :attacker, :defender

    def determine_first_attacker(monster1, monster2)
      if monster1.speed > monster2.speed
        [monster1, monster2]
      elsif monster2.speed > monster1.speed
        [monster2, monster1]
      elsif monster1.attack >= monster2.attack
        [monster1, monster2]
      else
        [monster2, monster1]
      end
    end

    def apply_damage
      damage = [attacker.attack - defender.defense, 1].max
      defender.hp -= damage
    end

    def defender_defeated?
      defender.hp <= 0
    end

    def winner
      defender == a ? @original_monster_b : @original_monster_a
    end

    def switch_turns
      @attacker, @defender = @defender, @attacker
    end
  end
end
