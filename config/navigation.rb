SimpleNavigation::Configuration.run do |navigation|
  navigation.register_renderer :custom_breadcrumbs => CustomBreadcrumbs
  navigation.active_leaf_class = 'active'
  navigation.consider_item_names_as_safe = true
end
