require 'helper'

class TestDatabase < Test::Unit::TestCase
  context "A vanilla person" do
    setup { @person = Person.new }
    should "not be valid" do
      assert !@person.valid?
    end
  end
  
  context "A newly created person" do
    setup do
      @person = Person.create(:name => 'Christoph Olszowka', :email => 'foo@example.com')
    end
    
    should "have no punches" do
      assert_equal 0, @person.punches.count
    end
    
    should "not be pending" do
      assert_nil @person.pending?
    end
    
    context "that gets punched" do
      setup do
        assert @person.punch!.instance_of?(Punch), "Should have been able to get punched and have returned a Punch"
      end
      
      should "have one pending punch" do
        assert_equal Punch, @person.pending?.class
        assert_equal 1, @person.punches.pending.length
        assert_equal 0, @person.punches.finished.length
      end
      
      should "not allow to create another pending punch" do
        assert_raise Mongoid::Errors::Validations do
          @person.punches.create!
        end
      end
      
      context "and gets punched again" do
        setup do
          assert @person.punch!.instance_of?(Punch), "Should have been able to get punched and have returned a Punch"
        end
        
        should "have finished the pending punch" do
          assert @person.punches.first.checked_out_at > 5.seconds.ago
        end
        
        should "not be pending" do
          assert_nil @person.pending?
        end
        
        should "have one punch and no pending punches" do
          assert_equal 1, @person.punches.count
          assert_equal 0, @person.punches.pending.length
          assert_equal 1, @person.punches.finished.length
        end
        
        context "and gets punched yet again" do
          setup do
            assert @person.punch!.instance_of?(Punch), "Should have been able to get punched and have returned a Punch"
          end
          
          should "be pending" do
            assert @person.pending?
          end

          should "have 2 punches and one pending punch" do
            assert_equal 2, @person.punches.count
            assert_equal 1, @person.punches.pending.length
            assert_equal 1, @person.punches.finished.length
          end
        end
      end
    end
  end
end
