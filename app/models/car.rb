class Car < ApplicationRecord
  attr_accessor :rank_score, :label

  belongs_to :brand

  LABEL_ORDER = {
    'perfect_match' => 0,
    'good_match' => 1
  }.freeze

  def label_comparable
    LABEL_ORDER.fetch(label, 9999)
  end

  def rank_score_comparable
    rank_score || 0
  end
end
