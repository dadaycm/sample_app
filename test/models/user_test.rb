require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new name: 'Example User', email: 'user@example.com',
                     password: 'pinklady', password_confirmation: 'pinklady'
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = ''
    assert_not @user.valid?
  end
  test 'email blanks should be present' do
    @user.email = '    '
    assert_not @user.valid?
  end
  test 'email empty' do
    @user.email = ''
    assert_not @user.valid?
  end
  # too short
  test 'name should not be too short' do
    @user.name = '333'
    assert_not @user.valid?
  end
  # too long
  test 'name should not be too long' do
    @user.name = 'z' * 51
    assert_not @user.valid?
  end
  test 'email should not be too long' do
    @user.name = 'z' * 255 + '@example.com'
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w(user@example.com
                         USER@foo.COM
                         A_US-ER@foo.bar.org
                         first.last@foo.jp
                         alice+bob@baz.cn)
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w( user@example,com
                            user_at_foo.org
                            user.name@example.
                            foo@bar_baz.com
                            foo@bar+baz.com)
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  # unique
  test 'email address should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end
  test 'email address should be unique : case sensitive' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  test 'email should be saved as lower-case' do
    special_case_email = 'DaDaycm@gMail.COm'
    @user.email = special_case_email
    @user.save
    assert_equal special_case_email.downcase, @user.reload.email
  end
  ### authenticate
  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 7
    assert_not @user.valid?
  end
  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end
end
