should = require 'should'
Factory = require './test-factories'

describe 'attributesFor', ->
	it "should return raw data object", (done) ->
		Factory.attributesFor 'user', (attrs) ->
			should.exist attrs.name
			done()

	it "should not include associations", (done) ->
		Factory.attributesFor 'user-assoc', (attrs) ->
			should.not.exist attrs.community
			done()
