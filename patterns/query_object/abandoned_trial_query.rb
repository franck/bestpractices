# Query Object
#
# Each query object is responsible for returning a result set based on business rules.
# For example, a Query Object to find abandoned trials might look like this:

# source : http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/#service-objects)

class AbandonedTrialQuery
  def initialize(relation = Account.scoped)
    @relation = relation
  end

  def find_each(&block)
    @relation.
      where(plan: nil, invites_count: 0).
      find_each(&block)
  end
end

# in a background job to send emails:
AbandonedTrialQuery.new.find_each do |account|
  account.send_offer_for_support
end

# combine queries using composition:
old_accounts = Account.where("created_at < ?", 1.month.ago)
old_abandoned_trials = AbandonedTrialQuery.new(old_accounts)
