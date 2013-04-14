Backbone = require 'backbone'
should = require 'should'
Factory = require '../src/factory-castrado'

Factory.define 'user',
	model: Backbone.Model
	attributes:
		name: "David"
		password: "crap123"

Factory.define 'user-extended',
	extends: 'user'
	attributes:
		extended: true

Factory.define
	name: 'user-options'
	extends: 'user'
	attributes:
		extended: true

Factory.define 'user-params',
	extends: 'user'
,
	extended: true


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


