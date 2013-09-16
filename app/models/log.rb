class Log < ActiveRecord::Base
  belongs_to :collection
  validates :collection_id, presence: true
  belongs_to :user
  validates :user_id, presence: true
  # default_scope -> { order('created_at DESC')} #newest first  
  default_scope -> { order('created_at ASC')} #newest last
  has_one :debtor, through: :collection
  
end
