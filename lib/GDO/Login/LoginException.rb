#
# A login exception occurs on failed login attempts.
# It defaults an error message (good idea) and has a code of 403.
#
# @see GDO::Login::Method::Form
#
# @version 1.00
# @since 1.00
# @author gizmore@wechall.net
# @license MIT
#
class GDO::Login::LoginException < GDO::Core::Exception
  def initialize
    super(t(:err_login_failure), 403)
  end
end
