#
module GDO::Login::Method
  #
  # Login Form.
  # Basic password authentification.
  #
  # @version 1.00
  # @since 1.00
  # @license MIT
  # @author gizmore@wechall.net
  #
  class Form < ::GDO::Method::Form
    
    def form(form)
      form.add_field ::GDO::DB::GDT_String.make('login').not_null # login is either email or username
      form.add_field ::GDO::Form::GDT_Password.make('password').not_null
      form.add_field ::GDO::Form::GDT_Submit.make
      form.add_field ::GDO::Form::GDT_CSRF.make
      self
    end
    
    def execute_submit
      
      ban_check
      
      login = parameter(:login)._var
      password = parameter(:password)._var
      
      user = ::GDO::User::GDO_User.table.get_by_login(login)
      return login_failure if user.nil?
      return login_failure unless user.column(:user_password).validate_password(password)
      return login_success
    end
    
    def login_success
      ::GDO::Method::GDT_Response.make_with(
        ::GDO::UI::GDT_Success.make.text(t(:msg_authenticated))
      )
    end
    
    #################
    ### Ban Check ###
    #################
    def ban_cut; (::Time.now - ban_timeout).to_i; end
    def ban_tries; ::GDO::Login::Module.instance.cfg_tries; end
    def ban_timeout; ::GDO::Login::Module.instance.cfg_timeout; end
    def ban_check
      ban_data = self.ban_data
      num_tries = ban_data[1].to_i
      if num_tries >= ban_tries
        time_left = (Time.now - ban_data[0]).to_i
        raise ::GDO::Core::Exception.new(t(:err_login_tries_exceeded, ban_tries, tt(time_left)))
      end
    end
    def ban_data
      ip = ::GDO::Net::GDT_IP.current
      result = ::GDO::Login::GDO_LoginAttempts.table.
       select('UNIX_TIMESTAMP(MIN(la_created)), COUNT(*)').
       where("la_ip=#{quote(ip)} AND la_created>FROM_UNIXTIME(#{quote(ban_cut)})").
       execute.fetch_row
       
    end
    
    ###############
    ### Failure ###
    ###############
    def login_failure(user=nil)
      ::GDO::Login::GDO_LoginAttempts.table.login_failure(user)
      response_with(::GDO::UI::GDT_Error.make.text(t(:err_login_failure))).code(403)
    end
    
  end
end
