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
    if (new_weight = validated_weight_value(weight) )
      super(what)
      @weight[what] = new_weight
    end
  end

  def validated_weight_value( weight )
    if ( weight.kind_of?(Integer) )
      if (weight > 0)
        weight
      elsif (weight == 0)
        $stderr.puts "Warning: A weight of 0 does not " <<
                     "seem very useful, but is accepted."
        weight
      elsif (weight < 0)
        raise InvalidWeightError,
              "A negative weight of #{weight} is not possible."
        false
      end
    elsif ( weight.kind_of?(Numeric) )
      $stderr.puts "Warning: Weight #{weight} is not an integer number. " <<
                   "Rounding it to #{weight.round}."
      weight.round
    else
      raise InvalidWeightError,
            "The weight of an element must be a positive, numeric value."
      false
    end
  end

  alias :<< :push

  # Return a random element from the WeightedArray, giving each
  # element the likelihood of getting picked represented by its weight.
  #--
  # To do: This looks quite expensive.
  #++
  def sample()
    weighted_list = Array.new
    @weight.each do |elm, w|
      w.times do
        weighted_list.push(elm)
      end
    end
    weighted_list.sample
  end

  # Change the weight of an element. Selects elements that match the
  # element specified in the first argument, utilizing the == operator
  # for comparison. The weight of the matching elements is incremented by
  # the (positive or negative) amount provided as second argument.
  def set_weight( element_to_grade, weight )
    self.select{|element| element == element_to_grade}.each do |elm|
      @weight[elm] = validated_weight_value(weight)
    end
  end

  # Increase the weight of an element; by default by 1.
  def upgrade( element, inc = 1 )
    new_weight = weight_of(element) + inc
    set_weight( element, new_weight )
  end

  # Decrease the weight of an element; by default by 1.
  def downgrade( element, dec = 1 )
    new_weight = weight_of(element) - dec
    begin
      if ( new_weight < 0 )
        raise InvalidWeightError,
              "Trying to downgrade an element to a negative weight "
              "(#{weight_of(element)-dec}). Element: #{element.to_s}"
      end
      set_weight(element, new_weight)
    rescue InvalidWeightError => e
      $stderr.puts "Warning: #{e.message} Weight set to 0."
      set_weight(element, 0)
    end
  end

  # Return the weight of an element.
  # If the weight of an element has not yet been set this will return
  # a value of 1.
  def weight_of( element )
    @weight[element] || 1
  end

  def debug_info()
    self.collect{|elm| "#{elm}: #{@weight[elm]}"}.join("\n")
  end

end

