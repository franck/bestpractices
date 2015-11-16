class User
  SUBSCRIPTION_AMOUNT = 10.to_money

  def charge_for_subscription
    braintree_id = BraintreeGem.find_user(email).braintree_id
    BraintreeGem.charge(braintree_id, SUBSCRIPTION_AMOUNT)
  end

  def create_as_customer
    BraintreeGem.create_customer(email)
  end
end

class Refund

  def proccess!
    transaction_id = BraintreeGem.find_transaction(order.braintree_id)
    BraintreeGem.refund(transaction_id, amount)
  end

end


########################################################################
# Add a level of abstraction :
# - what if we change our payment processer ?
#
########################################################################

class PaymentGateway
  SUBSCRIPTION_AMOUNT = 10.to_money
   def initialize(gateway = BraintreeGem)
     @gateway = gateway
   end

  def charge_for_subscription(user)
    braintree_id = @gateway.find_user(user.email).braintree_id
    @gateway.charge(braintree_id, SUBSCRIPTION_AMOUNT)
  end

  def create_as_customer(user)
    @gateway.create_customer(user.email)
  end

  def refund(refund_model)
    transaction_id = @gateway.find_transaction(order.braintree_id)
    @gateway.refund(transaction_id, amount)
  end
end

class User
  def charge_for_subscription
    PaymentGateway.new.charge_for_subscription(self)
  end

  def create_as_customer
    PaymentGateway.new.create_as_customer(self)
  end
end

class Refund
  def proccess!
    PaymentGateway.new.refund(self)
  end
end
