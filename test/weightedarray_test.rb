# encoding: utf-8

require 'test/unit'
$:.push(File.join('..', 'lib'))
require 'weightedarray'

class WeightedArrayTest < Test::Unit::TestCase

  def setup
    @wa = WeightedArray.new(['Anton', 'Berti', 'Conni'])
    begin
      $stderr = File.open('/tmmp/weightedarraytestoutput.txt', 'w')
    rescue
    end
  end

  def test_initialize
    assert_equal( 'Berti', @wa[1] )
    assert_equal( 1, @wa.weight_of('Berti') )
  end

  def test_change_weight
    @wa.upgrade('Anton')
    assert_equal( 2, @wa.weight['Anton'] )
    @wa.upgrade('Berti', 9)
    assert_equal( 10, @wa.weight['Berti'] )
  end

  def test_push
    @wa.push( 'Det', 100 )
    assert_equal( 4, @wa.length )
    assert_raise(InvalidWeightError) { @wa.push('Fritzchen', -3) }
    $stderr.puts('Ignore the following warning when testing:')
    assert_nothing_raised { @wa.push('Edi', 10.5) }
    assert_equal(11, @wa.weight_of('Edi'))
  end

end

