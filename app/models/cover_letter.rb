class CoverLetter < ActiveRecord::Base
  include Filterable

  belongs_to :job_application
  has_one :contact, through: :interactions

  # scopes
  scope :sorted, -> { order(sent_date: :desc) }

  def job_application_title
    job_application.title if job_application
  end
end
