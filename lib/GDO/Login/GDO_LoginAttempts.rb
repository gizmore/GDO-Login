#
# Database table that holds login attempts.
#
# @see GDO::Core::GDO
# @see GDO::Net::GDT_IP
# @see GDO::User::GDT_User
#
# @version 1.00
# @since 1.00
# @license MIT
# @author gizmore@wechall.net
#
class GDO::Login::GDO_LoginAttempts < GDO::Core::GDO
  
  ###########
  ### GDO ###
  ###########
  def fields
    [
      ::GDO::Net::GDT_IP.make(:la_ip).not_null,
      ::GDO::User::GDT_User.make(:la_user),
      ::GDO::Date::GDT_CreatedAt.make(:la_created)
    ]
  end
  
  ##############
  ### Helper ###
  ##############
  #
  # Insert a login attempt.
  #
  # @see GDO::Net::GDT_IP
  #
  def login_failure(user=nil)
    blank(
      la_ip: ::GDO::Net::GDT_IP.current,
      la_user: user.get_id,
    ).insert
  end
  
end
