#
# Database table that holds login attempts.
#
# @see ::GDO::Core::GDO
# @see ::GDO::Net::GDT_IP
# @see ::GDO::User::GDT_User
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
  def login_failure(user=nil)
    ip = ::GDO::Net::GDT_IP.current
    attempt = blank(la_ip: ip, la_user: user)
    attempt.insert
  end
  
end
