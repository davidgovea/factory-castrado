should = require 'should'
Factory = require './test-factories'

get = (obj, key) ->
	if typeof obj.get is 'function' then obj.get(key) else obj[key]

basicTest = (factoryName) ->
	describe "Basic factory #{factoryName}", ->
		it 'should create a model', (done) ->
			# debugger
			Factory.build factoryName, (model) ->
				done()

		it 'should have name and password', (done) ->
			Factory.build factoryName, (model) ->
				get(model, 'name').should.eql "David"
				get(model, 'password').should.eql "crap123"
				done()

describe 'tests', ->
	basicTest 'plain'
	basicTest 'plain-extended'
	basicTest 'user'
	basicTest 'user-extended'
	basicTest 'user-options'
	basicTest 'user-params'


