require 'weightedarray/version'

# Classes for managing Arrays with weighted elements.

# The purpose is to allow random selection (Array#sample) in
# a way that each element has a specified likelihood of
# occurring.

# Class for weighted elements which can go (get pushed) for
# example into a WeightedArray instance.
# A WeightedArray is represented by its value (an instance of any class)
# and a weight (an integer number, usually a Fixnum instance),
# where 1 is the base weight.
class WeightedElement

  # Value of this element. Can be an instance of any class.
  attr :value

  # Weight of this element. This is an integer representing the
  # importance of this element.
  attr :weight

  # Initialize a new instance.
  def initialize( value, weight = 1 )
    @value = value
    @weight = weight   
  end

end

# Class for lists of WeightedElements.
# When choosing elements at random (#sample) the likelihood for
# each element to get picked is derived from its importance, i.e.
# the value of its weight attribute.
class WeightedArray < Array

  # Initialize a new instance. If a data Hash is provided this
  # is taken to add an initial set of WeightedElements to this
  # WeightedArray. In that case the Hash keys are the values
  # to be added and the Hash values become the weight of this
  # value.
  def initialize( elements_hash = {} )
    super()
    elements_hash.each do |value, weight|
      self.push( WeightedElement.new(value, weight) )
    end
  end

  # Append a WeightedElement to this WeightedArray.
  # The argument sent to this method can be the WeightedArray
  # instance that should go into this WeightedArray. It can
  # also be any Object, in which case an instance of
  # WeightedElement gets created. In that case a second
  # argument represents the weight of this (defaults to 1).
  def push( what, weight = 1 )
    if (what.class == WeightedElement)
      super( what )
    else
      super( WeightedElement.new(what, weight) )
    end
  end

  # Return one WeightedElement's value from this WeightedArray,
  # selected at random. When choosing this element randomly, the
  # weights of the WeightedElements determine the likelihood of
  # getting picked, i.e. elements with a high weight will get
  # picked more often than those with a low likelihood.
  def sample()
    occurrence_weighted = Array.new
    self.each do |element|
      element.weight.times do
        occurrence_weighted.push( element )
      end
    end
    occurrence_weighted.sample.value
  end

end

