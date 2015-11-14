# Value Objects are simple objects whose equality is dependent on their value rather than an identity: 5$ == 5$ (not Object == Object but Object.value == Object.value) 
# Their identity is based on their state rather than on their object identity.
#
# This way, you can have multiple copies of the same conceptual value object.
# Every $5 note has its own identity (thanks to its serial number), but the cash economy relies on every $5 note having the same value as every other $5 note.
#
# So I can have multiple copies of an object that represents the date 16 Jan 1998.
# Any of these copies will be equal to each other. For a small object such as this, it is often easier to create new ones and move them around rather than rely on a single object to represent the date.
#
# Great when you have an attribute or small group of attributes that have logic associated with them.
# Anything more than basic text fields and counters are candidates for Value Object extraction.
#
# For example, a text messaging application I worked on had a PhoneNumber Value Object. An e-commerce application needs a Money class.

# source : http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/#service-objects)

class Rating
  include Comparable

  def self.from_cost(cost)
    if cost <= 2
      new("A")
    elsif cost <= 4
      new("B")
    elsif cost <= 8
      new("C")
    elsif cost <= 16
      new("D")
    else
      new("F")
    end
  end

  def initialize(letter)
    @letter = letter
  end

  def better_than?(other)
    self > other
  end

  def <=>(other)
    other.to_s <=> to_s
  end

  def hash
    @letter.hash
  end

  def eql?(other)
    to_s == other.to_s
  end

  def to_s
    @letter.to_s
  end
end

# Every ConstantSnapshot then exposes an instance of Rating in its public interface:
class ConstantSnapshot < ActiveRecord::Base
  # …

  def rating
    @rating ||= Rating.from_cost(cost)
  end
end


# Beyond slimming down the ConstantSnapshot class, this has a number of advantages:
# - The #worse_than? and #better_than? methods provide a more expressive way to compare ratings than Ruby’s built-in operators (e.g. < and >).
# - Defining #hash and #eql? makes it possible to use a Rating as a hash key. Code Climate uses this to idiomatically group constants by their ratings using Enumberable#group_by.
# - The #to_s method allows me to interpolate a Rating into a string (or template) without any extra work.
# - The class definition provides a convenient place for a factory method, returning the correct Rating for a given “remediation cost” (the estimated time it would take to fix all of the smells in a given class).
