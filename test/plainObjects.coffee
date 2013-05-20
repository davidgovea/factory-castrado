should = require 'should'
Factory = require './test-factories'


describe 'Plain object constructors', ->
	beforeEach (done) -> 
		Factory.build 'plainUser', (obj) =>
			@obj = obj
			done()
	it 'should have shimmed .get method', ->
		@obj.get.should.be.a('function')
		@obj.get('name').should.be.ok

	it 'should have shimmed .set key', ->
		@obj.set.should.be.a('function')
		@obj.set('prop', 'test')
		@obj.prop.should.eql 'test'

describe "Extended plain factores", ->
	beforeEach (done) -> 
		Factory.build 'plainUser-extended', (obj) =>
			@obj = obj
			done()

	it "should have inherited property", ->
		@obj.extended.should.eql true

	describe "with a .set method specified", ->
		it "should not overwrite the setter", ->
			@obj.set('prop', 'test').should.match /override/
			should.not.exist @obj.prop

describe "Plain object with associatons", ->
	beforeEach (done) -> 
		Factory.build 'plainUser-assoc', (obj) =>
			@obj = obj
			done()

	it 'should have association objects', ->
		obj = @obj
		obj.community.should.be.ok
		obj.community.get('country').should.eql('USA')

	it 'should have proper foreign keys', ->
		obj = @obj
		obj.community.id.should.eql obj.get('community_id')
