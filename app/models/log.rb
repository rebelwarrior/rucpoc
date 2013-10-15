class Log < ActiveRecord::Base
  
  validates :collection_id, presence: true
  validates :user_id, presence: true
  validates :content, presence: true
  # default_scope -> { order('created_at DESC')} #newest first  
  default_scope -> { order('created_at ASC')} #newest last
  belongs_to :collection
  belongs_to :user
  has_one :debtor, through: :collection
  
end
