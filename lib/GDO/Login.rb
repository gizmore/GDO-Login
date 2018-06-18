require "gdo"
#
# Provides basic authentification.
#
# @see GDO
# @author gizmore
#
module GDO::Login
  VERSION = 1.00    # GDO-1.00
  extend ::GDO::Autoloader # Own GDO Autoloader
end

# Autoload module
::GDO::Login::Module.instance
