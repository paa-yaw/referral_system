class JobDescription < ActiveRecord::Base
  belongs_to :company

  validates :job_title, :experience, :min_salary, :max_salary, :vacancies, presence: true

  def updated?
  	return true if self.update_button?
  end
end