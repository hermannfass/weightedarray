require 'pp'
$:.push( File.dirname(__FILE__) )
require 'weightedarray/version'

# Classes for managing Arrays with weighted elements.

# The purpose is to allow random selection (Array#sample) in
# a way that each element has a specified likelihood of
# occurring.

# Exception raised when an operation would result in a negative
# weight of an element.
class InvalidWeightError < StandardError
end

# Class representing an Array of elements with additional random
# selection support: The elements do have a weight assigned that
# determines the likelihood of each to be picked by the sample()
# method. The weight is a positive integer number. 
# The absolute value has no specific meaning; the weight is relative to
# other elements: An element with a weight of 10 has twice the
# likelihood of being chosen than one with a weight of 5.
class WeightedArray < Array

  # Hash with each element as key and the respective weight as value.
  attr_accessor :weight

  # Initialize a new instance. 
  # If the data sent to the constructor is a Hash it is assume that
  # it shows the elements as keys and their likelihood as value.
  # When an Array is sent this is interpreted as list elements,
  # each of which gets a weight of 1 assigned.
  def initialize( data = nil )
    @weight = {}
    if ( data.kind_of?(Hash) )
      data.each do |element, weight|
        push(element, weight)
      end
    elsif ( data.kind_of?(Array) )
      self.replace(data)
      data.each { |d| @weight[d] = 1 }
    elsif ( data.nil? )
    else
      self.replace([data])
      @weight[data] = 1
    end
  end

  # Append an element.
  # The second argument represents the weight of this element.
  def push( what, weight = 1 )
    if ( weight.kind_of?(Integer) )
      if (weight > 0)
        super(what)
        @weight[what] = weight
      elsif (weight == 0)
        super(what)
        $stderr.puts "Warning: Adding an element with weight 0 does not" <<
                     "seem very useful, but is accepted."
        @weight[what] = weight
      elsif (weight < 0)
        raise InvalidWeightError,
              "Trying to assign a negative weight of #{weight} to " +
              "element #{what.to_s}"
      end
    elsif ( weight.kind_of?(Numeric) )
      $stderr.puts "Warning: Weight #{weight} is not an integer number. " <<
                   "Rounding it to #{weight.round}."
      push(what, weight.round)
    else
      raise InvalidWeightError,
            "When pushing an element to a WeightedArray the weight, if " <<
            "provided, needs to be a positive numeric value."
    end
  end

  alias :<< :push

  # Return a random element from the WeightedArray, giving each
  # element the likelihood of getting picked represented by its weight.
  def sample()
    weighted_list = Array.new
    self.each do |element, weight|
      weight.times { weighted_list.push(element) }
    end
    weighted_list.sample
  end

  # Change the weight of an element. Selects elements that match the
  # element specified in the first argument, utilizing the == operator
  # for comparison. The weight of the matching elements is incremented by
  # the (positive or negative) amount provided as second argument.
  def change_weight( element_to_grade, inc = 0 )
    self.select{|element| element == element_to_grade}.each do |elm|
      @weight[elm] = weight_of(elm) + inc
    end
  end

  # Increase the weight of an element; by default by 1.
  def upgrade( element, inc = 1 )
    change_weight( element, inc )
  end

  # Decrease the weight of an element; by default by 1.
  def downgrade( element, dec = 1 )
    begin
      if ( weight_of(element) < dec )
        raise InvalidWeightError,
              "Trying to downgrade an element to a negative weight "
              "(#{weight_of(element)-dec}). Element: #{element.to_s}"
      end
      change_weight(element, -dec)
    rescue InvalidWeightError => e
      $stderr.puts "Warning: #{e.message} Weight set to 0."
      @weight[element] = 0
    end
  end

  # Return the weight of an element.
  # If the weight of an element has not yet been set this will return
  # a value of 1.
  def weight_of( element )
    @weight[element] || 1
  end

  def debug_output()
    self.collect{|elm| "#{elm}: #{@weight[elm]}"}.join("\n")
  end

end

a = WeightedArray.new
a.push("eins", 10)
a.push("zwei", 10.5)
a.push("drei", 0)
a.downgrade("drei")

puts a.debug_output


