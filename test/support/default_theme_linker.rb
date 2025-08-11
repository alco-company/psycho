# test/support/default_theme_linker.rb
module DefaultThemeLinker
  def link_default_themes
    tenants(:one).update!(default_theme: themes(:default_one)) rescue nil
    tenants(:two).update!(default_theme: themes(:two_theme))   rescue nil
    tenants(:acme).update!(default_theme: themes(:acme_theme)) rescue nil
  end
end
