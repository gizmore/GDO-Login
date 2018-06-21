#
# GDO Logout method.
# 
#
# @event :gdo_user_signed_out
#
# @see GDO::Method::Form
# @see GDO::Core::WithEvents
#
# @version 1.00
# @since 1.00
# @license MIT
# @author gizmore@wechall.net
#
class ::GDO::Login::Method::Logout < ::GDO::Method::Form
  
    #
    # Decorate form
    #
    def form(form)
      form.add_field ::GDO::Form::GDT_Submit.new
      form.add_field ::GDO::Form::GDT_CSRF.new
      self
    end
    
    #
    # Logs the user out
    #
    def execute_submit
      # Logout
      user = ::GDO::User::GDO_User.current
      ::GDO::User::GDO_User.current = nil
      # Call event
      publish(:gdo_user_signed_out, user)
      # Build response
      response_with(
        ::GDO::UI::GDT_Success.new.text(t(:msg_signed_out)),
      )
    end
  
end
