should = require 'should'
Factory = require './test-factories'


basicTest = (factoryName) ->
	describe "Basic factory #{factoryName}", ->
		it 'should create a model', (done) ->
			# debugger
			Factory.build factoryName, (model) ->
				done()

		it 'should have name and password', (done) ->
			Factory.build factoryName, (model) ->
				model.get('name').should.eql "David"
				model.get('password').should.eql "crap123"
				done()

describe 'tests', ->
	basicTest 'user'
	basicTest 'user-extended'
	basicTest 'user-options'
	basicTest 'user-params'


