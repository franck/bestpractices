# The perform method must be as simple as possible :
# get the input parameters, fetch the necessary model objects, and delegate the important logic to something else.
class RecalculateAssessmentScoresJob < ActiveJob::Base
  queue_as :medium_priority

  def perform(category_id)
    assessments = Assessment.where(category_id: category_id)
    AssessmentScorer.score(assessments) do |assessment, score|
      logger.debug "Scored assessment #{ assessment.id } at #{ score }"
    end
  end
end

# Use a PORO to perform the important logoc
class AssessmentScorer
  def self.score(assessments)
    assessments.each do |assessment|
      score = calculate_score(assessment)
      assessment.score = score && assessment.save!
      yield assessment, score if block_given?
    end
  end

  private

  def self.calculate_score(assessment)
    # ...
  end
end

