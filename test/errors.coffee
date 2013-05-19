should = require 'should'
Factory = require './test-factories'


describe 'Error handling behavior', ->

	it 'should throw error if given no callback', ->
		fn = ->
			Factory.build 'user'

		fn.should.throw(/callback/i)

	it 'should inform if non-existing factory specified', ->
		fn = ->
			Factory.create 'user!@3$4%', (thing) ->

		fn.should.throw(/cannot.*find/i)