#
# Database table that holds sucessful login history.
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
class GDO::Login::GDO_LoginHistory < GDO::Core::GDO
  
  def fields
    [
      ::GDO::Net::GDT_IP.make(:lh_ip).not_null,
      ::GDO::User::GDT_User.make(:lh_user).not_null,
      ::GDO::Date::GDT_CreatedAt.make(:lh_created)
    ]
  end
  
end
