# encoding: utf-8

require 'test/unit'
$:.push(File.join('..', 'lib'))
require 'weightedarray'

class WeightedarrayTest < Test::Unit::TestCase

  def setup
  end

  def test_constructor
    wa = WeightedArray.new( 'Anton'=>1, 'Berti'=>5, 'Conny'=>10 )
    assert_equal( 5, wa[1].weight )
  end

end

