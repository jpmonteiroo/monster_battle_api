module Monsters
  class CreateMonster
    def initialize(params:)
      @params = params
    end

    def call
      Monster.create!(@params)
    end
  end
end
