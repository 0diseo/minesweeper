# frozen_string_literal: true

class MineBoardAdapter
  attr_reader :store
  def initialize(store = ::MineBoard)
    @store = store
  end

  def create(params)
    store.create(params)
  end

  def find(id)
    store.find(id)
  end
end