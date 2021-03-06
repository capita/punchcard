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
    
    context "that got punched 2 hours ago" do
      setup do
        Timecop.freeze(2.hours.ago) do
          assert @person.punch!.instance_of?(Punch), "Should have been able to get punched and have returned a Punch"
        end
      end
      
      should "have one pending punch" do
        assert_equal Punch, @person.pending?.class
        assert_equal 1, @person.punches.pending.count
        assert_equal 0, @person.punches.finished.count
      end
      
      should "not allow to create another pending punch" do
        assert_raise ActiveRecord::RecordInvalid do
          @person.punches.create!
        end
      end
      
      should "return an appropriate (virtual) amount of minutes while pending" do
        assert_equal 120, @person.punches.first.minutes
      end
      
      context "and checked out 25 minutes ago" do
        setup do
          Timecop.freeze(25.minutes.ago) do
            assert @person.punch!.instance_of?(Punch), "Should have been able to get punched and have returned a Punch"
          end
        end
        
        should "have finished the pending punch" do
          assert @person.punches.first.checked_out_at < 24.minutes.ago and @person.punches.first.checked_out_at > 26.minutes.ago
        end
        
        should "have set the proper amount of minutes" do
          assert_equal 95, @person.punches.first.minutes
        end
        
        should "not be pending" do
          assert_nil @person.pending?
        end
        
        should "have one punch and no pending punches" do
          assert_equal 1, @person.punches.count
          assert_equal 0, @person.punches.pending.count
          assert_equal 1, @person.punches.finished.count
        end
        
        context "and punches in again now" do
          setup do
            assert @person.punch!.instance_of?(Punch), "Should have been able to get punched and have returned a Punch"
          end
          
          should "be pending" do
            assert @person.pending?
          end
          
          should "have 1 punch by having reopened the old one" do
            assert_equal 1, @person.punches.count
            assert_equal 1, @person.punches.pending.count
            assert_equal 0, @person.punches.finished.count
          end
        end
        
        context "and gets punched yet again 1 hour later" do
          setup do
            Timecop.freeze(1.hour.from_now) do
              assert_nil @person.pending?
              assert @person.punch!.instance_of?(Punch), "Should have been able to get punched and have returned a Punch"
            end
          end
          
          should "be pending" do
            assert @person.pending?
          end

          should "have 2 punches and one pending punch" do
            assert_equal 2, @person.punches.count
            assert_equal 1, @person.punches.pending.count
            assert_equal 1, @person.punches.finished.count
          end
        end
      end
    end
    
    context "that punched in just now" do
      setup do
        @person.punch!
      end
      
      should "be punched in" do
        assert @person.pending?
      end
      
      context "and punches out shortly after that" do
        setup do
          @person.punch!
        end
        
        should "not have any punches because of the automatic deletion of too-short punches" do
          assert_equal 0, @person.punches.count
        end
      end
    end
    
    context "that punched in yesterday" do
      setup do
        Timecop.freeze(1.day.ago) do
          @person.punch!
        end
      end
      
      context "and punches out today" do
        setup do
          @person.punch!
        end
        
        should "result in the punch out getting moved to the end of yesterday" do
          checkout_time = @person.punches.finished.first.checked_out_at
          assert_equal 1.day.ago.end_of_day.utc.to_date, checkout_time.utc.to_date
          assert_equal 23, checkout_time.hour
          assert_equal 59, checkout_time.min
        end
      end
    end
  end
end
