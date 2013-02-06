require File.dirname(__FILE__) + '/spec_helper'

describe "keytar" do
	before(:all) do
    @keytar = Redis::Keytar.new(:namespace => "api:articles",:ttl => 1000)
  end

  it 'should have a namespace' do
  	@keytar.redis.should_not be_nil
  	@keytar.redis.should == Redis.current
  end

  it 'should have a ttl' do
  	@keytar.namespace.should_not be_nil
  	@keytar.namespace.should == "api:articles"
  end

  it 'should have a redis' do
  	@keytar.ttl.should_not be_nil
  	@keytar.ttl.should == 1000
  end

  it 'should set a key' do
    @keytar.set 'my_key', true
    Redis.current.get("api:articles:my_key").should == "true"
  end

  it 'should create a set of keys' do
    @keytar.set 'my_key1', true
    @keytar.set 'my_key2', true
    keys = Redis.current.smembers("api:articles:keys")
    keys.should_not be_nil
    keys.should include("api:articles:my_key1")
    keys.should include("api:articles:my_key2")
  end
end