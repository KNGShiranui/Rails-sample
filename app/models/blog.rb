class Blog < ApplicationRecord
  validates :title, presence: true
  #validates :title, presence: trueのように記述すると、「titleという値を確認し、ブランクであった場合は違反状態の値とみなして保存を中止します」という処理を実装できる。
end
