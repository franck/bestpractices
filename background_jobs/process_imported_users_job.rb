# This Background job has the following responsabilities :
# - Fetching the model that contains the CSV data to be imported based on the input parameter
# - Delegating responsibility for the actual bulk loading process to the UserBulkLoader class
# - Handling and logging the newly created records along with any errors
# - Sending an email after the job finishes notification with the results
# - Notifying the admin in case the job failed due to bad inputs
# 
class ProcessImportedUsersJob < ActiveJob::Base
  queue_as :medium_priority

  def perform(import_id)
    user_import = UserImport.find(import_id)
    csv = user_import.user_data

    users, errors = UserBulkLoader.load(csv) do |user|
      logger.debug "Created new user account: #{ user.login }"
    end

    UserImportsMailer.import_completed(user_import, users, errors).deliver_now
  rescue ActiveRecord::RecordNotFound, CSV::MalformedCSVError => e
    UserImportsMailer.import_failed(user_import, e).deliver_now
  end
end

# In cases where we want to handle an exception by retrying the job, we can do that at the level of the class by including a rescue_from block like the one shown below.
class ProcessImportedUsersJob < ActiveJob::Base
  queue_as :medium_priority

  rescue_from(ActiveRecord::ConnectionNotEstablished) do
    retry_job wait: 60.seconds, queue: :low_priority
  end

  # ...
end
