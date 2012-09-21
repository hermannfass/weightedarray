weightedarray
=============

Ruby Arrays that allow to define a likelihood for ramdom picking of elements.

## Installation

Add this line to your application's Gemfile:

    gem 'weightedarray'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install weightedarray

## Usage

    require 'weightedarray'
    names = WeightedArray.new(
      { 'Anton'=>1, 'Berti'=>1, 'Conny'=>1, 'Det'=>3, 'Edi'=>1 }
    )
    names.push( {'Fritzchen', 10} )
    # The following prints 10 times more likely 'Fritzchen' than 'Anton'.
    puts names.sample
    names.upgrade('Anton', 7)
    # Now the following prints 'Det' as likely as 'Fritzchen': Both now
    # have now a likelihood of 10, thus are 10 times more likely than 'Berti'.
    puts names.sample

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

