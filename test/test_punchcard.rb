require 'helper'

class TestPunchcard < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Punchcard::App
  end
  
  context "With 3 users set up" do
    setup do
      @people = ["Christoph", "Sebastian", "Andrea"].map {|name| Person.create!(:name => name, :email => name.downcase + '@example.com')}
    end
    
    should "GET /" do
      get '/'
      assert last_response.ok?
      assert last_response.body.include?('Punchcard')
    end
    
    context "GET /status.json" do
      setup { get '/status.json' }
      should("respond with success") { assert last_response.ok? }

      context "the JSON body" do
        setup { @json = JSON.parse(last_response.body) }
        should("be a Hash") { assert_equal Hash, @json.class }
        should("have 3 people") { assert_equal 3, @json["people"].length }
        should "have all ids, names and emails in people array" do
          @people.each do |person|
            assert @json["people"].any? {|p| p["name"] == person.name && p["email"] == person.email && p["_id"] == person.id }
          end
        end
        
        should "have all people punched out" do
          assert @json["people"].all? {|p| @json["checked_in_at"] == nil }
        end
      end
    end
    
    context "POST /punch/:id" do
      setup do
        post "/punch/#{@people.first.id}"
      end
      should("respond with success") { assert last_response.ok? }
      should "include the person details in response as JSON" do
        json = JSON.parse(last_response.body)
        person = @people.first.reload
        assert_equal person.name, json["name"]
        assert_equal person.email, json["email"]
        assert_equal person.id, json["_id"]
        assert Time.xmlschema(json["checked_in_at"]) > 10.seconds.ago
      end
      
      context "GET /status.json" do
        setup { get '/status.json' }
        should("respond with success") { assert last_response.ok? }

        context "the JSON body" do
          setup { @json = JSON.parse(last_response.body) }

          should "have 1 person punched in" do
            assert_equal 1, @json["people"].reject {|p| p["checked_in_at"] == nil}.count
          end
        end
      end
    end
    
    should "GET /css/screen.css" do
      get '/css/screen.css'
      assert last_response.ok?
      assert last_response.body.include?('font-family')
    end
  end
end
