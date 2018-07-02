require "gdo"
#
# Provides basic authentification.
#
# @see GDO
# @author gizmore
#
module GDO::Login
  extend ::GDO::Autoloader # Own GDO Autoloader
end

# Autoload module
::GDO::Login::Module.instance
