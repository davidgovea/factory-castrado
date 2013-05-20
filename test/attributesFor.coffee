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

	describe "For non-backbone object", ->
		it "should return data for plain models", (done) ->
			Factory.attributesFor 'plainUser-extended', (attrs) ->
				attrs.name.should.be.ok
				done()