class Task < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :assignee, class_name: 'User', optional: true
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 500 }
  validates :author, presence: true

  state_machine initial: :new_task do
    event :to_develompment do
      transition [:new_task, :in_qa, :in_code_rewiev] => :in_development
    end

    event :to_archived do
      transition [:new_task, :released] => :archived
    end

    event :to_qa do
      transition in_development: :in_qa
    end

    event :to_code_rewiev do
      transition in_qa: :in_code_rewiev
    end

    event :to_ready_for_release do
      transition in_code_rewiev: :ready_for_release
    end

    event :to_released do
      transition ready_for_release: :released
    end
  end
end
