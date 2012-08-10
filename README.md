weightedarray
=============

Arrays that allow to define a likelihood for ramdom picking of elements.

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
      { 'Anton'=>1, 'Berti'=>1, 'Conny'=>1, 'Det'=>5, 'Edi'=>1 }
    )
    names.push( {'Fritzchen'=>10} )
    # In the following the name "Fritzchen" will be shown
    # with a likelihood of 10:1 compared to Anton's and
    # with a likelihood of 2:1 compared to Det's:
    puts names.sample 
    

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## To do

   WeightedArray#<<()
   WeightedArray.new( <Array> ) # with default likelihood
   WeightedArray#to_s()         # to list key values only
