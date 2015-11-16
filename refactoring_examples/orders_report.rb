# Ben Orenstein
# source : https://www.youtube.com/watch?v=DC-pQPq0acs
#

#######################################################################################
# Original Code
#######################################################################################
class OrderReports
  def initialize(orders, start_date, end_date)
    @orders = orders
    @start_date = start_date
    @end_date = end_date
  end

  def total_sales_within_date_range
    orders_within_range = @orders.select{|order| order.placed_at >= @start_date && order.placed_at <= @end_date }
    orders_within_range.map(&:amount).inject(0){|sum, amount| amount + sum }
  end
end

def Order < Struct
end

#######################################################################################
# Extract method : 
# cleaner
# can reuse orders_within_range
#######################################################################################
class OrderReports
  def initialize(orders, start_date, end_date)
    @orders = orders
    @start_date = start_date
    @end_date = end_date
  end

  def total_sales_within_date_range
    orders_within_range.map(&:amount).inject(0){|sum, amount| amount + sum }
  end

  private

  def orders_within_range 
    @orders.select{|order| order.placed_at >= @start_date && order.placed_at <= @end_date }
  end
end

#######################################################################################
# Tell don't Ask
# => Code Small Feature Envy : my class envy what other class knows
# Here we know to much about order internals
#######################################################################################
class OrderReports
  def initialize(orders, start_date, end_date)
    @orders = orders
    @start_date = start_date
    @end_date = end_date
  end

  def total_sales_within_date_range
    orders_within_range.map(&:amount).inject(0){|sum, amount| amount + sum }
  end

  private

  def orders_within_range 
    @orders.select{|order| order.placed_between?(@start_date, @end_date) }
  end
end

def Order < OpenStruct
  def placed_between?(start_date, end_date)
    placed_at >= start_date && placed_at <= end_date
  end
end


#######################################################################################
# Data clump
# when you start to use data together everwhere : start_date, end_date
# Those data will always work together : start_date without end_date does not make any sense
# - It's more explicit
# - We reduce couplng (less arguments: 3 to 2)
#######################################################################################
class OrderReports
  def initialize(orders, date_range)
    @orders = orders
    @date_range = date_range
  end

  def total_sales_within_date_range
    orders_within_range.map(&:amount).inject(0){|sum, amount| amount + sum }
  end

  private

  def orders_within_range 
    @orders.select{|order| order.placed_between?(@date_range) }
  end
end

class DateRange < Struct.new(:start_date, :end_date); end

def Order < OpenStruct
  def placed_between?(date_range)
    placed_at >= date_range.start_date && placed_at <= date_range.end_date
  end
end

#######################################################################################
# Move code responsability where it belongs 
# Should Order be responsible of checking a value is between a range ? NO
# It should be DateRange responsability
#######################################################################################
class OrderReports
  def initialize(orders, date_range)
    @orders = orders
    @date_range = date_range
  end

  def total_sales_within_date_range
    orders_within_range.map(&:amount).inject(0){|sum, amount| amount + sum }
  end

  private

  def orders_within_range 
    @orders.select{|order| order.placed_between?(@date_range) }
  end
end

class DateRange < Struct.new(:start_date, :end_date)
  def include?(date)
    # date >= date_range.start_date && date <= date_range.end_date
    
    # user cover? not include? because include? instanciate everything in between. That's not the case with cover?
    (start_date..end_date).cover?(date)
  end
end

def Order < OpenStruct
  def placed_between?(date_range)
    date_range.include?(placed_at)
  end
end

#######################################################################################
# Make it read like you would say it
#
#######################################################################################
class OrderReports
  def initialize(orders, date_range)
    @orders = orders
    @date_range = date_range
  end

  def total_sales_within_date_range
    total_sales(orders_within_range)
  end

  private

  def total_sales(orders)
    #orders.map(&:amount).inject(0){|sum, amount| amount + sum }

    # ruby is magic !
    orders.map(&:amount).inject(0, :+)
  end

  def orders_within_range 
    @orders.select{|order| order.placed_between?(@date_range) }
  end
end

class DateRange < Struct.new(:start_date, :end_date)
  def include?(date)
    (start_date..end_date).cover?(date)
  end
end

def Order < OpenStruct
  def placed_between?(date_range)
    date_range.include?(placed_at)
  end
end
