should = require 'should'
Factory = require './test-factories'


describe 'Custom function factories: message btw 2 users', ->
	beforeEach (done) -> 
		Factory.build 'message between two users', (msg, user1, user2) =>
			@msg = msg
			@user1 = user1
			@user2 = user2
			done()

	it 'should create multiple models', (done) ->
		@msg.should.be.ok
		@user1.should.be.ok
		@user2.should.be.ok
		done()

	it 'should have proper user_ids array', (done) ->
		user_ids = @msg.get 'user_ids'
		(@user1.id in user_ids).should.be.true
		(@user2.id in user_ids).should.be.true
		user_ids.length.should.eql 2
		done()

	it 'should properly create external associations', (done) ->
		@msg.community.id.should.eql @user1.community.id
		@msg.community.id.should.eql @user2.community.id
		@msg.get('community_id').should.eql @user1.get('community_id')
		done()