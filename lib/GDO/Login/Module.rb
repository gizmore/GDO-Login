#
# Login module for GDO.
#
# - Configure login tries and timeout
# - Supports alerts on failed logins
# - Supports login history
# - Features TermsOfService forcing
# - Optional Captcha
#
# Various modules hook the form event.
# The event is something like :gdo_form_login_form(form)
#
# @see ::GDO::Core::GDO_Module
# @see ::GDO::Register::Module
#
# @version 1.00
# @since 1.00
# @author gizmore@wechall.net
# @license MIT
#
class GDO::Login::Module < GDO::Core::GDO_Module
  ##############
  ### Module ###
  ##############
  is_module __FILE__ # Register as GDO module
  def on_load_language; load_language('lang/login'); end # Load Trans file
  
  ##################
  ### GDO tables ###
  ##################
  #
  # Tables to install.
  #
  # @see GDO::Login::GDO_LoginHistory
  # @see GDO::Login::GDO_LoginAttempts
  #
  def tables
    [
      ::GDO::Login::GDO_LoginHistory,
      ::GDO::Login::GDO_LoginAttempts,
    ]
  end
  
  ##############
  ### Config ###
  ##############
  #
  # Module configuration vars
  # @return [GDT[]]
  #
  def module_config
    [
      ::GDO::DB::GDT_Boolean.new('login_tos').initial("0"),
      ::GDO::Net::GDT_Url.new('login_tos_url').reachable.protocols('http','https'),
      ::GDO::DB::GDT_UInt.new('login_tries').min("0").max("100").initial("5").bytes(2),
      ::GDO::Date::GDT_Duration.new('login_timeout').min("0").initial("300"),
      ::GDO::DB::GDT_Boolean.new('login_captcha').initial("0"),
    ]
  end
  def cfg_tos; config_value('login_tos'); end # @ return [Boolean]
  def cfg_tos_url; config_var('login_tos_url'); end # @ return [String]
  def cfg_tries; config_value('login_tries'); end # @ return [Numeric]
  def cfg_timeout; config_value('login_timeout'); end # @ return [Numeric]
  def cfg_captcha; config_value('login_captcha'); end # @ return [Boolean]
      
end
