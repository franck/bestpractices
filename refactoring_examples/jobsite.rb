class Jobsite
  attr_reader :contact

  def initialize(location, contact)
    @location = location
    @contact = contact
  end

  def contact_name
    if contact
      contact.name
    else
      'no name'
    end
  end

  def contact_phone
    if contact
      contact.phone
    else
      'no phone'
    end
  end

  def email_contact(email_body)
    if contact
      contact.deliver_personalized_email(email_body)
    end
  end

end

class Contact < OpenStruct
  def deliver_personalized_email(email)
    email.deliver(name)
  end
end

# Here we ask contact if it is nil. It's a Tell don't Ask violation.
# Use NullObject to correct that smell.


class Jobsite
  attr_reader :contact

  def initialize(location, contact)
    @location = location
    @contact = contact || NullContact.new
  end

  def contact_name
    'no name'
  end

  def contact_phone
    contact.phone
  end

  def email_contact(email_body)
    contact.deliver_personalized_email(email_body)
  end
end

class NullContact
  def name
    'no name'
  end

  def phone
    'no phone'
  end

  def deliver_personalized_email(body)
  end

end

class Contact < OpenStruct
  def deliver_personalized_email(email)
    email.deliver(name)
  end
end
