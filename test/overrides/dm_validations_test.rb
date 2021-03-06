require 'test_helper'

# See data_mapper_test.rb in this folder for what this file is doing.
if DEVISE_ORM == :data_mapper

  class ValidatableTest < ActiveSupport::TestCase
    undef test_should_require_a_password_with_minimum_of_6_characters

    # DataMapper uses a :value_between error message when given a minimum and
    # maximum; ActiveModel shows either the :too_long or :too_short message.
    test 'should require a password with minimum of 6 characters' do
      user = new_user(:password => '12345', :password_confirmation => '12345')
      assert user.invalid?
      # assert_equal 'is too short (minimum is 6 characters)', user.errors[:password].join
      assert_equal 'must be between 6 and 128 characters long', user.errors[:password].join
    end

    undef test_should_require_a_password_with_maximum_of_128_characters_long

    # Same issue as previous test
    test 'should require a password with maximum of 128 characters long' do
      user = new_user(:password => 'x'*129, :password_confirmation => 'x'*129)
      assert user.invalid?
      # assert_equal 'is too long (maximum is 20 characters)', user.errors[:password].join
      assert_equal 'must be between 6 and 128 characters long', user.errors[:password].join
    end

    undef test_should_complain_about_length_even_if_possword_is_not_required

    test 'should complain about length even if possword is not required' do
      user = new_user(:password => 'x'*129, :password_confirmation => 'x'*129)
      user.stubs(:password_required?).returns(false)
      assert user.invalid?
      assert_equal 'must be between 6 and 128 characters long', user.errors[:password].join
    end
  end
end
