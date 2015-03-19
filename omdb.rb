require 'json'
require 'open-uri'
require 'rspec'

module OMDB
  class Search
    def self.by_movie_name(movie_name)
      JSON.parse(open("http://www.omdbapi.com/?t=#{movie_name}").read)
    end
  end

  class Movie
    attr_reader :data, :actors

    def initialize(data)
      @data = data
      @actors = init_actors
    end

    private

    def init_actors
      actors = data['Actors']
      if actors.nil?
        'Sorry we could not find actors for the movie.'
      else
        actors
      end
    end
  end
end

# puts OMDB::Movie.new(OMDB::Search.by_movie_name('ghostbusters')).actors

RSpec.describe OMDB::Movie do
  subject(:movie) { OMDB::Movie.new(data) }

  describe '#actors' do
    describe 'given data with actors' do
      let(:data) {
        {'Actors' => 'Bill Murray, Dan Aykroyd, Sigourney Weaver, Harold Ramis'}
      }

      it 'returns list of actor names' do
        expect(movie.actors).
          to eq('Bill Murray, Dan Aykroyd, Sigourney Weaver, Harold Ramis')
      end
    end

    describe 'given data without actors' do
      let(:data) { {} }

      it 'returns unsucessful search message' do
        expect(movie.actors).
          to eq('Sorry we could not find actors for the movie.')
      end
    end
  end
end


