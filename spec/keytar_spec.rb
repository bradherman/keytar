require File.dirname(__FILE__) + '/spec_helper'

describe "keytar" do
	before(:all) do
    @keytar = Redis::Keytar.new(:namespace => "api:articles",:ttl => 1000)
  end

  context 'when creating a keytar instance' do
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
  end

  context 'when setting a key' do
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

  context 'when deleting a key' do
    before(:each) do
      @keytar.set 'my_key', true
    end
    
    it 'should delete the value' do
      Redis.current.get("api:articles:my_key").should_not be_nil
      @keytar.del 'my_key'
      Redis.current.get("api:articles:my_key").should be_nil
    end

    it 'should remove the key from the set of keys' do
      Redis.current.smembers("api:articles:keys").should include("api:articles:my_key")
      @keytar.del 'my_key'
      Redis.current.smembers("api:articles:keys").should_not include("api:articles:my_key")
    end
  end

  context 'when clearing' do
    before(:each) do
      @keytar.set 'my_key1', true
      @keytar.set 'my_key2', true
      @keytar.set 'my_key3', true
    end

    it 'should delete each of the keys' do
      Redis.current.get('api:articles:my_key1').should_not be_nil
      Redis.current.get('api:articles:my_key2').should_not be_nil
      Redis.current.get('api:articles:my_key3').should_not be_nil
      @keytar.clear
      Redis.current.get('api:articles:my_key1').should be_nil
      Redis.current.get('api:articles:my_key2').should be_nil
      Redis.current.get('api:articles:my_key3').should be_nil
    end

    it 'should clear the keys set' do
      Redis.current.smembers("api:articles:keys").empty?.should == false
      @keytar.clear
      Redis.current.smembers("api:articles:keys").empty?.should == true
    end
  end
end