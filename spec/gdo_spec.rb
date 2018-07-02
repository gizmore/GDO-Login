require "byebug"
require "mysql2"
require "GDO/Login"

RSpec.describe ::GDO::Login do
  
#  it "can switch to bot language" do
#    ::GDO::Lang::Trans.instance.iso(:bot)
#  end
  
  it "can connect to the database" do
      db = ::GDO::DB::Connection.new('localhost', 'rubygdo', 'rubygdo', 'rubygdo')
      expect(db.get_link).to be_truthy
  end
  
  it "can install the login module" do
    mod = ::GDO::Login::Module.instance
   ::GDO::Core::ModuleInstaller.instance.drop_module mod
   ::GDO::Core::ModuleInstaller.instance.install_module mod
  end
  
  it "can configure the login module" do
    mod = ::GDO::Login::Module.instance
    mod.save_config_var(:login_captcha, '0') # no captcha for tests :/
    mod.save_config_var(:login_tries, '4') 
    mod.save_config_var(:login_timeout, '3')
    mod.save_config_var(:login_tos, '0')
    mod.save_config_var(:login_tos, '0')
    
    expect(mod.cfg_tries).to eq(4)
  end
  
  it "does display a login form" do
    method = gdo_module('Login').gdo_method('Form') # get method
    method.set_parameters(login: 'gizmore', password: '11111111') # setup parameters
    response = method.execute_method # run it
    
    expect(response._fields[0]).to be_a(::GDO::Form::GDT_Form) # the response is just a form
    expect(response._fields[0]._fields.length >= 4).to be_truthy # with at least 4 fields
    expect(response._code).to eq(200) # and has 200 response code
  end
  
  it "can fail at logins" do
    method = gdo_module('Login').gdo_method('Form') # get method
    method.set_parameters(login: 'gizmore', password: '111111112', submit: "1") # setup parameters
    response = method.execute_method # run it
    expect(response._code).to eq(403)
  end

  it "can succeed at logins" do
    ::GDO::Core::Application.new_request
    method = gdo_module('Login').gdo_method('Form') # get method
    method.set_parameters(login: 'gizmore', password: '11111111', submit: "1") # setup parameters
    response = method.execute_method # run it
    expect(response._code).to eq(200)
    expect(::GDO::User::GDO_User.current.display_name).to eq("gizmore")
  end
  
  it "can logout" do
    ::GDO::Core::Application.new_request
    expect(::GDO::User::GDO_User.current.display_name).to eq("gizmore")
    method = ::GDO::Login::Method::Logout.new
    method.set_parameters(submit: "1")
    response = method.execute_method # run it
    expect(response._code).to eq(200)
    expect(::GDO::User::GDO_User.current).to equal(::GDO::User::GDO_User.ghost)
  end
  
  it "can exceed login attempts" do
    
    # Excpect a ghost user
    expect(::GDO::User::GDO_User.current).to equal(::GDO::User::GDO_User.ghost)

    # Load module and config to test
    mod = gdo_module('Login')
    tries = mod.cfg_tries
    timeout = mod.cfg_timeout
    expect(tries).to eq(4)

    # Craft login call
    method = gdo_module('Login').gdo_method('Form') # get method
    method.set_parameters({
      login: 'gizmore',
      password: 'WRONG',
      submit: "1"
    })
    
    # Now exceed logins
    # 1 try is left from failure test. so it sums to 4!
    ::GDO::Core::Application.new_request
    expect(method.execute_method._exception).to be_a(::GDO::Login::LoginException)
    ::GDO::Core::Application.new_request
    expect(method.execute_method._exception).to be_a(::GDO::Login::LoginException)
    ::GDO::Core::Application.new_request
    expect(method.execute_method._exception).to be_a(::GDO::Login::LoginException)
    
    # The next logins are exceeded...
    method.set_parameters({
      login: 'gizmore',
      password: '11111111', # ... even with correct pass!
      submit: "1"
    })
    ::GDO::Core::Application.new_request
    expect(method.execute_method._exception).to be_a(::GDO::Login::LoginsExceededException)
    ::GDO::Core::Application.new_request
    expect(method.execute_method._exception).to be_a(::GDO::Login::LoginsExceededException)
    ::GDO::Core::Application.new_request
    expect(::GDO::User::GDO_User.current).to equal(::GDO::User::GDO_User.ghost) # still ghost
    sleep(3) # wait....
    # Now it works again!
    ::GDO::Core::Application.new_request
    expect(method.execute_method._code).to eq(200)
    expect(::GDO::User::GDO_User.current.display_name).to eq("gizmore")
  end

  
end
