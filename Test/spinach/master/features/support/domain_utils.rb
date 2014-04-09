def domain_remove_www(domain)
  domain.split('.').drop(1).join('.')
end
