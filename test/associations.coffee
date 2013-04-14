Backbone = require 'backbone'
should = require 'should'
Factory = require '../src/factory-castrado'

class TestModel extends Backbone.Model
	create: (done) ->
		@id = @cid
		done()


Factory.define 'user-assoc',
	model: TestModel
	attributes:
		name: "David"
		password: "crap123"
	associations:
		community:
			factory: 'community-assoc'


Factory.define 'community-assoc',
	model: TestModel
	attributes:
		state: "California"
		country: "USA"


Factory.define 'post-assoc',

	model: TestModel
	attributes:
		title: "Test title"
	associations:
		community: 
			factory:'community-assoc'
		author: 
			factory:'user-assoc'



describe 'User with associations', ->
	beforeEach (done) -> 
		Factory.build 'user-assoc', (user) =>
			@user = user
			done()
	it 'should have association object', (done) ->
		user = @user
		user.community.should.be.ok
		user.community.get('country').should.eql('USA')
		done()
	it 'should have proper foreign key', (done) ->
		user = @user
		user.community.should.be.ok
		user.community.id.should.eql user.get('community_id')
		done()

describe 'User with associations', ->
	beforeEach (done) -> 
		Factory.build 'post-assoc', (post) =>
			@post = post
			done()
	it 'should have association objects', (done) ->
		post = @post
		post.community.should.be.ok
		post.community.get('country').should.eql('USA')

		post.author.should.be.ok
		post.author.get('name').should.eql "David"
		done()
	it 'should have proper foreign keys', (done) ->
		post = @post
		post.community.id.should.eql post.get('community_id')
		post.author.id.should.eql post.get('author_id')
		done()

describe 'Specifying association overrides', ->
	beforeEach (done) -> 
		Factory.create 'user-assoc', (user) =>
			@user = user
			done()

	describe "Post with only author specified", ->
		it 'should belong to the user', (done) ->
			Factory.build 'post-assoc', author:@user, (post) =>
				post.author.id.should.eql @user.id
				post.get('author_id').should.eql post.author.id

				post.community.should.not.eql @user.community
				done()
		it 'should NOT belong to the author\'s community', (done) ->
			Factory.build 'post-assoc', author:@user, (post) =>
				post.community.id.should.not.eql @user.community.id

				done()

	describe "Post with author and community specified", ->
		it 'should belong to the community', (done) ->
			Factory.build 'post-assoc', 
				author:@user
				community:@user.community
			, (post) =>
				c_id = post.get('community_id')
				c_id.should.eql post.author.get('community_id')
				c_id.should.eql post.author.community.id
				c_id.should.eql @user.get('community_id')
				c_id.should.eql @user.community.id

				done()
		it 'should belong to the user as well', (done) ->
			Factory.build 'post-assoc', 
				author:@user
				community:@user.community
			, (post) =>
				u_id = post.get('author_id')
				u_id.should.eql post.author.id
				u_id.should.eql @user.id
				
				done()