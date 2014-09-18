require 'kanban/card'
require 'rails_helper'

RSpec.describe TaskMetric, :type => :model do
  context '#from' do
    let(:card) do
      card = Kanban::Card.new
      card.id = 123
      card.external_card_id = 12345
      card.title = 'my card title'
      card.size = 4
      card.last_move = Time.now
      card
    end

    it 'loads fields from our Kanban Card wrapper' do
      metric = TaskMetric.from(card)
      expect(metric.leankit_id).to eq(card.id)
      expect(metric.fog_bugz_id).to eq(card.external_card_id)
      expect(metric.title).to eq(card.title)
      expect(metric.estimate).to eq(card.size)
      expect(metric.done_at).to eq(card.last_move)
    end
  end

  context '#missing' do
    let(:card) { Kanban::Card.new(:id => 123) }

    it 'is missing' do
      TaskMetric.delete_all(:leankit_id => 123)
      expect(TaskMetric.missing?(card)).to eq(true)
    end

    it 'is not missing' do
      TaskMetric.create!(:leankit_id => 123)
      expect(TaskMetric.missing?(card)).to eq(false)
    end
  end
end
