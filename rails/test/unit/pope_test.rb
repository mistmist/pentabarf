require File.dirname(__FILE__) + '/../test_helper'

class PopeTest < Test::Unit::TestCase

  def setup
    POPE.deauth
  end

  def test_single_domain_permissions
    chunky = Person.new
    chunky.public_name = 'Chunky Bacon'
    assert_raise( Pope::PermissionError ) { chunky.write }
    POPE.instance_eval{ @permissions = [:create_person] }
    assert_nothing_raised{ chunky.write }
    assert_raise( Pope::PermissionError ) { chunky.delete }
    POPE.instance_eval{ @permissions = [:delete_person] }
    assert_nothing_raised{ chunky.delete }
  end

  def test_multiple_domain_permissions
    speaker = Event_person.new({:event_id=>23,:person_id=>1,:event_role_id=>1,:event_role_state_id=>1})
    assert_raise( Pope::PermissionError ) { speaker.write }
    POPE.instance_eval{ @permissions = [:modify_person] }
    assert_raise( Pope::PermissionError ) { speaker.write }
    POPE.instance_eval{ @permissions = [:modify_event] }
    assert_raise( Pope::PermissionError ) { speaker.write }
    POPE.instance_eval{ @permissions = [:modify_person,:modify_event] }
    assert_nothing_raised{ speaker.write }
    assert_nothing_raised{ speaker.delete }
  end

end
