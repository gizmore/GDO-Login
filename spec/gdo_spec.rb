require "byebug"
require "mysql2"
require "GDO/Login"

RSpec.describe ::GDO::Login do
  
  it "can connect to the database" do
      db = ::GDO::DB::Connection.new('localhost', 'rubygdo', 'rubygdo', 'rubygdo')
      expect(db.get_link).to be_truthy
  end
  
  it "can install the login module" do
   ::GDO::Login::Module.instance.install
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
    method = gdo_module('Login').gdo_method('Form') # get method
    method.set_parameters(login: 'gizmore', password: '11111111', submit: "1") # setup parameters
    response = method.execute_method # run it
    expect(response._code).to eq(200)
  end

  
end
