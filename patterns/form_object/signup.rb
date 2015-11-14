# Form Object
# A common example would be a signup form that results in the creation of both a Company and a User
#
# This works well for simple cases like the above, but if the persistence logic in the form gets too complex you can combine this approach with a Service Object.
# As a bonus, since validation logic is often contextual, it can be defined in the place exactly where it matters instead of needing to guard validations in the ActiveRecord itself.

# source : http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/#service-objects)

class Signup
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :user
  attr_reader :company

  attribute :name, String
  attribute :company_name, String
  attribute :email, String

  validates :email, presence: true
  # … more validations …

  # Forms are never themselves persisted
  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

private

  def persist!
    @company = Company.create!(name: company_name)
    @user = @company.users.create!(name: name, email: email)
  end
end

# Use Virtus in these objects to get ActiveRecord-like attribute functionality.
# The Form Object quacks like an ActiveRecord, so the controller remains familiar:

class SignupsController < ApplicationController
  def create
    @signup = Signup.new(params[:signup])

    if @signup.save
      redirect_to dashboard_path
    else
      render "new"
    end
  end
end
