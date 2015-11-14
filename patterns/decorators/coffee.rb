# Decorator PORO Style
# 
# The benefits of this implementation are:
# - can be wrapped infinitely using Ruby instantiation
# - delegates through all decorators
# - can use same decorator more than once on component
# 
# The drawbacks of this implementation are:
# - cannot transparently use component’s original interface
# 
# This drawback also means that this decorator isn’t really a decorator under the Gang of Four definition. I maintain that we should still call it a decorator, however, because it otherwise looks and acts overwhelmingly like a decorator.

# source : https://robots.thoughtbot.com/evaluating-alternative-decorator-implementations-in

class Coffee
  def cost
    2
  end

  def origin
    "Colombia"
  end
end

class Milk
  def initialize(component)
    @component = component
  end

  def cost
    @component.cost + 0.4
  end
end

coffee = Coffee.new
Sugar.new(Milk.new(coffee)).cost  # 2.6
Sugar.new(Sugar.new(coffee)).cost # 2.4
Sugar.new(Milk.new(coffee)).class # Sugar
Milk.new(coffee).origin           # NoMethodError
