should = require 'should'
Factory = require './test-factories'


describe 'Error handling behavior', ->

	it 'should not throw error if #build given no callback', ->
		fn = ->
			Factory.build 'user'

		fn.should.not.throw()

	it 'should not throw error if #create given no callback', ->
		fn = ->
			Factory.create 'user'

		fn.should.not.throw()

	it 'should inform if non-existing factory specified', ->
		fn = ->
			Factory.create 'user!@3$4%', (thing) ->

		fn.should.throw(/cannot.*find/i)


describe "Error-first callback style", ->

	it "should support error-first style callbacks", (done) ->

		Factory.create 'user', (err, user) ->
			should.not.exist err
			user.should.be.ok
			done()

	it "should return an error when invalid factory specified", (done) ->

		Factory.create 'user*%#*#93', (err, user) ->
			should.exist err
			err.message.should.match /cannot.*find/
			done()